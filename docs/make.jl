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
    "Test page" => "test.md"
]

prettyurls = get(ENV, "CI", nothing) == "true"
format = HTML(; prettyurls)
modules = [PowerAnalyses]
strict = true
checkdocs = :none
makedocs(; sitename, pages, format, modules, strict, checkdocs)

repo = "github.com/rikhuijzer/PowerAnalyses.jl.git"
push_preview = false
devbranch = "main"
deploydocs(; devbranch, repo, push_preview)
