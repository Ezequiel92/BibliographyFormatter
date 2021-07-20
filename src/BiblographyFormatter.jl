############################################################################################
# Julia script to format and join .bib and .bibtex files
############################################################################################

module BiblographyFormatter

using Bibliography
using Glob
using DataStructures
using Accessors

if isdefined(Base, :Experimental) && isdefined(Base.Experimental, Symbol("@optlevel"))
    @eval Base.Experimental.@optlevel 3
end

"""
	format_name(name::String)::String

Format and clean the authors' first and middle names.

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

    # Clean leading and trailing white spaces
    striped_name = strip(name)

    # If the string is empty or already correctly formatted, returned it unchanged
    if isempty(striped_name) || match(r"[A-Z]\.", striped_name) !== nothing
        return striped_name
    end

    # Split the string when ' ' and '-' appear
    # Replace every word with its first letter ending with a dot
    elements = [
        [first(atom) * '.' for atom in split(word, '-')] for
        word in split(striped_name, ' ')
    ]

    # Construct the output, adding again the ' ' and '-'
    final = ""
    for element in elements
        if length(element) > 1
            for i = 1:(length(element)-1)
                final *= (element[i] * '-')
            end
        end
        final *= (element[end] * ' ')
    end

    return strip(final)
end


"""
month_replace(month::String)::String

Replaces the name of the month with its corresponding number.
    
# Arguments 
- `month::String`: Name of the month as a string. It can have a point or space at the end 
or beginning, any letter can be in upper or lower case and the full name or the common three 
letter abbreviation can be used.

# Returns
- The corresponding number as a string. 

# Example
```julia-repl
julia> month_replace("jan")
"01"
julia> format_name("Dec.")
"12"
```
"""
function month_replace(month::String)::String

    l_month = strip(lowercase(month), ['.', ' '])

    if l_month == "jan" || l_month == "january"
        return string(1, pad = 2)
    elseif l_month == "feb" || l_month == "february"
        return string(2, pad = 2)
    elseif l_month == "mar" || l_month == "march"
        return string(3, pad = 2)
    elseif l_month == "apr" || l_month == "april"
        return string(4, pad = 2)
    elseif l_month == "may" || l_month == "may"
        return string(5, pad = 2)
    elseif l_month == "jun" || l_month == "june"
        return string(6, pad = 2)
    elseif l_month == "jul" || l_month == "july"
        return string(7, pad = 2)
    elseif l_month == "aug" || l_month == "august"
        return string(8, pad = 2)
    elseif l_month == "sep" || l_month == "september"
        return string(9, pad = 2)
    elseif l_month == "oct" || l_month == "october"
        return string(10, pad = 2)
    elseif l_month == "nov" || l_month == "november"
        return string(11, pad = 2)
    elseif l_month == "dec" || l_month == "december"
        return string(12, pad = 2)
    else
        return month
    end

end

"""
	bib_formatter(source_path::String, Vector{String})::String

# Arguments 
- `source_path::String`: Path to the .bib and .bibtex files. The final order of the 
  entries in the output may not be the order of the files in the source directory.
- `fields::Vector{String}`: Ordered list of bibtex fields to be included in each entry. 
  If one field does not exist it will be ignored unless they are essential like the year 
  or the author. The order of the fields will be respected in the final output.

# Returns
- A String with the joined bib data, already formatted and ready to be printed in a file.
"""
function bib_formatter(source_path::String, fields::Vector{String})::String

    # Import bibliography files from `source_path`
    file_list = glob("*.bibtex", source_path)
    append!(file_list, glob("*.bib", source_path))

    # Initialize new_bib with the last entry
    new_bib = import_bibtex(pop!(file_list))
    # And merge all entries
    for file in file_list
        merge!(new_bib, import_bibtex(file))
    end

    # Sort the entries with the default order, i.e. using the BibTeX keys or `:id`
    sort_bibliography!(new_bib)

    # Format the names of the authors
    for key in keys(new_bib)
        for (i, author) in enumerate(new_bib[key].authors)
            author = @set author.first = format_name(author.first)
            author = @set author.middle = format_name(author.middle)
            new_bib[key].authors[i] = @set author.junior = format_name(author.junior)
        end
    end

    # Constructs the dictionary for every entry with all the available data
    # Now `new_bib[key].fields` contains all the data as strings
    export_bibtex(new_bib)

    # Maximum length of a field for padding of the final string
    max_lenght = maximum(length.(fields))

    out_str = ""
    for key in keys(new_bib)
        # Deletes empty fields.
        filter!(field -> !isequal(field[2], ""), new_bib[key].fields)

        # Constructs the entry name as {surname}{year}
        surname = new_bib[key].authors[1].last
        year = new_bib[key].date.year
        if "isbn" in fields
            out_str *= "@book{" * surname * year * ",\n"
        else
            out_str *= "@article{" * surname * year * ",\n"
        end

        # Available fields
        available = keys(new_bib[key].fields)

        # Constructs the correct URL from the "doi" field if possible
        if "doi" in available
            new_bib[key].fields["url"] = "https://doi.org/" * new_bib[key].access.doi
        end

        for field in fields
            if field in available

                # Clean white spaces and spurious curly brackets from the title
                if field == "title"
                    new_title = strip(new_bib[key].fields[field], ['{', '}', ' '])
                    new_title = replace(replace(new_title, "{" => ""), "}" => "")
                    new_bib[key].fields[field] = new_title
                end

                # Set the month as a number
                if field == "month"
                    new_bib[key].fields[field] = month_replace(new_bib[key].fields[field])
                end

                # Add padding to the pages field
                if field == "pages"
                    numbers = filter(!isempty, strip.(split(new_bib[key].in.pages, "-")))
                    if length(numbers) > 1
                        new_bib[key].fields[field] = "$(numbers[1]) - $(numbers[2])"
                    end
                end

                # Add fields to the string
                out_str *=
                    "\t" *
                    rpad(field, max_lenght) *
                    " = {" *
                    new_bib[key].fields[field] *
                    "},\n"
            end
        end

        # Final formatting of the string.
        out_str = out_str[1:(end-2)] * "\n}\n\n"
    end

    return out_str
end

precompile(format_name, (String,))
precompile(month_replace, (String,))
precompile(bib_formatter, (String, Vector{String}))

export bib_formatter

end