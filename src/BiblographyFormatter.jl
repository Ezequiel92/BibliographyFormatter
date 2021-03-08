############################################################################################
# Julia script for joining .bib/.bibtex files and formatting their entries. 
############################################################################################

module BiblographyFormatter

using Bibliography
using Glob
using DataStructures
using Accessors

"""
	format_name(name::String)::String

Format and clean the authors first and middle names.

Ignores leading and trailing white spaces and empty strings, and keeps 
together words separated by '-'.
	
# Arguments 
- `name::String`: String to be formatted.

# Returns
- The input string with only the first letter of every word left, each ending with a dot. 

# Example
```julia-repl
julia> format_name("Cena-Rock")
"C.-R."
julia> format_name("Cena-Rock McMahon")
"C.-R. M."
```
"""
function format_name(name::String)::String

    # Clean leading and trailing white spaces.
    striped_name = strip(name)

    # Return string unmodified if it is empty or already correctly formatted.
    if isempty(striped_name) || match(r"[A-Z]\.", striped_name) !== nothing
        return striped_name
    end

    # Split the string when ' ' and '-' apears.
    # Replace every word by its first letter ending with a dot.
    elements = [
        [first(atom) * '.' for atom in split(word, '-')] for
        word in split(striped_name, ' ')
    ]

    # Construct the output, adding again the ' ' and '-'.
    final = ""
    for element in elements
        if length(element) > 1
            for i in 1:(length(element) - 1)
                final *= (element[i] * '-')
            end
        end
        final *= (element[end] * ' ')
    end

    return strip(final)
end

"""
	bib_formatter(fields::Array{String,1}, source_path::String)::String

# Arguments 
- `fields::Array{String,1}`: Ordered list of bibtex fields to be included in each entry. 
  If one field does not exist it will be ignored, unless they are essential like the year 
  or the author. The order of the fields will be respected in the final output.
- `source_path::String`: Path to the .bib and .bibtex files. The final order of the 
  entries in the output may not be the order of the files in the source directory.

# Returns
- A String with the joined bib data, already formatted and ready to be printed in a file.
"""
function bib_formatter(fields::Array{String, 1}, source_path::String)::String

    # Import bibliography files from `source_path`.
    file_list = glob("*.bibtex", source_path)
    append!(file_list, glob("*.bib", source_path))

    # Initialize new_bib with the last entry.
    new_bib = import_bibtex(pop!(file_list))
    # And merge all entries.
    for file in file_list
        merge!(new_bib, import_bibtex(file))
    end

    # Format the names of the authors.
    for key in keys(new_bib)
        for (i, author) in enumerate(new_bib[key].authors)
            author = @set author.first = format_name(author.first)
            author = @set author.middle = format_name(author.middle)
            new_bib[key].authors[i] = @set author.junior = format_name(author.junior)
        end
    end

    # Constructs the dictionary with all the available data for every entry.
    # Now `new_bib[key].fields` contains all the data as strings.
    export_bibtex(new_bib)

    # Maximum length of a field for padding of the final string.
    max_lenght = maximum(length.(fields))

    out_str = ""
    for key in keys(new_bib)
        # Deletes empty fields.
        filter!(field -> !isequal(field[2], ""), new_bib[key].fields)

        # Constructs the entry name, {surname}{year}.
        surname = new_bib[key].authors[1].last
        year = new_bib[key].date.year
        if "isbn" in fields
            out_str *= "@book{" * surname * year * ",\n"
        else
            out_str *= "@article{" * surname * year * ",\n"
        end

        # Available fields.
        available = keys(new_bib[key].fields)

        # Constructs the correct URL from the "doi" field if possible.
        if "doi" in available
            new_bib[key].fields["url"] = "https://doi.org/" * new_bib[key].access.doi
        end

        for field in fields
            if field in available

                # Clean title of white spaces and spurious curly brackets.
                if field == "title"
                    new_bib[key].fields[field] =
                        strip(new_bib[key].fields[field], ['{', '}', ' '])
                end

                # Add padding to the pages field.
                if field == "pages"
                    numbers = filter(!isempty, strip.(split(new_bib[key].in.pages, "-")))
                    if length(numbers) > 1
                        new_bib[key].fields[field] = "$(numbers[1]) - $(numbers[2])"
                    end
                end

                # Add fields to the string.
                out_str *=
                    "\t" * rpad(field, max_lenght) *
                    " = {" * new_bib[key].fields[field] * "},\n"
            end
        end

        # Final formatting of the string.
        out_str = out_str[1:(end - 2)] * "\n}\n\n"
    end

    return out_str
end

export bib_formatter

end