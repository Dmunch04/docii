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

/++
 +
 +/
enum TEST1
{
    ONE,
    TWO,
    THREE
}

/++
 +
 +/
enum TEST2 : uint
{
    ONE = 1,
    TWO = 2,
    THREE = 3
}

/++
 +
 +/
abstract class TEST3
{
    /++
     +
     +/
    abstract void printName();
}

/++
 +
 +/
class TEST4 : TEST3
{
    override void printName()
    {
        import std.stdio : writeln;
        writeln("daniel");
    }
}

/++
 +
 +/
interface TEST5
{
    /++
     +
     +/
    void printName();
}

/++
 +
 +/
class TEST6 : TEST5
{
    /++
     +
     +/
    void printName()
    {
        import std.stdio : writeln;
        writeln("daniel");
    }
}