module docii.parser;

import std.stdio;
import std.conv;
import std.array;

import dparse.lexer;
import dparse.parser : parseModule;
import dparse.ast;
import dparse.rollback_allocator : RollbackAllocator;
import dparse.formatter;

import docii.declarations;

private class DVisitor : ASTVisitor
{
    alias visit = ASTVisitor.visit;

    string path;
    string filename;
    DociiDeclaration parent;

    this(string path, string filename)
    {
        this.path = path;
        this.filename = filename;
        this.parent = new DociiDeclaration("top", "", DeclarationType.TOPLEVEL, DeclarationLocation(path, filename, 0));
    }

    override void visit(const FunctionDeclaration decl)
    {
        auto templateParameters = appender!string;
        if (decl.templateParameters !is null)
            format(templateParameters, decl.templateParameters);
        else
            templateParameters.put("()");

        auto parameters = appender!string;
        format(parameters, decl.parameters);

        string[] attributes = new string[decl.memberFunctionAttributes.length];
        int i;
        foreach (attribute; decl.memberFunctionAttributes)
        {
            auto attributeRepr = appender!string;
            format(attributeRepr, attribute);
            attributes[i] = attributeRepr.data;
            i++;
        }
        
        auto returnType = appender!string;
        format(returnType, decl.returnType);

        DociiDeclaration previous = parent;

        DociiDeclaration declaration = new DociiFunctionDeclaration(
            decl.name.text,
            decl.comment,
            DeclarationLocation(path, filename, decl.name.line),
            returnType.data,
            templateParameters.data,
            parameters.data,
            attributes
        );
        parent = declaration;

        scope (exit) parent = previous;

        previous.addDeclaration(declaration);

        decl.accept(this);
    }

	override void visit(const VariableDeclaration decl)
	{
        string name = decl.declarators[0].name.text;
        string comment = decl.comment;
        
        auto type = appender!string;
        format(type, decl.type);

        string init = "";
        if (decl.declarators[0].initializer)
        {
            init = decl.declarators[0].initializer.tokens[0].text;
        }

        DociiDeclaration declaration = new DociiVariableDeclaration(
            name,
            comment,
            DeclarationLocation(path, filename, decl.declarators[0].name.line),
            type.data,
            init
        );

        parent.addDeclaration(declaration);

        decl.accept(this);
	}

    override void visit(const StructDeclaration decl)
    {
        DociiDeclaration previous = parent;

        DociiDeclaration declaration = new DociiStructDeclaration(
            decl.name.text,
            decl.comment,
            DeclarationLocation(path, filename, decl.name.line)
        );
        parent = declaration;

        scope (exit) parent = previous;

        previous.addDeclaration(declaration);

        decl.accept(this);
    }

    override void visit(const EnumDeclaration decl)
    {
        auto enumType = appender!string;
        if (decl.type !is null)
            format(enumType, decl.type);
        else
            enumType.put("");

        DociiDeclaration previous = parent;

        DociiDeclaration declaration = new DociiEnumDeclaration(
            decl.name.text,
            decl.comment,
            DeclarationLocation(path, filename, decl.name.line),
            enumType.data
        );
        parent = declaration;

        scope (exit) parent = previous;

        previous.addDeclaration(declaration);

        decl.accept(this);
    }

    override void visit(const ClassDeclaration decl)
    {
        auto templateParameters = appender!string;
        if (decl.templateParameters !is null)
            format(templateParameters, decl.templateParameters);
        else
            templateParameters.put("()");

        auto baseClasses = appender!string;
        if (decl.baseClassList !is null)
            format(baseClasses, decl.baseClassList);
        else
            baseClasses.put("()");

        DociiDeclaration previous = parent;

        DociiDeclaration declaration = new DociiClassDeclaration(
            decl.name.text,
            decl.comment,
            DeclarationLocation(path, filename, decl.name.line),
            templateParameters.data,
            baseClasses.data
        );
        parent = declaration;

        scope (exit) parent = previous;

        previous.addDeclaration(declaration);

        decl.accept(this);
    }

    override void visit(const InterfaceDeclaration decl)
    {
        auto templateParameters = appender!string;
        if (decl.templateParameters !is null)
            format(templateParameters, decl.templateParameters);
        else
            templateParameters.put("()");

        auto baseClasses = appender!string;
        if (decl.baseClassList !is null)
            format(baseClasses, decl.baseClassList);
        else
            baseClasses.put("()");

        DociiDeclaration previous = parent;

        DociiDeclaration declaration = new DociiInterfaceDeclaration(
            decl.name.text,
            decl.comment,
            DeclarationLocation(path, filename, decl.name.line),
            templateParameters.data,
            baseClasses.data
        );
        parent = declaration;

        scope (exit) parent = previous;

        previous.addDeclaration(declaration);

        decl.accept(this);
    }
}

/++
 +
 +/
struct DParser
{
    /++
     +
     +/
    public void parseFile(string path, string sourceCode)
    {
        import std.array : split;
        string filename = path.split("/")[$ - 1];

        LexerConfig config;
        auto cache = StringCache(StringCache.defaultBucketCount);
        auto tokens = getTokensForParser(sourceCode, config, &cache);

        RollbackAllocator rba;
        auto mod = parseModule(tokens, filename, &rba);
        auto visitor = new DVisitor(path, filename);
        visitor.visit(mod);

        // TODO: Multiple places i split string lists by ", " which is wrong, as the format could be "(a,b,c)" instaed of "(a, b, c)"

        foreach (decl; visitor.parent.declarations)
        {
            writeln(formatDecl(decl));

            foreach(sub; decl.declarations)
            {
                writeln(formatDecl(sub));
            }
        }

        //return visitor.doc;
    }
}