import std.algorithm;
import std.file;
import std.string;
import std.getopt;
import std.stdio;
import std.array;
import std.exception;
import core.runtime;

import gentemplates;
import gentemplates.help;

string data = "file.dat";
int length = 24;
bool opt_verbose = false;
bool opt_versionRequested = false;
bool opt_initTemplates = false;
bool opt_reverseTemplates = false;

enum Color {
    no,
    yes
}

Color color;

// source/app
int main(string[] args) {
    auto prg = args[0];
    //bla b;
    //writeln("Edit source/app.d to start your project.");
    Runtime.initialize();
    scope (exit)
    Runtime.terminate();

    try {
        auto progOptions = getopt( args, //"length", &length, // numeric
        "i|init-templates", "Initialize a new working set at the specified path.", &opt_initTemplates, // flag
        "r|reverse-templates", "Build a working set from an existing xml template definition.", &opt_reverseTemplates, // flag
        //"file", &data, // string
        "v|verbose", "Increase verbosity level", &opt_verbose, // flag
        "version", "Show current program version.", &opt_versionRequested, // flag
        "color", "Information about this color (ToDo: Remove Me)", &color); // enum

        if (opt_versionRequested) {
            showVersion( prg );
            return 1;
        }

        if (progOptions.helpWanted) {
            showHelp( progOptions, prg);
            return 2;
        }

        auto pArgs = remove( args, 0);

        //writeln("rem:", aa);
        writeln();

        if (opt_initTemplates) {
            writeln( "[initTemplates] option choosen.");

            if (pArgs.length != 1) {
                showHelp( progOptions, prg, "no init-directory specified");
            }

            auto initDir = pArgs[0];
            writeln( "[initTemplates] with '", initDir, "'.");
            auto stp = new TemplateStencilProvider( initDir);
            auto builder = new SkeletonBuilder( initDir, stp);
            builder.run( opt_verbose);
        }
        else if (opt_reverseTemplates) {
            writeln( "[reverseTemplates] option choosen.");

            if (pArgs.length != 1) {
                showHelp( progOptions, prg, "no xml-live-template file specified.");
            }

            auto initDir = pArgs[0];
            writeln( "[reverseTemplates] with '", initDir, "'.");
            auto stp = new TemplateStencilProvider( initDir);
            auto builder = new ReverseSkeletonBuilder( initDir, stp);
            builder.run( opt_verbose);
        }
        else if (pArgs.length != 2) {
                showHelp( progOptions, prg, "wrong arguments");
            }
            else {

                foreach (dirArg; pArgs) {
                    writeln( "arg:", dirArg);

                    //auto txtFiles = dirEntries("../snippets", "*.*", SpanMode.breadth);
                    //auto txtFiles = dirEntries("../snippets", "*", SpanMode.shallow);
                    auto directories = dirEntries( dirArg, "*", SpanMode.shallow);
                    foreach (langDir; directories) {
                        writeln( "snippet dir:", langDir);
                        auto files = dirEntries( langDir, "*.snippet", SpanMode.breadth);
                        writeln();
                        writeln();
                        foreach (file; files.filter!(a => a.isFile)
                        .map!(a => a.name)) {
                            writeln();
                            writeln( "File '", file, "' found..");

                            auto b = new Snippet( file);
                            b.renderXML();
                        }
                        writeln();
                        writeln();
                    }
                }
            }
    }
    catch (GetOptException e) {
        stderr.writefln( "Error processing command line arguments: %s", e.msg);
        showHelpSummary( prg );
        return -1;
    }

    return 0;
}
