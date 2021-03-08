############################################################################################
# Example script for BiblographyFormatter.jl.
# It can be run as is, and it shouldn't throw any errors.
############################################################################################

push!(LOAD_PATH, "./src/")
using BiblographyFormatter

###########################
# Configuration variables.
###########################

# The order and which fields put in here determines the final result.
# If some non-essential fields do not exist, they will be ignored. 
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

# Path to the source files.
source_path = joinpath(@__DIR__, "source_files/")

# Path to the output file (if it already exists it will be overwritten).
output_path = joinpath(@__DIR__, "output.bibtex")

#########################
# Formatting and output.
#########################

final_bib = bib_formatter(fields, source_path)

open(output_path, "w") do file
    write(file, final_bib)
end;