module docii.parser;

import std.stdio;
import std.conv;

import dparse.lexer;
import dparse.parser : parseModule;
import dparse.ast;
import dparse.rollback_allocator : RollbackAllocator;

import docii.docs;

private class DVisitor : ASTVisitor
{
    alias visit = ASTVisitor.visit;

    FileDoc doc;

    override void visit(const FunctionDeclaration decl)
    {
        writeln(decl.tokens);
        writeln(decl.name.text);
        writeln(decl.returnType.tokens[0].text);
        writeln(decl.parameters.parameters[0].name.text);
        writeln(decl.parameters.parameters[0].cstyle);

		//writeln(decl.comment);

        decl.accept(this);
    }

	override void visit(const VariableDeclaration decl)
	{
		//writeln(decl.declarators[0].name.text);
		//writeln(decl.type.typeConstructors);
		//writeln(decl.declarators[0].initializer);
		//writeln(decl.comment);

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
    public FileDoc parseFile(string sourceCode)
    {
        LexerConfig config;
        auto cache = StringCache(StringCache.defaultBucketCount);
        auto tokens = getTokensForParser(sourceCode, config, &cache);

        RollbackAllocator rba;
        auto m = parseModule(tokens, "test.d", &rba);
        auto visitor = new DVisitor();
        visitor.visit(m);

        return visitor.doc;
    }
}