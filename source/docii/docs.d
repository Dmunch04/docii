module docii.docs;

import std.container.array;

/++
 +
 +/
struct FileDoc
{
    /++
     +
     +/
    auto functions = Array!FunctionDoc();

    /++
     +
     +/
    auto variables = Array!VariableDoc();

    /++
     +
     +/
    auto classes = Array!ClassDoc();

    /++
     +
     +/
    auto enums = Array!EnumDoc();

    /++
     +
     +/
    auto structs = Array!StructDoc();
}

/++
 +
 +/
struct FunctionDoc
{

}

/++
 +
 +/
struct VariableDoc
{

}

/++
 +
 +/
struct ClassDoc
{

}

/++
 +
 +/
struct EnumDoc
{

}

/++
 +
 +/
struct StructDoc
{

}