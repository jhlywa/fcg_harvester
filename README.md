# FICS Chess Game Harvester

This script connects to the Free Internet Chess Server (freechess.org)
and downloads games as they complete.  All games are output in Portable
Game Notation format (http://en.wikipedia.org/wiki/Pgn).  Games are written
to stdout.

## Usage
```
Usage: fcg_harvester.rb [options]

Options:
    -n NUMBER        Specifies the number of games to harvest (default 1).
    -h, --help       Show this help message and exit.
```

## Example
Calling the script with no arguments returns one game:
```
$ fcg_harvester.rb
[Event "FICS rated blitz game"]
[Site "FICS, San Jose, California USA"]
[Date "2010-08-02 10:24"]
[White "redacted"]
[Black "redacted"]
[WhiteElo "1606"]
[BlackElo "1623"]
[TimeControl "3+0"]
[Result "0-1"]

1. e4 c5 2. Nf3 d6 3. c3 Nf6 4. Qc2 Bg4 5. Be2 Nc6 6. h3 Bxf3 7. Bxf3 Ne5
8. Be2 d5 9. f4 Nc6 10. e5 Ne4 11. Bb5 Ng3 12. Rg1 e6 13. Bxc6+ bxc6
14. d3 Be7 15. Be3 Bh4 16. Bf2 Nf5 17. g3 Be7 18. g4 Nh6 19. Nd2 Rb8
20. Nf3 f6 21. exf6 gxf6 22. O-O-O Qa5 23. a3 c4 24. dxc4 Bxa3 25. cxd5 Rxb2
26. Qxb2 Bxb2+ 27. Kxb2 cxd5 28. g5 fxg5 29. Nxg5 Ke7 30. Bh4 Rb8+ 31. Kc2 Qa2+
32. Kd3 Qc4+ 33. Ke3 Nf5+ 34. Kf3 Nxh4+ 35. Kg4 Ng6 36. Rgf1 Qe2+ 37. Kg3 h5
38. Rfe1 h4# {White checkmated} 0-1
```

## License
```
Copyright (c) 2014, Jeff Hlywa (jhlywa@gmail.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
```
