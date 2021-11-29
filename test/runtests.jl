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

    # Test month convertion
	@test BiblographyFormatter.month_replace("jan") == "01"
	@test BiblographyFormatter.month_replace("Dec.") == "12"
	@test BiblographyFormatter.month_replace(" May") == "05"

    # Test journal name replacement
	@test BiblographyFormatter.journal_replace("\\apj") == "The Astrophysical Journal"
	
	# Test main function
	@test_reference "../example/output.bibtex" bib_formatter(source_path, fields)

end