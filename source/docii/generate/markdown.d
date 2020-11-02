module docii.generate.markdown;

import docii.generate.generator;
import docii.parse.declarations;
import docii.parse.docs;
import docii.log : logger, Color;

/++
 +
 +/
class DociiMarkdownGenerator : DociiGenerator
{

    private
    {
        string outputPath;
        DociiDeclaration top;
        Doc[string] docs;
        bool verbose;
    }

    /++
     +
     +/
    this(string outputPath, DociiDeclaration top, Doc[string] docs, bool verbose)
    {
        this.outputPath = outputPath;
        this.top = top;
        this.docs = docs;
        this.verbose = verbose;
    }

    /++
     +
     +/
    void generateFile()
    {

    }
}