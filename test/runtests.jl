push!(LOAD_PATH, "./src/")
using BiblographyFormatter, Test, ReferenceTests

@testset "Unit Conversion" begin
	
	# Fields to be included
	fields = [
		"title", "booktitle", "author", "publisher", "address",
		"place", "collection", "series", "edition", "journal",
		"volume", "number", "pages", "year", "month",
		"url", "isbn",
	]

	# Path to the source files
	source_path = joinpath(@__DIR__, "../example/example_bib_files")
	
	# Test name formatting
	@test BiblographyFormatter.format_name("Cena-Rock") == "C.-R."
	@test BiblographyFormatter.format_name("Cena-Rock McMahon") == "C.-R. M."
	@test BiblographyFormatter.format_name("Albert Einstein") == "A. E."
	
	# Test main function
	@test_reference "../example/output.bibtex" bib_formatter(fields, source_path)

end