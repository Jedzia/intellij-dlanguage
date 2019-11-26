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
bool verbose = false;
bool versionRequested = false;
bool initTemplates = false;
bool reverseTemplates = false;

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
        "i|init-templates", "Initialize a new working set at the specified path.", &initTemplates, // flag
        "r|reverse-templates", "Build a working set from an existing xml template definition.", &initTemplates, // flag
        //"file", &data, // string
        "v|verbose", &verbose, // flag
        "version", "Show current program version.", &versionRequested, // flag
        "color", "Information about this color (ToDo: Remove Me)", &color); // enum

        if (versionRequested) {
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

        if (initTemplates) {
            writeln( "[initTemplates] option choosen.");

            if (pArgs.length != 1) {
                showHelp( progOptions, prg, "no init-directory specified");
            }

            auto initDir = pArgs[0];
            writeln( "[initTemplates] with '", initDir, "'.");
            auto stp = new TemplateStencilProvider( initDir);
            auto builder = new SkeletonBuilder( initDir, stp);
            builder.run( verbose);
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
        stderr.writefln("Error processing command line arguments: %s", e.msg);
        showHelpSummary( prg );
        return -1;
    }

    return 0;
}
