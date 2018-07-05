R library which takes output from [GEMINI](http://gemini.readthedocs.io) and, optionally, [peddy](http://peddy.readthedocs.io) and wraps it into a interactive html document. 

The idea to provide a happy medium between GEMINI output piped into `less` and using a web service like http://vcf.iobio.io. 

# Wait, what?
Click [here](https://cdn.rawgit.com/davemcg/see_gem/master/inst/extdata/demo.html?raw=True) to see a sample.

# Who would use See GEM?
The bioinformatician who is running (scripted) GEMINI queries and would like to share results with someone who isn't going to run custom GEMINI queries for their samples. 

That said, the document is generated quickly (seconds). The limiting factor are the speed of the GEMINI queries. So it could be used semi-interactively for a command-line skilled analyst who wanted a friendlier output from GEMINI than `less` and `csvkit`. 

# Why not just use [insert web service]?
You don't have to hook into a web page which may disappear in `x` months/years. 

This also has the tremendous advantage of being fully portable - you just send the html document to the user and they can use their web browser to study the exome/NGS results for a sample/trio. 

**Once you have the document it works without internet**

# Why not just send a CSV/XLSX output?
Well, that's actually what I have been doing for a few years. The analysts are not super happy, though, because there's a lot of little Google searches they have to keep doing - OMIM, dbSNP, etc. This html document has hyperlinks for common searches. 

It also has custom selectable columns and filtering options to quickly do some basic searches (highest CADD, lowest cohort AF, etc.). These are fiddly to do in Excel. 

# Wow this sounds amazing, I want to use this right now!
You can run `devtools::install_github('davemcg/see_gem')` and read the documentation. Be warned - this is pre-alpha software and functions will change (sometimes dramatically). 

Contact me or do a pull request if you have questions, features, or ideas. Or bugs. 

