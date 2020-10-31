module docii.declarations;

/++
 +
 +/
string formatDecl(T)(T element)
{
    import std.conv : to;
    import std.array : join;

    static if (is(T == DeclarationLocation))
    {
        DeclarationLocation location = cast (DeclarationLocation) element;
        return location.path ~ "(" ~ location.filename ~ "):" ~ location.line.to!string;
    }
    else static if (is(T == DociiFunctionDeclaration))
    {
        DociiFunctionDeclaration decl = cast (DociiFunctionDeclaration) element;
        return decl.returnType ~ " " ~ decl.name ~ "(" ~ decl.templateParameters.join(", ") ~ ")(" ~ decl.parameters.join(", ") ~ ") " ~ decl.attributes.join(" ") ~ ";";
    }
    else static if (is(T == DociiVariableDeclaration))
    {
        DociiVariableDeclaration decl = cast (DociiVariableDeclaration) element;
        if (decl.value != "")
            return decl.valueType ~ " " ~ decl.name ~ " = " ~ decl.value ~ ";";
        else
            return decl.valueType ~ " " ~ decl.name ~ ";";
    }
    else static if (is(T == DociiDeclaration))
    {
        DociiDeclaration decl = cast (DociiDeclaration) element;
        return decl.name;
    }
    else
    {
        throw Exception("Incompatible type: " ~ typeof(T).to!string);
    }
}

/++
 +
 +/
enum DeclarationType
{
    TOPLEVEL,

    VARIABLE,
    FUNCTION,
    STRUCT,
    ENUM,
    CLASS,
    INTERFACE,
    MIXIN,
    PRAGMA,
    TEMPLATE,
    UNION,
    IMPORT,
    MODULE
}

/++
 +
 +/
struct DeclarationLocation
{
    ///
    string path;

    ///
    string filename;

    ///
    size_t line;
}

/++
 +
 +/
class DociiDeclaration
{
    /// The name of the declaration
    string name;

    /// The comment of the declaration
    string comment;

    /// The type of declaration
    DeclarationType type;

    /// The position in the file the declaration is in
    DeclarationLocation location;

    /// All sub-declarations
    DociiDeclaration[] declarations;

    /++
     +
     +/
    this(string n, string c, DeclarationType t, DeclarationLocation l)
    {
        this(n, c, t, l, []);
    }

    /++
     +
     +/
    this(string n, string c, DeclarationType t, DeclarationLocation l, DociiDeclaration[] decls)
    {
        this.name = n;
        this.comment = c;
        this.type = t;
        this.location = l;
        this.declarations = decls;
    }

    /++
     +
     +/
    void addDeclaration(DociiDeclaration decl)
    {
        import std.stdio : writeln;
        //writeln(decl.name);

        declarations ~= decl;
    }
}

/++
 +
 +/
class DociiFunctionDeclaration : DociiDeclaration
{
    ///
    string returnType;

    ///
    string[] templateParameters;

    ///
    string[] parameters;

    ///
    string[] attributes;

    /++
     +
     +/
    this(string name, string comment, DeclarationLocation location, string type, string templateParams, string params, string[] attrs)
    {
        super(name, comment, DeclarationType.FUNCTION, location);

        import std.array : split;

        this.returnType = type;
        this.templateParameters = templateParams != "()" ? templateParams[1..$ - 1].split(", ") : [];
        this.parameters = params != "()" ? params[1..$ - 1].split(", ") : [];
        this.attributes = attrs;
    }
}

/++
 +
 +/
class DociiVariableDeclaration : DociiDeclaration
{
    ///
    string valueType;

    ///
    string value;

    /++
     +
     +/
    this(string name, string comment, DeclarationLocation location, string type, string val)
    {
        super(name, comment, DeclarationType.VARIABLE, location);

        this.valueType = type;
        this.value = val;
    }
}