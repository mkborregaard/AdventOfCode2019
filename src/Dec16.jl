getdata(data) = parse.(Int, split(data, ""))
dats = getdata(readline("data/Dec16_data.txt"))

pattern(n, i) =  (r = 1 + n ÷ i % 4; (3 - r) * ((1 + r) % 2))

function run1(dats)
    next = similar(dats)
    for j in 1:100
        for i in eachindex(next)
            s = sum(n -> dats[n] * pattern(n,i), eachindex(dats))
            next[i] = abs(digits(s)[1])
        end
        dats, next = next, dats
    end
    dats
end

using Profile
Profile.init(10000000, 0.001)
@profiler run1(dats)[1:8]

using BenchmarkTools
@btime run1($(dats))
