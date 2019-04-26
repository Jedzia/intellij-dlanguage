//          Copyright Jedzia 2019. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 

module gentemplates.stencil;

import std.stdio;
import std.file;
import std.path;
import std.regex;
import std.string;
import gentemplates.api;

class TemplateStencilProvider : StencilProvider {
    private string _directory;
    this(string directory) {
        this._directory = directory;
    }

    ~this() {

    }

    string getStencil(string name) {
        auto fname = setExtension(name, ".template");
        auto path = buildNormalizedPath(_directory, fname);
        writeln("[TSP] path: ", path);
        return readText(path);
    }

}

class FileStencil : Stencil {
    private string _content;
    this(string content) {
        this._content = content;
    }

    ~this() {

    }

    private string _template = q"EOS
void main(string[] args)
{
    $$SELECTION$$$$END$$
}
EOS";

    void transform(const TemplateInfo* ti) {
        //writeln("[Stencil-_template] content: ", _template);
        //writeln("[Stencil-Trans] content: ", _content);
        writeln(format("[Stencil:%s] transforming content", ti.name));

        _content = replaceAll(_content, regex(r"(\$1\$)", "g"), ti.name);
        _content = replaceAll(_content, regex(r"(\$4\$)", "g"), ti.description);

        _content = replaceAll(_content, regex(r"(\$TEMPLATE\$)", "g"), _template);
    }

    void save(string path) {
        //writeln("[Stencil-Save] path: ", path);
        //writeln("[Stencil-Save] content: ", _content);
        writeln(format("[Stencil] writing to %s", path));
        std.file.write(path, _content);
    }

}
