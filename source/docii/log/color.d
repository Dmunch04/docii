module docii.log.color;

/++
 +
 +/
enum Color : string
{
    RESET = "\u001b[0m",
    CLEAR = RESET,

    BOLD = "\u001b[1m",
    UNDERLINE = "\u001b[4m",
    REVERSED = "\u001b[7m",

    BLACK = "\u001b[30m",
    BOLD_BLACK = "\u001b[30;1m",
    RED = "\u001b[31m",
    BOLD_RED = "\u001b[31;1m",
    GREEN = "\u001b[32m",
    BOLD_GREEN = "\u001b[32;1m",
    YELLOW = "\u001b[33m",
    BOLD_YELLOW = "\u001b[33;1m",
    BLUE = "\u001b[34m",
    BOLD_BLUE = "\u001b[34;1m",
    PURPLE = "\u001b[35m",
    BOLD_PURPLE = "\u001b[35;1m",
    CYAN = "\u001b[36m",
    BOLD_CYAN = "\u001b[36;1m",
    WHITE = "\u001b[37m",
    BOLD_WHITE = "\u001b[37;1m"
}