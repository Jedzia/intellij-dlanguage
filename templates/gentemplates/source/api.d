//          Copyright Jedzia 2019. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module gentemplates.api;


interface StencilProvider {
    string getStencil(string name);
}

struct TemplateInfo {
    char[] name;
    char[] templateName;
    char[] group;
    char[] description;
    char[][] extra;
}

interface Stencil {
    void transform(const TemplateInfo* ti);
    void save(string path);
}

