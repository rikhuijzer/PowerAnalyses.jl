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

prettyurls = get(ENV, "CI", nothing) == "true"
format = HTML(; prettyurls)
modules = [PowerAnalyses]
checkdocs = :none
makedocs(; sitename, pages, format, modules, checkdocs)

deploydocs(;
    branch="docs",
    devbranch="main",
    repo="github.com/rikhuijzer/PowerAnalyses.jl.git",
    push_preview=false
)
