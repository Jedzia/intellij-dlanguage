//          Copyright Jedzia 2019. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 

module gentemplates.stencil;

import std.stdio;
import std.file;
import std.path;
import gentemplates.api;

class TemplateStencilProvider : StencilProvider {
    private string _directory;
    this(string directory) {
        this._directory = directory;
    }

    ~this() {

    }

    string getStencil(string name)
    {
        auto fname = setExtension(name, ".template");
        auto path = buildNormalizedPath(_directory, fname);
        writeln("[TSP] path: ", path);
        return readText(path);
    }

}
