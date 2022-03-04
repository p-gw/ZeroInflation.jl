using ZeroInflation
using Documenter

DocMeta.setdocmeta!(ZeroInflation, :DocTestSetup, :(using ZeroInflation); recursive=true)

makedocs(;
    modules=[ZeroInflation],
    authors="Philipp Gewessler <p.gewessler@gmx.at> and contributors",
    repo="https://github.com/p-gw/ZeroInflation.jl/blob/{commit}{path}#{line}",
    sitename="ZeroInflation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://p-gw.github.io/ZeroInflation.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/p-gw/ZeroInflation.jl",
    devbranch="main",
)
