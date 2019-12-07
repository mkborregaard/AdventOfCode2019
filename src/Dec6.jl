# Jeg startede med at lave den den "forkerte" vej - indefra og ud (denne måde er dog klart hurtigst)

function makedict(edgelist)
    d = Dict{String, Vector{String}}()
    for line in edgelist
        src, dest = split(line, ')')
        if !haskey(d, src)
            d[src] = [dest]
        else
            push!(d[src], dest)
        end
    end
    d
end

traverse(edges::Dict, current::String, counter::Int) =
    counter + (haskey(edges, current) ?
        sum(map(x->traverse(edges, x, counter + 1), edges[current])) : 0)


test = split("""
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L""", '\n')

traverse(makedict(test), "COM", 0)

edgelist = makedict(readlines("Dec6_data.txt"))
traverse(edgelist, "COM", 0)



## Alternativt kan man gøre det udefra og ind. Her bytter man om på src og dest
# når man laver sin dict. Eller - man gør som jeg og "vender" sin dict om

function reversedict(d)
    rev = Dict{String, String}()
    for (key, value) in d
        for v in value
            rev[v] = key
        end
    end
    rev
end

# Så bliver traverse meget nem at programmere:
function traverse_reverseddict(d)
    acc = 0
    for planet in keys(d)
        while planet != "COM"
            acc += 1
            planet = d[planet]
        end
    end
    acc
end

traverse_reverseddict(reversedict(edgelist)) # giver samme resultat

# Løsningen på spørgsmål 2 bruger også den "reversed" dictionary
# Jeg laver en linje fra "YOU" og hele vejen ind. Så laver jeg et
# `Set` af alle de planeter jeg møder på vejen (et Set er som en liste
# hvor elementerne ikke har rækkefølge, men den er meget hurtig at søge i).
# Endelig laver jeg en linje fra "SAN" og indtil første gang jeg møder et
# element fra den første linje

function moves(l1, l2, rd)
    yous = String[]
    d = rd[l1]
    while d != "COM"
        d = rd[d]
        push!(yous, d)
    end
    youset = Set(yous)
    d = rd[l2]
    counter = 0
    while !(d ∈ youset)
        counter += 1
        d = rd[d]
    end
    counter + findfirst(==(d), yous)
end

test2 = reversedict(makedict(split("""
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN""", '\n')))

moves("SAN", "YOU", test2)

moves("SAN", "YOU", reversedict(edgelist))
