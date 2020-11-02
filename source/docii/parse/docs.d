module docii.parse.docs;

import docii.parse.declarations;

/++
 +
 +/
public Doc parseComment(DeclarationType type, string comment)
{
    Doc doc;

    final switch (type)
    {
        case DeclarationType.TOPLEVEL:
        {
            doc = new Doc("");
            break;
        }

        case DeclarationType.VARIABLE:
        {
            doc = new VariableDoc(comment);
            break;
        }

        case DeclarationType.FUNCTION:
        {
            import std.array : split, join;
            import std.stdio : writeln;
            import std.string : strip;
            import std.algorithm : startsWith;
            import std.uni : toLower;

            string[] lines = comment.split('\n');
            string info;
            string[string] params;
            string returns;
            string throws;

            int j;
            foreach (i, line; lines)
            {
                // This is really hacky lol
                if (j != 0)
                {
                    j--;
                    continue;
                }

                if (line.toLower().startsWith("params:"))
                {
                    int k;
                    foreach (param; lines[i..$])
                    {
                        if (param.startsWith("     "))
                        {
                            param = param.strip();
                            string[] splitted = param.split("=");
                            string name = splitted[0].strip();
                            string value = join(splitted[1..$], "=").strip();
                            params[name] = value;

                            k++;
                        }
                    }
                    j = k;


                    continue;
                }
                else if (line.toLower().startsWith("returns:"))
                {
                    line = line[8..$];
                    returns = line.strip();

                    continue;
                }
                else if (line.toLower().startsWith("throws:"))
                {
                    line = line[7..$];
                    throws = line.strip();

                    continue;
                }
                else
                {
                    if (info != "")
                        info ~= line ~ "\n";
                    else
                        info ~= line;

                    continue;
                }
            }

            doc = new FunctionDoc(info, params, returns, throws);
            break;
        }

        case DeclarationType.STRUCT:
        {
            doc = new StructDoc(comment);
            break;
        }

        case DeclarationType.ENUM:
        {
            doc = new EnumDoc(comment);
            break;
        }

        case DeclarationType.CLASS:
        {
            doc = new ClassDoc(comment);
            break;
        }

        case DeclarationType.INTERFACE:
        {
            doc = new InterfaceDoc(comment);
            break;
        }

        case DeclarationType.MIXIN:
        {
            doc = new Doc("");
            break;
        }

        case DeclarationType.PRAGMA:
        {
            doc = new Doc("");
            break;
        }

        case DeclarationType.TEMPLATE:
        {
            doc = new Doc("");
            break;
        }

        case DeclarationType.UNION:
        {
            doc = new Doc("");
            break;
        }

        case DeclarationType.IMPORT:
        {
            doc = new Doc("");
            break;
        }

        case DeclarationType.MODULE:
        {
            doc = new Doc("");
            break;
        }
    }

    return doc;
}

/++
 +
 +/
class Doc
{
    ///
    string info;

    /++
     +
     +/
    this(string info)
    {
        this.info = info;
    }

    ///
    @property bool hasInfo() { return info != ""; }
}

/++
 +
 +/
class VariableDoc : Doc
{
    /++
     +
     +/
    this(string info)
    {
        super(info);
    }
}

/++
 +
 +/
class FunctionDoc : Doc
{
    ///
    string[string] params;

    ///
    string returns;

    ///
    string throws;

    /++
     +
     +/
    this(string info, string[string] params, string returns, string throws)
    {
        super(info);

        this.params = params;
        this.returns = returns;
        this.throws = throws;
    }

    ///
    @property bool hasParams() { return params.length != 0; }

    ///
    @property bool hasReturns() { return returns != ""; }

    ///
    @property bool hasThrows() { return throws != ""; }
}

/++
 +
 +/
class StructDoc : Doc
{
    /++
     +
     +/
    this(string info)
    {
        super(info);
    }
}

/++
 +
 +/
class EnumDoc : Doc
{
    /++
     +
     +/
    this(string info)
    {
        super(info);
    }
}

/++
 +
 +/
class ClassDoc : Doc
{
    /++
     +
     +/
    this(string info)
    {
        super(info);
    }
}

/++
 +
 +/
class InterfaceDoc : Doc
{
    /++
     +
     +/
    this(string info)
    {
        super(info);
    }
}