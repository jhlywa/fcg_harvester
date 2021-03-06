#!/usr/bin/env ruby

# Copyright (c) 2014, Jeff Hlywa (jhlywa@gmail.com)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

require 'date'
require 'enumerator'
require 'optparse'
require 'socket'

HOST = 'freechess.org'
PORT = 5000

class PGN
  attr_accessor :game, :date, :rated
  attr_accessor :white, :black, :white_rating, :black_rating
  attr_accessor :time, :increment, :short_result, :long_result

  def initialize(white, black, white_rating, black_rating, date)
    @white = white
    @black = black
    @white_rating = white_rating
    @black_rating = black_rating
    @date = date
    @moves = []
  end

  def <<(move)
    @moves << move
  end

  def moves_to_s
    # stringify the move list while inserting a newline every 7th move
    @moves.each_with_index.map { |m, i| (i > 0 && i % 6 == 0) ? "#{m}\n" : "#{m} " }.join
  end

  def to_s
    # output moves in PGN format
    "[Event \"FICS #{@rated} #{@game} game\"]\n" +
    "[Site \"FICS, San Jose, California USA\"]\n" +
    "[Date \"#{DateTime.parse(@date).strftime('%Y-%m-%d %H:%M')}\"]\n" +
    "[White \"#{@white}\"]\n" +
    "[Black \"#{@black}\"]\n" +
    "[WhiteElo \"#{@white_rating}\"]\n" +
    "[BlackElo \"#{@black_rating}\"]\n" +
    "[TimeControl \"#{@time}+#{@increment}\"]\n" +
    "[Result \"#{@short_result}\"]\n\n" +
    "#{moves_to_s}#{@long_result} #{@short_result}\n\n\n"
  end
end

options = {
  :games => 1,
  :types => %[blitz standard lightning],
  :filter => [],
}

# parse the command line parameters
optparse = OptionParser.new do |opts|
  opts.summary_width = 16
  opts.banner = "Usage: fcg_harvester.rb [options]"
  opts.separator ""
  opts.separator "Options:"
  opts.on('-n NUMBER', Integer, 'Specifies the number of games to harvest (default 1).') do |games|
    options[:games] = games
  end

  opts.on('-h', '--help', 'Show this help message and exit.') do
    puts opts
    exit
  end
  opts.separator ""
  opts.separator "This script connects to the Free Internet Chess Server (freechess.org) and"
  opts.separator "downloads chess games as they complete.   All games are written to stdout"
  opts.separator ""
end

# check for invalid options
begin
  optparse.parse!
rescue OptionParser::ParseError
  puts $!
  puts optparse
  exit
end

# these are the FICS end of game notices
notices = [
  /^\{Game \d+ \((.*) vs. (.*)\) .* resigns\}/,
  /^\{Game \d+ \((.*) vs. (.*)\) .* checkmated\}/,
  /^\{Game \d+ \((.*) vs. (.*)\) .* forfeits on time\}/,
  /^\{Game \d+ \((.*) vs. (.*)\) Game drawn by stalemate\}/,
  /^\{Game \d+ \((.*) vs. (.*)\) Game drawn by repetition\}/,
  /^\{Game \d+ \((.*) vs. (.*)\) .* ran out of time and .* has no material to mate\}/,
  /^\{Game \d+ \((.*) vs. (.*)\) Game drawn by mutual agreement\}/,
  /^\{Game \d+ \((.*) vs. (.*)\) Neither player has mating material\}/
]

# whitename (1800) vs. blackname (1715) --- Mon Aug  2, 07:00 PDT 2010
players = /(\w+) \((\d+|UNR)\) vs. (\w+) \((\d+|UNR)\) --- (.*)/

# Rated standard match, initial time: 15 minutes, increment: 0 seconds.
info = /^(\w+) (\w+|wild\/.*) match, initial time: (\d+) minutes, increment: (\d+) seconds.$/

# 1.  e4      (0:00)     e6      (0:00)
full_move = /^(\d+)\.\s+([^\s]+)\s+\(\d+:\d+\)\s+([^\s]+)\s+\(\d+:\d+\)$/

# 55.  a7      (0:01)
half_move = /^(\d+)\.\s+([^\s]+)\s+\(\d+:\d+\)$/

# {Black resigns} 1-0, or {Game drawn by mutual agreement} 1/2-1/2
result = /^(\{.*\})\s+(.*)/
# but not {Game 293 (GuestPKWS vs. socratez) socratez resigns}
notice = /^(\{Game \d+ .*)/


socket = TCPSocket.new(HOST, PORT)

# send 'g' for guest login
socket.puts("g\n\n\n")

while 1
  line = socket.gets.strip
  next if line.length == 0

  # log into the server and set server vars to quiet things down
  if line =~ /^Press return to enter the server as/
    socket.puts("\n")
    socket.puts("set shout 0\n")
    socket.puts("set cshout 0\n")
    socket.puts("set seek 0\n")
    socket.puts("set gin 1\n")
    socket.puts("-cha 1\n")
    socket.puts("-cha 4\n")
    socket.puts("-cha 53\n")
  end

  # check to see if a game has ended, if so issue the 'smoves name -1' command
  # to display a move list from that game
  notices.each do |regex|
    if line =~ regex
      socket.puts("smoves #{$1} -1\n")
      break
    end
  end

  # the regexs below are used to parse the output of the 'smove' command
  if line =~ players
    pgn = PGN.new($1, $3, $2, $4, $5)
  elsif line =~ info
    pgn.rated = $1.downcase
    pgn.game = $2
    pgn.time = $3
    pgn.increment = $4
  elsif line =~ full_move
    pgn << "#{$1}. #{$2} #{$3}"
  elsif line =~ half_move
    pgn << "#{$1}. #{$2}"
  elsif line !~ notice and line =~ result
    pgn.long_result = $1;
    pgn.short_result = $2;
    if options[:types].include?(pgn.game)
      # output the game
      puts pgn

      # dec the game counter
      options[:games] -= 1
      if options[:games] == 0
        socket.close
        exit
      end
    end
  end

end


