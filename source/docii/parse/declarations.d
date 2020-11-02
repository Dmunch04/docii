module docii.parse.declarations;

import std.conv;
import std.array;
import std.string;

private string[] splitStrip(string s, string sep = ",")
{
    string[] items = s.split(sep);
    foreach(ref e; items)
    {
        e = e.strip();
    }
    return items;
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

    /++
     +
     +/
    @property string toString()
    {
        import std.format : format;
        return format!"%s:%d"(path, line);
    }
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
        declarations ~= decl;
    }

    /++
     +
     +/
    string makeSignature()
    {
        return name;
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

        this.returnType = type;
        this.templateParameters = templateParams != "()" ? splitStrip(templateParams[1..$ - 1]) : [];
        this.parameters = params != "()" ? splitStrip(params[1..$ - 1]) : [];
        this.attributes = attrs;
    }

    ///
    @property bool hasTemplateParemeters() { return templateParameters.length > 0; }

    ///
    @property bool hasAttributes() { return attributes.length > 0; }

    /++
     +
     +/
    override string makeSignature()
    {
        auto sig = appender!string;
        sig.put(returnType);
        sig.put(" ");
        sig.put(name);
        if (hasTemplateParemeters)
        {
            sig.put("(");
            sig.put(templateParameters.join(", "));
            sig.put(")");
        }
        sig.put("(");
        sig.put(parameters.join(", "));
        sig.put(")");
        if (hasAttributes)
        {
            sig.put(" ");
            sig.put(attributes.join(" "));
        }
        sig.put(";");

        return sig.data;
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

    ///
    @property bool hasValue() { return value != ""; }

    /++
     +
     +/
    override string makeSignature()
    {
        auto sig = appender!string;
        sig.put(valueType);
        sig.put(" ");
        sig.put(name);
        if (hasValue)
        {
            sig.put(" = ");
            sig.put(value);
        }
        sig.put(";");
        
        return sig.data;
    }
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

    /++
     +
     +/
    override string makeSignature()
    {
        auto sig = appender!string;
        sig.put("struct ");
        sig.put(name);
        sig.put(";");

        return sig.data;
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

    /++
     +
     +/
    override string makeSignature()
    {
        auto sig = appender!string;
        sig.put("enum ");
        sig.put(name);
        if (hasEnumType)
        {
            sig.put(" : ");
            sig.put(enumType);
        }
        sig.put(";");

        return sig.data;
    }
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

        this.templateParameters = templateParams != "()" ? splitStrip(templateParams[1..$ - 1]) : [];
        this.baseClasses = baseClasses != "()" ? splitStrip(baseClasses.strip().replaceFirst(":", "").strip()) : [];
    }

    ///
    @property bool hasTemplateParemeters() { return templateParameters.length > 0; }

    ///
    @property bool hasBaseClasses() { return baseClasses.length > 0; }

    /++
     +
     +/
    override string makeSignature()
    {
        auto sig = appender!string;
        sig.put("class ");
        sig.put(name);
        if (hasTemplateParemeters)
        {
            sig.put("(");
            sig.put(templateParameters.join(", "));
            sig.put(")");
        }
        if (hasBaseClasses)
        {
            sig.put(" : ");
            sig.put(baseClasses.join(", "));
        }
        sig.put(";");

        return sig.data;
    }
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

        this.templateParameters = templateParams != "()" ? splitStrip(templateParams[1..$ - 1]) : [];
        this.baseClasses = baseClasses != "()" ? splitStrip(baseClasses.strip().replaceFirst(":", "").strip()) : [];
    }

    ///
    @property bool hasTemplateParemeters() { return templateParameters.length > 0; }

    ///
    @property bool hasBaseClasses() { return baseClasses.length > 0; }

    /++
     +
     +/
    override string makeSignature()
    {
        auto sig = appender!string;
        sig.put("interface ");
        sig.put(name);
        if (hasTemplateParemeters)
        {
            sig.put("(");
            sig.put(templateParameters.join(", "));
            sig.put(")");
        }
        if (hasBaseClasses)
        {
            sig.put(" : ");
            sig.put(baseClasses.join(", "));
        }
        sig.put(";");

        return sig.data;
    }
}