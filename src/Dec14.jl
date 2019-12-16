# https://adventofcode.com/2019/day/14
using StaticArrays

parsebite(str) = (ret = split(str, " "); (parse(Int, ret[1]), Symbol(string(ret[2]))))

function parse_requirements(data)
    reqs = Dict{Symbol, Tuple{Int, SVector, SVector}}()
    for line in data
        ingr, prods = split(line, " => ")
        ingrs = parsebite.(split(ingr, ", "))
        prod_amount, prod = parsebite(prods)
        ingr_amount = SVector{length(ingrs)}([x[1] for x in ingrs])
        ingr = SVector{length(ingrs)}([Symbol(string(x[2])) for x in ingrs])
        reqs[prod] = (prod_amount, ingr_amount, ingr)
    end
    reqs
end

function makefuel(reqs, x = 1)
    function produce(amount, material)
        material == :ORE && return amount
        ore = 0
        prod_amount, ingr_amount, ingr = reqs[material]
        d,r = divrem(amount - get!(stock, material, 0), prod_amount)
        am = d + Int(r>0)
        @inbounds for i in eachindex(ingr)
            ore += sum(produce(ingr_amount[i]*am, ingr[i]))
        end
        stock[material] += prod_amount * am - amount
        ore
    end
    stock = Dict{Symbol, Int}()
    produce(x, :FUEL)
end

function run2(reqs)
    tot = 1000000000000
    xs = 0
    step = 10000
    sig = 1
    while true
        m = makefuel(reqs, xs += step)
        newsig = sign(tot-m)
        sig != newsig && (step = -div(step, 2))
        sig = newsig
        step == 0 && return xs - Int(m > tot)
    end
end

# Question 1
data = readlines("data/Dec14_data.txt")
reqs = parse_requirements(data)
@btime makefuel($(reqs))

# Question 2
@btime run2(reqs)
