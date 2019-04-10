import std.algorithm;
import std.file;
import std.getopt;
import std.stdio;
import std.exception;

import snippet;

string data = "file.dat";
int length = 24;
bool verbose;

enum Color {
    no,
    yes
}

Color color;

// source/app
void main(string[] args) {
    //bla b;
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
        auto directories = dirEntries(dirArg, "*", SpanMode.shallow);
        foreach (langDir; directories) {
            writeln("snippet dir:", langDir);
            auto files = dirEntries(langDir, "*.snippet", SpanMode.breadth);
            writeln();
            writeln();
            foreach (file; files.filter!(a => a.isFile).map!(a => a.name)) {
                writeln();
                writeln("File '", file, "' found..");

                auto b = new Snippet(file);
                b.renderXML();
            }
            writeln();
            writeln();
        }
    }
}
