# 📚 BiblographyFormatter.jl

[![ForTheBadge made-with-julia](https://forthebadge.com/images/badges/made-with-julia.svg)](https://julialang.org)

[![GitHub](https://img.shields.io/github/license/Ezequiel92/BiblographyFormatter?style=flat-square)](https://github.com/Ezequiel92/BiblographyFormatter/blob/main/LICENSE) [![Maintenance](https://img.shields.io/maintenance/yes/2021?style=flat-square)](mailto:lozano.ez@gmail.com)

Julia script to format and join .bib and .bibtex files.

- As a result of running the script, a single .bibtex file will be produced, containing every entry present within the source files. 
- Which fields, and in which order, can be set by the user. Everything else about the formatting is opinionated, and to change it you need to edit the code.
- The script `example/example.jl` shows how to import the main script, how to use the main function, and provides a sanity check, as it should run without errors when using the .bibtex files provided in `example/example_bib_files`.
- The dependencies are given by the `Manifest.toml` and `Project.toml` files.

## ℹ️ Some things to note

- This is just a script inside a module. It defines two functions (only one of which is exported), and no data structures or global variables.
- It names every entry either `@article` or `@book` (when detects an ISBN), so other types of entries will have to be renamed manually.
- Only fields recognized by [Bibliography.jl](https://github.com/Humans-of-Julia/Bibliography.jl) can be used, i.e. if a field in the variable `fields` is not recognized, it will be ignored.
- It reformats every author's first name to a single letter followed by a dot, e.g. Albert Einstein -> Einstein, A.
- If a DOI and an URL are present, the DOI takes precedent over the URL.
- The parser may get confused by special escaped symbols, i.e. `{symbol}`, introducing spurious white spaces. My recommendation is to avoid them, as if you are using a modern LaTeX distribution with the correct configuration, it should be able to display them directly.

### ‼️ You should always check the resulting file for mistakes or missing data. The goal of the script is to format the entries, so incorrect or invalid data in the source files may produce no warning.

## 🛠️ Usage

* Clone the project

```bash
 git clone https://github.com/Ezequiel92/BiblographyFormatter.git
```

* Go to the project directory

```bash
cd path/to/BiblographyFormatter
```

* Inside the Julia REPL install the dependencies specified by the `Manifest.toml` and `Project.toml` files

```julia
(@v1.6) pkg> activate .

(BiblographyFormatter) pkg> instantiate
```

* Replace the example .bibtex files in `example/example_bib_files` with the ones you want to format and join.

* Run the example script

```julia
julia> include("example/example.jl")
```

* The file `output.bibtex` should now contain every entry present on the source files, correctly formatted.

    * To change which fields will appear and in which order, edit the variable `fields` in `example/example.jl`. By default, it is

    ```julia
    fields = [
        "title", "booktitle", "author", "publisher", "address", 
        "place", "collection", "series", "edition", "journal", 
        "volume", "number", "pages", "year", "month",
        "url", "isbn",
    ]
    ```

    * If some fields don't exist in some entries, they will be ignored, unless they are essential like the year or the author (in which case an error will be thrown.

    * By editing `source_path` and `output_path` in `example/example.jl`, you can change the source directory and the location, name, and format of the output file.

## 📘 Documentation

Each function is documented within the script, where a docstring explains the functionality, the arguments, and the returns.

For an example on how to use the main function `bib_formatter` refer to `example/example.jl`.

## 📣 Contact

[![image](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:lozano.ez@gmail.com)

[![image](https://img.shields.io/badge/Microsoft_Outlook-0078D4?style=for-the-badge&logo=microsoft-outlook&logoColor=white)](mailto:lozano.ez@outlook.com)

## ⚠️ Warning

This script is written for personal use and may break at any moment. So, no guarantees are given.
