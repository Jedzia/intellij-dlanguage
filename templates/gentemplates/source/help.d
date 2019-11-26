module gentemplates.help;

import std.string;
import std.getopt;
import std.stdio;
import std.array;
import core.runtime;
import gentemplates.utils;

string indent(const string reference, int indentation = 2) {
    return replicate(" ",  reference.count + indentation);
}

void showVersion(string prg, string info = null) {
    if (info != null) {
        writeln( info);
        writeln();
    }

    string callMsg = "";
    callMsg ~= format( "gentemplates version: %s", getAPPVersion()).dup;
    writeln(callMsg);
    Runtime.terminate();
}

void showHelpSummary(string prg, string info = null) {
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
    callMsg ~= format( "%sCopyright (C) 2019 Jedzia, MIT License.", indent(prg)).dup;
    callMsg ~= "\n";
    callMsg ~= "\n";
    callMsg ~= format( "%s --init-templates <root-directory>", prg).dup;
    callMsg ~= "\n";
    callMsg ~= format( "%s --reverse-templates <path-to-jetbrains-live-template-xml>", prg).dup;
    callMsg ~= "\n";
    callMsg ~= format( "%s <snippets-root-directory> <path-to-template-directory>", prg);
    callMsg ~= "\n";
    writeln(callMsg);
}

void showHelp(GetoptResult opt, string prg, string info = null) {
    if (info != null) {
        writeln( info);
        writeln();
    }

    string callMsg = "";
    showHelpSummary(prg);

    defaultGetoptPrinter( callMsg, opt.options);
    Runtime.terminate();
}

