module gentemplates.utils;

//import core.time : Duration;
import std.algorithm : canFind, startsWith;
//import std.array : appender, array;
//import std.conv : to;
//import std.exception : enforce;
//import std.file;
//import std.string : format;
//import std.process;
//import std.traits : isIntegral;

private bool isNumber(string str) {
    foreach (ch; str)
        switch (ch) {
            case '0': .. case '9': break;
            default: return false;
        }
    return true;
}

private bool isHexNumber(string str) {
    foreach (ch; str)
        switch (ch) {
            case '0': .. case '9': break;
            case 'a': .. case 'f': break;
            case 'A': .. case 'F': break;
            default: return false;
        }
    return true;
}

/// Returns the current version in semantic version format
string getAPPVersion()
{
    import gentemplates.version_;
    import std.array : split, join;
    // convert version string to valid SemVer format
    auto verstr = gentemplatesVersion;
    if (verstr.startsWith("v")) verstr = verstr[1 .. $];
    auto parts = verstr.split("-");
    if (parts.length >= 3) {
        // detect GIT commit suffix
        if (parts[$-1].length == 8 && parts[$-1][1 .. $].isHexNumber() && parts[$-2].isNumber())
            verstr = parts[0 .. $-2].join("-") ~ "+" ~ parts[$-2 .. $].join("-");
    }
    return verstr;
}