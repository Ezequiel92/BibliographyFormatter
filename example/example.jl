####################################################################################################
# Example script for BibliographyFormatter.jl
# It can be run as is, and it shouldn't throw any errors
####################################################################################################

cd(@__DIR__)

using Pkg

Pkg.activate("../")
Pkg.instantiate()

using Accessors, BibInternal, Bibliography, DataStructures, Glob, Unicode

push!(LOAD_PATH, "../src/")
using BibliographyFormatter

function bibliographyFormatter(
    source_path::String,
    output_path::String,
    fields::Vector{String},
)::Nothing

    final_bib = bib_formatter(source_path, fields)

    open(output_path, "w") do file
        write(file, final_bib)
    end;

    return nothing

end

function (@main)(ARGS)

    # Path to the source files
    SOURCE_PATH = joinpath(@__DIR__, "example_bib_files")

    # Path to the output file (if it already exists it will be overwritten)
    OUTPUT_PATH = joinpath(@__DIR__, "output.bibtex")

    # Which fields will appear in the end result
    # The order will be respected
    # If some non-essential fields don't exist in the source files, they will be ignored
    FIELDS = [
        "title",
        "booktitle",
        "author",
        "publisher",
        "institution",
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

    bibliographyFormatter(SOURCE_PATH, OUTPUT_PATH, FIELDS)

end
