import std.stdio;

import docii.program;

import std.stdio, std.range;

void main(string[] args)
{
	Program program = Program(args);
	/*
	writeln(args);

	string sourceCode = r"
		/++
		 + aa
		 +/
		void foo() @safe {
			return;
		}

		///
		int bar = 5;
	";

	LexerConfig config;
	auto cache = StringCache(StringCache.defaultBucketCount);
	auto tokens = getTokensForParser(sourceCode, config, &cache);

	RollbackAllocator rba;
	auto m = parseModule(tokens, "test.d", &rba);
	auto visitor = new TestVisitor();
	visitor.visit(m);
	*/
}
