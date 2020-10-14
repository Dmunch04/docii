module test.one;

/++
 + A cool function! `Markdown works` **too**__!__
 + Params:
 +      a = Something cool
 +      b = Another thing that is cool
 + Returns: Something really cool
 + Throws: Something not so cool
 +/
string yeet(int a, int b)
{
    import std.conv : to;
    if (a > b) return a.to!string;
    else throw Exception(b.to!string);
}