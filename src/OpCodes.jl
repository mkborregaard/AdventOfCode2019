module OpCodes

using OffsetArrays
import Base: iterate, setindex!, getindex

# process an instruction to an opcode
function process_instruction(instruction)
    dig = zeros(Int, 5)
    digits!(dig, instruction)
    dig[3:5], Val(instruction % 100)
end

# Handle getindex and setindex for different modes
struct ModeIndex{T}
    arg::Int
end
ModeIndex(T, arg) = ModeIndex{T}(arg)

setindex!(data::OffsetArray{T, 1} where T, val::Int, mi::ModeIndex) = (setindex!(data, val, mi.arg))
getindex(data::AbstractVector, mi::ModeIndex{0}) = getindex(data, mi.arg)
getindex(data::AbstractVector, mi::ModeIndex{1}) = mi.arg

# The IntComputer holding all the info
struct IntComputer
    data::OffsetArray{Int, 1}
    nargs::Dict{Type, Int}
    input::Ref{Int}
    output::Vector{Int}
end
function IntComputer(data)
    nargs = Dict(x.sig.parameters[3] => x.nargs-3 for x in methods(run_opcode!).ms)
    IntComputer(OffsetArray(copy(data), 0:length(data)-1), nargs, Ref(0), Int[])
end

function iterate(i::IntComputer, state = 0)
    modes, opcode = process_instruction(i.data[state])
    nargs = i.nargs[typeof(opcode)]
    modeargs = ModeIndex.(modes[1:nargs], i.data[state .+ (1:nargs)])
    f = run_opcode!(i, opcode, modeargs...)
    state = f > 0 ? f : state + nargs + 1
    f == -1 ? nothing : (nothing, state)
end

function compute(data, input)
    i = IntComputer(data)
    i.input[] = input
    for _ in i; end
    i
end

run_opcode!(::Any, ::Val) = error("unknown opcode")

export compute, inp, outp

end #OpCodes
