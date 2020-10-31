module test.one;

/++
 + A cool function! `Markdown works` **too**__!__
 + Params:
 +      a = Something cool
 +      b = Another thing that is cool
 + Returns: Something really cool
 + Throws: Something not so cool
 +/
string yeet(T)(int a, int b = 5) @safe
{
    import std.conv : to;
    if (a > b) return a.to!string;
    else throw Exception(b.to!string);
}

/++
 +
 +/
/*
struct TEST
{
    /// a
    int a;

    /// b
    int b = 5;

    /// c
    string c;

    /// d
    string d = "hello";
}
*/