module bla;

import std.stdio;

public class bla {

    this() {
    }

    ~this() {
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
    //bla b;
    //assertThrown(average([1], [1, 2]));
    assert(42 == 42, "Shurely, 42 is not 43!");
    //assert(true);
}
