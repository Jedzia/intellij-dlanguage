module snippet;

import std.stdio;
import std.string;
import std.xml;

public class Snippet {

    this() {
    }

    ~this() {
    }

    void doThings() {
        auto doc = new Document(new Tag("catalog"));
        auto element = new Element("book");
        element.tag.attr["id"] = "123";
        element ~= new Element("author", "Jedzia");

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
