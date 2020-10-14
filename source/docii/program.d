module docii.program;

import std.file;
import std.stdio;
import std.algorithm;

import docii.markdown;
import docii.parser;

/++
 +
 +/
struct Program
{
    private {
        string outputPath = "/docs";
    }

    /++
     +
     +/
    this(string[] args)
    {
        handleArgs(args[1..$]);
    }

    private void handleArgs(string[] args)
    {
        import std.getopt : getopt, defaultGetoptPrinter, GetOptException, config;

        try
        {
            auto help = getopt(
                args,
                config.caseInsensitive,

                "output|o", "The output directory where the docs should be generated in", &outputPath,
            );

            if (help.helpWanted)
            {
                defaultGetoptPrinter("All available arguments:", help.options);
            }
        }
        // If an unkown argument was passed, error out
        catch (GetOptException e)
        {
            // error: e.msg
        }

        if (args.length <= 0)
        {
            // error: no path specified
        }

        run(args[0]);
    }

    private void run(string path)
    {
        if (!exists(path))
        {
            // error
            return;
        }

        if (!isDir(path))
        {
            // error
            return;
        }

        auto files = dirEntries(path, SpanMode.depth).filter!(f => f.name.endsWith(".d"));
        auto parser = DParser();
        foreach(file; files)
        {
            auto res = parser.parseFile(readText(file));
        }
    }
}