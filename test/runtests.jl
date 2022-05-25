push!(LOAD_PATH, "./src/")
using BibliographyFormatter, Test, ReferenceTests

@testset "Unit Conversion" begin

    # Fields to be included
    fields = [
        "title", "booktitle", "author", "publisher", "institution",
        "address", "place", "collection", "series", "edition", "journal",
        "volume", "number", "pages", "year", "month", "url", "isbn",
    ]

    # Path to the source files
    source_path = joinpath(@__DIR__, "../example/example_bib_files")

    # Test name formatting
    @test BibliographyFormatter.format_name("Cena-Rock") == "C.-R."
    @test BibliographyFormatter.format_name("Cena-Rock McMahon") == "C.-R. M."
    @test BibliographyFormatter.format_name("Albert Einstein") == "A. E."

    # Test month convertion
    @test BibliographyFormatter.month_replace("jan") == "01"
    @test BibliographyFormatter.month_replace("Dec.") == "12"
    @test BibliographyFormatter.month_replace(" May") == "05"

    # Test journal name formatting
    @test BibliographyFormatter.journal_name("\\apj") == "The Astrophysical Journal"
    @test BibliographyFormatter.journal_name(
        "Physical Review Letters",
        fullname=false,
    ) == "\\prl"

    # Test main function
    @test_reference "../example/output.bibtex" bib_formatter(source_path, fields)

end