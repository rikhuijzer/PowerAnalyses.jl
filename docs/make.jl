using Documenter:
    DocMeta,
    HTML,
    asset,
    deploydocs,
    makedocs
using PowerAnalyses

DocMeta.setdocmeta!(
    PowerAnalyses,
    :DocTestSetup,
    :(using PowerAnalyses);
    recursive=true
)

sitename = "PowerAnalyses.jl"
pages = [
    "PowerAnalyses" => "index.md"
]

# Thanks to <https://github.com/JuliaDocs/Documenter.jl/pull/1706>.
attributes = Dict(
    :defer => "",
    :id => "pirschjs",
    Symbol("data-code") => "y1t1d27IvMPpcjUcbL5GxEfmfwqKxaQ3",
)
assets = [
    asset("https://api.pirsch.io/pirsch.js"; attributes, class=:js)
]
prettyurls = get(ENV, "CI", nothing) == "true"
format = HTML(; assets, prettyurls)
modules = [PowerAnalyses]
strict = true
checkdocs = :none
makedocs(; sitename, pages, format, modules, strict, checkdocs)

repo = "github.com/rikhuijzer/PowerAnalyses.jl.git"
push_preview = false
devbranch = "main"
deploydocs(; devbranch, repo, push_preview)
