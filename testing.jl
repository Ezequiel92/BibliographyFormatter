############################################################################################
# Testing script for BiblographyFormatter.jl, it can be run as is, 
# and it shouldn't throw any errors.
############################################################################################

include("BiblographyFormatter.jl")

###########################
# Configuration variables.
###########################

# The order and which fields you put in here determines the final result.
fields = [	"title", "author", "publisher", 
            "address", "place", "collection",
            "series", "edition", "journal", 
            "volume", "number", "pages", 
            "year", "month", "url", "isbn"]

# Path to the source files.
source_path = "test_files/"

# Path to the output file (if it already exist it will be overwritten).
output_path = "test_result.bibtex"

#########################
# Formatting and output.
#########################

final_bib = bib_formatter(fields, source_path)

open(output_path, "w") do file
    write(file, final_bib)
end