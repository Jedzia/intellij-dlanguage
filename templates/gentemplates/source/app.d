import std.algorithm;
import std.file;
import std.getopt;
import std.stdio;
import std.string;
import std.xml;
import std.exception;

//import bla;

string data = "file.dat";
int length = 24;
bool verbose;

enum Color {
    no,
    yes
}

Color color;

/*string ordinal(size_t number) {
    return ""; // ← intentionally wrong
}

unittest {
    assert(ordinal(1) == "1st");
    assert(ordinal(2) == "2nd");
    assert(ordinal(3) == "3rd");
    assert(ordinal(10) == "10th");
}*/

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
            foreach (file; files)
                writeln(file, " files found..");
        }
    }

    writeln();
    writeln();

    auto doc = new Document(new Tag("catalog"));
    auto element = new Element("book");
    element.tag.attr["id"] = "123";
    element ~= new Element("author", "Jedzia");

    doc ~= element;

    writefln(join(doc.pretty(3), "\n"));

}

unittest {
    // generate and reparse, compare
    //bla b;
    //assertThrown(average([1], [1, 2]));
    assert(42 == 42, "Shurely, 42 is not 43!");
    //assert(true);
}
