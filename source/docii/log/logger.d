module docii.log.logger;

import std.stdio : writeln;
import core.stdc.stdlib : exit;

import docii.log.color;

/++
 +
 +/
struct Logger
{
    /++
     +
     +/
    void print(string s)
    {
        writeln(s);
    }

    /++
     +
     +/
    void printExit(string s, uint code = -1)
    {
        writeln(s);
        exit(code);
    }

    /++
     +
     +/
    void error(string s)
    {
        printExit(Color.BOLD_RED ~ "Error: " ~ Color.RESET ~ Color.RED ~ s);
    }
}

///
@property public Logger logger() @safe { return _logger; }
private Logger _logger;

static this()
{
    _logger = Logger();
}