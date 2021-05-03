############################################################################################
# Example script for BiblographyFormatter.jl
# It can be run as is, and it shouldn't throw any errors
############################################################################################

push!(LOAD_PATH, "./src/")
using BiblographyFormatter

############################################################################################
# Configuration variables
############################################################################################

# Which fields will appear in the end result. The order will be respected
# If some non-essential fields don't exist in the source files, they will be ignored
fields = [
    "title",
	"booktitle",
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

# Path to the source files
source_path = joinpath(@__DIR__, "example_bib_files")

# Path to the output file (if it already exists it will be overwritten)
output_path = joinpath(@__DIR__, "output.bibtex")

############################################################################################
# Formatting and output and saving the result in a file
############################################################################################

final_bib = bib_formatter(fields, source_path)

open(output_path, "w") do file
    write(file, final_bib)
end;