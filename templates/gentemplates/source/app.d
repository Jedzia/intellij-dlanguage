import std.algorithm;
import std.file;
import std.string;
import std.getopt;
import std.stdio;
import std.array;
import std.exception;
import core.runtime;

import gentemplates;

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

string indent(const string reference, int indentation = 2) {

    return replicate(" ",  reference.count + indentation);
}

void showHelp(GetoptResult opt, string prg, string info = null) {
    if (info != null) {
        writeln( info);
        writeln();
    }

    string callMsg = "";
    callMsg ~= format( "gentemplates version: %s", getAPPVersion()).dup;
    callMsg ~= "\n";
    callMsg ~= format( "%s, A Developer Friendly Template Generator Tool for", prg).dup;
    callMsg ~= "\n";
    callMsg ~= format( "%sJetbrains Integrated Development Environment Software.", indent(prg)).dup;
    callMsg ~= "\n";
    callMsg ~= "\n";
    callMsg ~= format( "%s --init-templates <root-directory>", prg).dup;
    callMsg ~= "\n";
    callMsg ~= format( "%s --reverse-templates <path-to-jetbrains-live-template-xml>", prg).dup;
    callMsg ~= "\n";
    callMsg ~= format( "%s <snippets-root-directory> <path-to-template-directory>", prg);
    callMsg ~= "\n";
    callMsg ~= "\n";

    defaultGetoptPrinter( callMsg, opt.options);
    Runtime.terminate();
}

// source/app
void main(string[] args) {
    auto prg = args[0];
    //bla b;
    //writeln("Edit source/app.d to start your project.");
    Runtime.initialize();
    scope (exit)
    Runtime.terminate();

    auto progOptions = getopt( args, //"length", &length, // numeric
    "init-templates", "Initialize a new working set.", &initTemplates, // flag
    "reverse-templates", "Build a working set from an existing xml template definition.", &initTemplates, // flag
    //"file", &data, // string
    "v|verbose", &verbose, // flag
    "version", "Show current program version.", &versionRequested, // flag
    "color", "Information about this color", &color); // enum

    if (progOptions.helpWanted) {
        showHelp( progOptions, prg);
        return;
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
