<div align="center">
    <h1>📚 BiblographyFormatter</h1>
</div>

<p align="center">
    <a href="https://github1s.com/Ezequiel92/BiblographyFormatter"><img src="http://forthebadge.com/images/badges/built-with-science.svg"></a>
    <a href="https://julialang.org"><img src="https://forthebadge.com/images/badges/made-with-julia.svg"></a>
</p>

<p align="center">
    <a href="https://codecov.io/github/Ezequiel92/BiblographyFormatter?branch=main"><img src="https://img.shields.io/codecov/c/github/Ezequiel92/BiblographyFormatter?style=flat&logo=Codecov&labelColor=2B2D2F"></a>
    <a href="https://github.com/Ezequiel92/BiblographyFormatter/actions"><img src="https://img.shields.io/github/workflow/status/Ezequiel92/BiblographyFormatter/Continuous%20integration?style=flat&logo=GitHub&labelColor=2B2D2F"></a>
    <a href="https://github.com/Ezequiel92/BiblographyFormatter/blob/main/LICENSE"><img src="https://img.shields.io/github/license/Ezequiel92/BiblographyFormatter?style=flat&logo=GNU&labelColor=2B2D2F"></a>
</p>

Julia script to format and join .bib and .bibtex files.

- As a result of running the script a single .bibtex file will be produced, containing every entry present within the source files.
- Which fields, and in which order, can be set by the user. Everything else about the formatting is opinionated, and to change it you need to edit the code.
- The script `example/example.jl` shows how to import the main script, how to use the main function, and provides a sanity check, as it should run without errors when using the .bibtex files provided in `example/example_bib_files`.
- The dependencies are given by the `Manifest.toml` and `Project.toml` files.

## ℹ️ Some things to note

- This is just a script inside a module. It defines four functions (only one of which is exported), and one global variable.
- It supports only the entries that [Bibliography.jl](https://github.com/Humans-of-Julia/Bibliography.jl) supports (you can find a list [here](https://humans-of-julia.github.io/Bibliography.jl/stable/internal/#BibInternal.entries)), so other types of entries must be renamed manually.
- Only fields recognized by [Bibliography.jl](https://github.com/Humans-of-Julia/Bibliography.jl) can be used (you can find a list [here](https://humans-of-julia.github.io/Bibliography.jl/stable/internal/#BibInternal.fields)), i.e. if a field in the variable `fields` is not recognized, it will be ignored.
- It reformats every author's first name to a single letter followed by a dot, e.g. Albert Einstein -> Einstein, A.
- If a DOI and an URL are present, the DOI takes precedent over the URL.
- If there is more than one entry with the same first author and the same year, the key will be the same. This has to be corrected manually.
- The parser may get confused by special escaped symbols, i.e. `{symbol}`, introducing spurious white spaces. My recommendation is to avoid them, as if you are using a modern LaTeX distribution with the correct configuration, it should be able to display them directly without the curly brackets. The only exception are accented upper vowels (e.g. Á), which are always replace by their special LaTeX form (e.g. `{\'A}`).
- [Bibliography.jl](https://github.com/Humans-of-Julia/Bibliography.jl) will get confused if there is an space after `@article`, i.e. the entry stars as "@article {Author2025", and the entry will be ignored. Delete the spurious spaces manually.

### ‼️ You should always check the resulting file for mistakes or missing data. The goal of the script is to format the entries, so incorrect or invalid data in the source files may produce no warning. Garbage in garbage out

## 🛠️ Usage

- Clone the project

```bash
git clone https://github.com/Ezequiel92/BiblographyFormatter.git
```

- Go to the project directory

```bash
cd path/to/BiblographyFormatter
```

- Inside the Julia REPL install the dependencies specified by the `Manifest.toml` and `Project.toml` files

```julia
(@v1.7) pkg> activate .

(BiblographyFormatter) pkg> instantiate
```

- Replace the example .bibtex files in `example/example_bib_files` with the ones you want to format and join.

- Run the example script

```julia
julia> include("example/example.jl")
```

- The file `output.bibtex` should now contain every entry present on the source files, correctly formatted.

  - To change which fields will appear and in which order, edit the variable `fields` in `example/example.jl`. By default, it is

    ```julia
    fields = [
        "title", "booktitle", "author", "publisher", "institution",
        "address", "place", "collection", "series", "edition", "journal",
        "volume", "number", "pages", "year", "month", "url", "isbn",
    ]
    ```

  - If some fields don't exist in some entries, they will be ignored, unless they are essential like the year or the author (in which case an error will be thrown).

  - By editing `source_path` and `output_path` in `example/example.jl`, you can change the source directory and the location, name, and format of the output file.

## 📘 Documentation

Each function is documented within the script, where a docstring explains the functionality, the arguments, and the returns.

For an example on how to use the main function `bib_formatter` refer to `example/example.jl`.

## ⚠️ Warning

This script is written for personal use and may break at any moment. So, use it at your own risk.
