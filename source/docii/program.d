module docii.program;

import std.file;
import std.stdio;
import std.algorithm;

import docii.parse.parser;
import docii.parse.declarations;
import docii.log.logger;

/++
 +
 +/
enum DocsFormat
{
    markdown,
    html
}

/++
 +
 +/
struct Program
{
    private
    {
        string outputPath = "/docs";
        DocsFormat formatting = DocsFormat.markdown;
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
                "format|f", "The format of which the docs should be generated as. Can be 'markdown' or 'html'", &formatting
            );

            if (help.helpWanted)
            {
                defaultGetoptPrinter("All available arguments:", help.options);
            }
        }
        catch(Exception e)
        {
            logger.error(e.msg);
        }

        if (args.length <= 0)
        {
            logger.error("no path specified");
        }

        run(args[0]);
    }

    private void run(string path)
    {
        if (!exists(path))
        {
            logger.error("path does not exist (" ~ path ~ ")");
        }

        auto parser = DParser();

        // TODO: What should the generators output? A string or a struct/class holding the data

        if (isDir(path))
        {
            auto files = dirEntries(path, SpanMode.depth).filter!(f => f.name.endsWith(".d"));
            foreach(file; files)
            {
                DociiDeclaration fileDeclaration = parser.parseFile(file, readText(file));
            }
        }
        else
        {
            DociiDeclaration fileDeclaration = parser.parseFile(path, readText(path));
        }
    }
}