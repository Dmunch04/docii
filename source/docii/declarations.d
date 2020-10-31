module docii.declarations;

/++
 +
 +/
string formatDecl(DociiDeclaration element)
{
    import std.conv : to;
    import std.array : join, appender;

    if (DociiFunctionDeclaration decl = cast(DociiFunctionDeclaration) element)
    {
        auto sig = appender!string;
        sig.put(decl.returnType);
        sig.put(" ");
        sig.put(decl.name);
        if (decl.hasTemplateParemeters)
        {
            sig.put("(");
            sig.put(decl.templateParameters.join(", "));
            sig.put(")");
        }
        sig.put("(");
        sig.put(decl.parameters.join(", "));
        sig.put(")");
        if (decl.hasAttributes)
        {
            sig.put(" ");
            sig.put(decl.attributes.join(" "));
        }
        sig.put(";");

        return sig.data;
    }
    else if (DociiVariableDeclaration decl = cast(DociiVariableDeclaration) element)
    {
        auto sig = appender!string;
        sig.put(decl.valueType);
        sig.put(" ");
        sig.put(decl.name);
        if (decl.hasValue)
        {
            sig.put(" = ");
            sig.put(decl.value);
        }
        sig.put(";");
        
        return sig.data;
    }
    else if (DociiStructDeclaration decl = cast(DociiStructDeclaration) element)
    {
        auto sig = appender!string;
        sig.put("struct ");
        sig.put(decl.name);
        sig.put(";");

        return sig.data;
    }
    else if (DociiEnumDeclaration decl = cast(DociiEnumDeclaration) element)
    {
        auto sig = appender!string;
        sig.put("enum ");
        sig.put(decl.name);
        if (decl.hasEnumType)
        {
            sig.put(" : ");
            sig.put(decl.enumType);
        }
        sig.put(";");

        return sig.data;
    }
    else if (DociiClassDeclaration decl = cast(DociiClassDeclaration) element)
    {
        auto sig = appender!string;
        sig.put("class ");
        sig.put(decl.name);
        if (decl.hasTemplateParemeters)
        {
            sig.put("(");
            sig.put(decl.templateParameters.join(", "));
            sig.put(")");
        }
        if (decl.hasBaseClasses)
        {
            sig.put(" : ");
            sig.put(decl.baseClasses.join(", "));
        }
        sig.put(";");

        return sig.data;
    }
    else if (DociiInterfaceDeclaration decl = cast(DociiInterfaceDeclaration) element)
    {
        auto sig = appender!string;
        sig.put("interface ");
        sig.put(decl.name);
        if (decl.hasTemplateParemeters)
        {
            sig.put("(");
            sig.put(decl.templateParameters.join(", "));
            sig.put(")");
        }
        if (decl.hasBaseClasses)
        {
            sig.put(" : ");
            sig.put(decl.baseClasses.join(", "));
        }
        sig.put(";");

        return sig.data;
    }
    else
    {
        return element.name;
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
    this(string name, string comment, DeclarationLocation location, string type, string templateParams,
         string params, string[] attrs)
    {
        super(name, comment, DeclarationType.FUNCTION, location);

        import std.array : split;

        this.returnType = type;
        this.templateParameters = templateParams != "()" ? templateParams[1..$ - 1].split(", ") : [];
        this.parameters = params != "()" ? params[1..$ - 1].split(", ") : [];
        this.attributes = attrs;
    }

    ///
    @property bool hasTemplateParemeters() { return templateParameters.length > 0; }

    ///
    @property bool hasAttributes() { return attributes.length > 0; }
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

    ///
    @property bool hasValue() { return value != ""; }
}

/++
 +
 +/
class DociiStructDeclaration : DociiDeclaration
{
    /++
     +
     +/
    this(string name, string comment, DeclarationLocation location)
    {
        super(name, comment, DeclarationType.STRUCT, location);
    }
}

/++
 +
 +/
class DociiEnumDeclaration : DociiDeclaration
{
    ///
    string enumType;

    /++
     +
     +/
    this(string name, string comment, DeclarationLocation location, string enumType)
    {
        super(name, comment, DeclarationType.ENUM, location);

        this.enumType = enumType;
    }

    ///
    @property bool hasEnumType() { return enumType != ""; }
}

/++
 +
 +/
class DociiClassDeclaration : DociiDeclaration
{
    ///
    string[] templateParameters;

    ///
    string[] baseClasses;

    /++
     +
     +/
    this(string name, string comment, DeclarationLocation location, string templateParams, string baseClasses)
    {
        super(name, comment, DeclarationType.CLASS, location);

        import std.array : split, replaceFirst;
        import std.string : strip;

        this.templateParameters = templateParams != "()" ? templateParams[1..$ - 1].split(", ") : [];
        this.baseClasses = baseClasses != "()" ? baseClasses.strip().replaceFirst(":", "").strip().split(", ") : [];
    }

    ///
    @property bool hasTemplateParemeters() { return templateParameters.length > 0; }

    ///
    @property bool hasBaseClasses() { return baseClasses.length > 0; }
}

/++
 +
 +/
class DociiInterfaceDeclaration : DociiDeclaration
{
    ///
    string[] templateParameters;

    ///
    string[] baseClasses;

    /++
     +
     +/
    this(string name, string comment, DeclarationLocation location, string templateParams, string baseClasses)
    {
        super(name, comment, DeclarationType.INTERFACE, location);

        import std.array : split, replaceFirst;
        import std.string : strip;

        this.templateParameters = templateParams != "()" ? templateParams[1..$ - 1].split(", ") : [];
        this.baseClasses = baseClasses != "()" ? baseClasses.strip().replaceFirst(":", "").strip().split(", ") : [];
    }

    ///
    @property bool hasTemplateParemeters() { return templateParameters.length > 0; }

    ///
    @property bool hasBaseClasses() { return baseClasses.length > 0; }
}