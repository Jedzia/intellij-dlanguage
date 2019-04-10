### Initialization of a new template set via list

    Todo: dub run -- --init-templates <directory>
    Initialize a new working set. In directory the .root file specifies your setup 
    hmmm, no to confusing with dub init 

### Build IntelliJ XML template definitions from snippets located in the directory "_snippets_"

The generator will walk through the specified snippets root directory and search for text files with 
.snippet extensions. The subdirectory "D" produces a XML live-template definition file "D.xml" 
under the destination template directory based on all snippets found in the "D"-directory source.

Subsequent directories, for example "Foo" with snippets in it will produce a Foo.xml live templates
file.     

       templates> cd gentemplates
    gentemplates> dub run
    
which is a shortcut for:    
    
    gentemplates> dub run -- ../snippets ../../src/main/resources/dlang/ide/liveTemplates
    
Arguments are **gentemplates** <snippets-root-directory> <path-to-template-directory>