# https://adventofcode.com/2019/day/14
using StaticArrays

parsebite(str) = (ret = split(str, " "); (parse(Int, ret[1]), Symbol(string(ret[2]))))

function parse_requirements(data)
    reqs = Dict{Symbol, Tuple{Int, SVector, SVector}}()
    for line in data
        @show line
        ingr, prods = split(line, " => ")
        ingrs = parsebite.(split(ingr, ", "))
        prod_amount, prod = parsebite(prods)
        ingr_amount = SVector{length(ingrs)}([x[1] for x in ingrs])
        ingr = SVector{length(ingrs)}([Symbol(string(x[2])) for x in ingrs])
        reqs[prod] = (prod_amount, ingr_amount, ingr)
    end
    reqs
end

function makefuel(reqs, stock = Dict{Symbol, Int}())
    function produce(amount, material)
        material == :ORE && return amount
        ore = 0
        prod_amount, ingr_amount, ingr = reqs[material]
        while amount > get!(stock, material, 0)
            for i in eachindex(ingr)
                ore += sum(produce(ingr_amount[i], ingr[i]))
            end
            stock[material] += prod_amount
        end
        stock[material] -= amount
        ore
    end
    produce(1, :FUEL), stock
end

data = readlines("data/2019/day_14.txt")
reqs = parse_requirements(data)
@btime makefuel(reqs)

using ProgressMeter

function run2(reqs)
    tot = div(1000000000000, 1000)
    stock = Dict{Symbol, Int}()
    usedore = 0
    rounds = 0
    p = Progress(tot)
    ms = Int[]
    while usedore < tot
        m, stock = makefuel(reqs, stock)
        usedore += m
        rounds += 1
        push!(ms, m)
        update!(p, usedore)
    end
    ms
end

m = run2(reqs)
length(m)

function findlag(v)
    f = 1
    while true
        f = findnext(==(v[1]), v, f+1)
        (!isnothing(f) || f > div(length(v),2)) && return 0
        v[1:f] == v[f .+ (1:f) .- 1] && return f-1
    end
end

findlag(reverse(m))
findlag(reverse(x))
