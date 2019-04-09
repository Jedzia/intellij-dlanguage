import std.stdio;
import std.getopt;
import std.algorithm;

import std.file;

string data = "file.dat";
int length = 24;
bool verbose;

enum Color {
    no,
    yes
}

Color color;

void main(string[] args) {
    writeln("Edit source/app.d to start your project.");

    auto helpInformation = getopt(args, "length", &length, // numeric
            "file", &data, // string
            "verbose", &verbose, // flag
            "color", "Information about this color", &color); // enum

    if (helpInformation.helpWanted) {
        defaultGetoptPrinter("Some information about the program.", helpInformation.options);
    }

    auto pArgs = remove(args, 0);
    //writeln("rem:", aa);

    foreach (dirArg; pArgs) {
        writeln("arg:", dirArg);

        //auto txtFiles = dirEntries("../snippets", "*.*", SpanMode.breadth);
        //auto txtFiles = dirEntries("../snippets", "*", SpanMode.shallow);
        auto txtFiles = dirEntries(dirArg, "*", SpanMode.shallow);
        foreach (txtFile; txtFiles)
            writeln(txtFile, " files found..");
    }
}
