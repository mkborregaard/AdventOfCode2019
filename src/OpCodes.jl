module OpCodes

using OffsetArrays
import Base: iterate, setindex!, getindex

# process an instruction to an opcode
function process_instruction!(digit, instruction)
    digits!(digit, instruction)
    Val(instruction % 100)
end

# The IntComputer holding all the info
struct IntComputer
    data::OffsetArray{Int, 1}
    nargs::Dict{Type, Int}
    input::Channel{Int}
    output::Channel{Int}
    relativeindex::Ref{Int}
    extradata::Dict{Int, Int}
    finished::Bool
end
function IntComputer(data, input = Channel{Int}(32), output = Channel{Int}(256))
    nargs = Dict(x.sig.parameters[3] => x.nargs-3 for x in methods(run_opcode!).ms)
    IntComputer(OffsetArray(copy(data), 0:length(data)-1), nargs, input, output, Ref(0), Dict{Int, Int}(), false)
end
IntComputer(str::AbstractString, input = Channel{Int}(32), output = Channel{Int}(256)) =
    IntComputer(parse.(Int, split(str, ',')), input, output)

# Handle getindex and setindex for different modes
struct ModeIndex{T}
    arg::Int
end
ModeIndex(T, arg) = ModeIndex{T}(arg)

setindex!(ic::IntComputer, val::Int, mi::ModeIndex) = setindex!(ic, val, mi.arg)
setindex!(ic::IntComputer, val::Int, mi::ModeIndex{2}) = setindex!(ic, val, ic.relativeindex[] + mi.arg)
setindex!(ic::IntComputer, val::Int, arg) = arg > length(ic.data)-1 ? ic.extradata[arg] = val : ic.data[arg] = val
getindex(ic::IntComputer, mi::ModeIndex{0}) = getindex(ic, mi.arg)
getindex(ic::IntComputer, mi::ModeIndex{1}) = mi.arg
getindex(ic::IntComputer, mi::ModeIndex{2}) = getindex(ic, ic.relativeindex[] + mi.arg)
getindex(ic::IntComputer, arg) = arg > length(ic.data)-1 ? get!(ic.extradata, arg, 0) : ic.data[arg]

addinput!(ic::IntComputer, inp) = put!(ic.input, inp)
takeinput!(ic::IntComputer) = take!(ic.input)
getoutput(ic::IntComputer) = (close(ic.output); collect(ic.output))

compute!(ic::IntComputer, input) = (addinput!(ic, input); compute!(ic))
function compute!(ic::IntComputer)
    state = 0
    ic.relativeindex[] = 0
    modeargs = Vector{ModeIndex}(undef, 3)
    modes = Vector{Int}(undef, 5)
    while state > -1
        opcode = process_instruction!(modes, ic.data[state])
        nargs = ic.nargs[typeof(opcode)]
        resize!(modeargs, nargs)
        modeargs .= ModeIndex.(modes[2 .+ (1:nargs)], ic.data[state .+ (1:nargs)])
        f = run_opcode!(ic, opcode, modeargs...)
        state = f == 0 ? state + nargs + 1 : f
    end
    ic.finished = true
    ic
end

run_opcode!(::Any, ::Val) = error("unknown opcode")
run_opcode!(ic, ::Val{99}) = -1
run_opcode!(ic, ::Val{1}, src1, src2, dest) = (ic[dest] = ic[src1] + ic[src2]; 0)
run_opcode!(ic, ::Val{2}, src1, src2, dest) = (ic[dest] = ic[src1] * ic[src2]; 0)
run_opcode!(ic, ::Val{3}, arg) = (ic[arg] = takeinput!(ic); 0)
run_opcode!(ic, ::Val{4}, arg) = (ic[arg] != 0 && put!(ic.output, ic[arg]); 0)
run_opcode!(ic, ::Val{5}, pred, inst) = ic[pred] != 0 ? ic[inst] : 0
run_opcode!(ic, ::Val{6}, pred, inst) = ic[pred] == 0 ? ic[inst] : 0
run_opcode!(ic, ::Val{7}, arg1, arg2, dest) = (ic[dest] = Int(ic[arg1] < ic[arg2]); 0)
run_opcode!(ic, ::Val{8}, arg1, arg2, dest) = (ic[dest] = Int(ic[arg1] == ic[arg2]); 0)
run_opcode!(ic, ::Val{9}, arg) = (ic.relativeindex[] += ic[arg]; 0)

export compute!, IntComputer, getoutput, addinput!

end #OpCodes
