# BiblographyFormatter

Julia script to join and format .bib and .bibtex files.

- A single .bibtex will be produced at the end, with one entry per source file. Which fields and in which order can be set by the user.
Everything else about the formatting is opinionated, and to change it the code should be edited.
- This is a simple script, not a module nor a package. It defines two functions, and no data structures nor global variables. So, when included (`include("BiblographyFormatter.jl")`) both functions are accessible.
- The testing script testing.jl shows how to use the `bib_formatter` function, how to import the script, and provides a sanity check, as it should run without errors. A small set of .bibtex files are provided in test_files/.
- The dependencies are given by the Manifest.toml and Project.toml files.

## Usage

Simple clone or download the contents of this repository, replace the example .bibtex files in test_files/ with the ones you want to concatenate and run testing.jl. test_result.bibtex should now contain one entry per file in test_files/, correctly formatted.

To edit which fields and in which order they will appear, edit the variable `fields` in testing.jl. By default, it is

```julia
fields = ["title", "author", "journal", "volume", "number", "pages", "year", "month", "url"]
```

If some fields don't exist in some source .bibtex, they will simply be ignored.

Editing `source_path` and `output_path` (in testing.jl) you can change the source directory, and the location, name and format of the output file.

## Documentation

Each function is documented within the script, where a docstring explains the functionality, the arguments and the returns.

For an example on how to use the `bib_formatter` function refer to testing.jl.

## Warning

This script may break at any moment. So, no guaranties are given.
