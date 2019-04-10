version (unittest) {
    import dub_test_root; //import the list of all modules
}

/*int main() {
    // allModules contains a list of all modules from your project
    // you might want to call something like this:
    //return runUnitTests!allModules;
    return 0;
}*/

string ordinal(size_t number) {
    return ""; // ← intentionally wrong
}

unittest {
    /*assert(ordinal(1) == "1st");
    assert(ordinal(2) == "2nd");
    assert(ordinal(3) == "3rd");
    assert(ordinal(10) == "10th");*/
    assert(ordinal(10) == "");
}
