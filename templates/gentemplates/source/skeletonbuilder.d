//          Copyright Jedzia 2019.
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 

module gentemplates.skeletonbuilder;

import std.stdio;
import std.string;
import std.file;
import std.algorithm;
import std.path;
import std.functional;
import std.range;
import std.array;
import std.conv;
import gentemplates;

/// SkeletonBuild Exception.
class SkeletonBuildException : Exception {
    this(string msg, string file = __FILE__, int line = __LINE__) @safe pure nothrow {
        super(msg, file, line);
    }
}

class SkeletonBuilder {
    private bool _debug = false;
    private string _directory;
    private StencilProvider _stp;
    this(string directory, StencilProvider stp) {
        this._directory = directory;
        this._stp = stp;
    }

    ~this() {

    }

    void run(bool verbose) {
        auto path = buildPath(_directory, ".root"); // "foo/bar/baz"
        auto absPath = absolutePath(path);
        auto file = File(path); // Open for reading
        auto lines = file.byLine();
        /*const wordCount = lines.map!split
            .map!(a => a.length)
            .sum();
        writeln("Build info '", path, "' has ", wordCount, " words.");*/

        int lineNo = 0;
        foreach (line; lines) {
            lineNo++;
            auto strippedLine = line.strip();
            if (empty(strippedLine) || strippedLine.startsWith("#"))
                continue;
            if (_debug)
                writeln("Line: ", line);
            import std.uni : isWhite;

            //auto args = line.split!isWhite;
            //auto args = line.split;
            //auto args = line.splitter([' ', '\t']);
            //auto args = line.splitter!isWhite;

            auto args = line.splitter!isWhite
                .filter!(not!empty)
                .array;
            if (_debug)
                writeln("   args: ", args);
            auto argsLength = args.length;
            if (argsLength < 2) {
                auto msg = format("Error in '%s'(%d):\r\n\r\n" ~ "%s\r\n\r\n"
                        ~ "A template definition looks like:\r\n Name Template Group \"Description\"\r\n"
                        ~ "main basic . \"Application Entry Point Function\"\r\n"
                        ~ "where the Group and Description fields are optional."
                        ~ "\r\n\r\nThis definition contains only %d arguments instead of at least 2",
                        path, lineNo, strippedLine, argsLength);
                throw new SkeletonBuildException(msg);
            }
            //if (args[0] == "") {
            if (empty(args[0])) {
                throw new SkeletonBuildException("name is empty");
            }
            //string name = to!string(args[0]);
            char[] name = args[0];
            if (_debug)
                writeln("       name: ", name);

            if (args[1] == "") {
                throw new SkeletonBuildException("template name is empty");
            }
            char[] templateName = args[1];
            if (_debug)
                writeln("       templateName: ", templateName);

            char[] group = r".".dup;
            if (argsLength > 2) {
                group = args[2];
            }
            if (_debug)
                writeln("       group: ", group);

            //auto quoted = line.splitter('"').filter!(not!empty).array;
            //auto quoted = line.splitter('"').filter!(not!empty).map!(x => x.splitter(","));
            auto quoted = line.splitter('"').filter!(s => s != "\r" && s != "").array;
            //writeln("   quoted: ", quoted);
            //writeln("       take: ", quoted.retro().takeOne());
            //auto fuckyou = quoted.array.back;
            //writeln("       take: ", fuckyou);
            char[] description = "no_description".dup;
            if (quoted.length > 1) {
                description = quoted.back;
            }
            //description = description ~ format(" (%s)", name);
            if (_debug)
                writeln("       description: ", description);

            auto ti = new TemplateInfo(name, templateName, group, description);
            if (_debug)
                writeln("           TemplateInfo: ", ti);
            //auto filtered = args.filter!(not!empty);
            //name = name ~ "*";
            auto fname = setExtension(name, ".snippet");
            auto valid = isValidFilename(fname);
            if (!valid) {
                auto msg = format("'%s' is not a valid filename!", fname);
                throw new SkeletonBuildException(msg);
            }

            //name = name ~ "*";
            auto skPath = buildNormalizedPath(_directory, fname);
            valid = isValidPath(skPath);
            //writeln("               valid: ", valid, " skPath:", skPath);
            if (!valid) {
                auto msg = format("'%s' is not a valid filesystem path!", skPath);
                throw new SkeletonBuildException(msg);
            }

            auto stencilData = _stp.getStencil(templateName.idup);
            auto stencil = new FileStencil(stencilData);
            stencil.transform(ti);
            stencil.save(skPath);
            //writeln("                   template: ", stencilData);

        }

    }
}