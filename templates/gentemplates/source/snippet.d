module snippet;

import std.stdio;
import std.string;
import std.xml;
import std.file;
import std.algorithm;
import std.path;

public class Snippet {

    private string _name;

    this(string path) {
        //foreach (file; files.filter!(a => a.isFile).map!(a => baseName(a.name))) {
        _name = stripExtension(baseName(path));

        auto file = File(path); // Open for reading
        auto lines = file.byLine();
        const wordCount = lines // Read lines
        .map!split // Split into words
            .map!(a => a.length) // Count words per line
            .sum(); // Total word count

        writeln("Snippet '", _name, "' has ", wordCount, " words.");
    }

    ~this() {
    }

    void renderXML() {
        auto doc = new Document(new Tag("templateSet"));
        auto element = new Element("template");
        element.tag.attr["name"] = _name;
        element.tag.attr["value"] = "The Template in full glory";
        element.tag.attr["description"] = "I am the law.";
        element.tag.attr["toReformat"] = "false";
        element.tag.attr["toShortenFQNames"] = "true";

        auto variable = new Element("variable");
        variable.tag.attr["name"] = "ALIAS";
        variable.tag.attr["expression"] = "";
        variable.tag.attr["defaultValue"] = "&quot;alias&quot;";
        variable.tag.attr["alwaysStopAt"] = "true";
        element ~= variable;

        //element ~= new Element("author", "Jedzia");
        auto context = new Element("context");
        auto option = new Element("option");
        option.tag.attr["name"] = "D";
        option.tag.attr["value"] = "true";

        context ~= option;
        element ~= context;

        doc ~= element;

        writefln(join(doc.pretty(3), "\n"));

    }
    /*override size_t toHash() {
        // todo
    }*/

    /*override string toString() {
        // todo: make a useful toString()
    }*/

}

public unittest {
    //assert(42 == 43, "HA !");
    writeln(" unittesting.. bla.d");
}

unittest {
    // generate and reparse, compare
    //snippet b;
    //assertThrown(average([1], [1, 2]));
    assert(42 == 42, "Shurely, 42 is not 43!");
    //assert(true);
}
