FICS Chess Game Harvester
=========================

This script connects to the Free Internet Chess Server (freechess.org)
and downloads games as they complete.  All games are output in Portable
Game Notation format (http://en.wikipedia.org/wiki/Pgn).  Games will be
output to stdout if called without a filename argument.

Usage
-----
    Usage: fcg_harvester.rb [options] [file]

    Options:
        -n NUMBER        Specifies the number of games to harvest (default 1).
        -h, --help       Show this help message and exit.

Example
-------
Calling the script with no arguments returns one game:

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
