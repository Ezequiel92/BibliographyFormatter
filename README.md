# BiblographyFormatter


[![ForTheBadge built-with-science](http://ForTheBadge.com/images/badges/built-with-science.svg)](https://GitHub.com/Ezequiel92/)

[![GitHub](https://img.shields.io/github/license/Ezequiel92/BiblographyFormatter?style=flat-square)](https://github.com/Ezequiel92/BiblographyFormatter/blob/main/LICENSE) ![Maintenance](https://img.shields.io/maintenance/yes/2021?style=flat-square)

Julia script to join and format .bib and .bibtex files.

- At the end, a single .bibtex file will be produced, with every entry present in the source files. 
- Which fields and in which order, can be set by the user. Everything else about the formatting is opinionated, and to change it you need to edit the code.
- This is a simple script inside a module. It defines two functions (only one of which is exported), and no data structures nor global variables.
- The script `example/example.jl` shows how to import the main script, how to use the `bib_formatter` function and provides a sanity check, as it should run without errors when using the small set of .bibtex files provided in `example/source_files/`.
- The dependencies are given by the `Manifest.toml` and `Project.toml` files.

### You should always check the end result for mistakes or missing data. The objective of the script is to format the entries, so incorrect or invalid data may produce no warning.

## Some things to note

- It names every entry either `@article` or `@book` (when detects an isbn), so other types of entries will have to be renamed manually.
- Only fields recognized by Bibliography.jl can be used, e.g. if the field `booktitle` is in the variable `fields`, it will be ignored.
- It reformats every author's names to a single letter followed by a dot, e.g. Albert Einstein -> Einstein, A.
- If a doi and an url are present, the doi takes precedent over the url.
- The parser may get confused by special escaped symbols, i.e. `{symbol}`, introducing spurious white spaces. My recommendation is to avoid them, as if you are using a modern LaTeX distribution, it should be able to display them directly given the correct configuration.

## Usage

Simply clone or download the contents of this repository, replace the example .bibtex files in example/source_files/ with the ones you want to concatenate and run example/example.jl. The file output.bibtex should now contain every entry present on the source files, correctly formatted.

To edit which fields and in which order will appear, edit the variable `fields` in example/example.jl. By default, it is

```julia
fields = [
    "title",
    "author",
    "publisher",
    "address",
    "place",
    "collection",
    "series",
    "edition",
    "journal",
    "volume",
    "number",
    "pages",
    "year",
    "month",
    "url",
    "isbn",
]
```

If some fields don't exist in some source .bibtex, they will be ignored, unless they are essential like the year or the author.

By editing `source_path` and `output_path` (in `example/example.jl`) you can change the source directory, and the location, name and format of the output file.

## Documentation

Each function is documented within the script, where a docstring explains the functionality, the arguments and the returns.

For an example on how to use the `bib_formatter` function refer to example/example.jl.

## Warning

This script is written for personal use and may break at any moment. So, no guaranties are given.
