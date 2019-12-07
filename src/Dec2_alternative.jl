
module OpCodes

using OffsetArrays
import Base: iterate

struct IntComputer
    data::OffsetArray{Int, 1}
    nargs::Dict{Int, Int}
end

IntComputer(data, nargs) =
    IntComputer(OffsetArray(copy(data), 0:length(data)-1), nargs)

function iterate(i::IntComputer, state = 0)
    opcode = i.data[state]
    lastind = state + i.nargs[opcode]
    isnothing(fun!(i.data, Val{opcode}, i.data[state+1:lastind]...)) && return nothing
    nothing, lastind + 1
end

function compute(data, nargs)
    i = IntComputer(data, nargs)
    for _ in i; end
    i.data.parent
end

fun!(args...) = error("unknown opcode")
end

import .OpCodes: compute, fun!

fun!(data, ::Val{99}, args...) = nothing

function fun!(data, ::Val{1}, args...)
    src1, src2, dest = args
    data[dest] = data[src1] + data[src2]
end

function fun!(data, ::Val{2}, args...)
    src1, src2, dest = args
    data[dest] = data[src1] * data[src2]
end

nargs = Dict(1=>3, 2=>3, 99=>0)

data = parse.(Int, split(readline("Dec2_data.txt"), ','))
res = compute(data, nargs)[1]
