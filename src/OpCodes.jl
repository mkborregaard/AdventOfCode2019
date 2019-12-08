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
    input::Channel{Int}
    output::Channel{Int}
end
function IntComputer(data, input = Channel{Int}(32), output = Channel{Int}(256))
    nargs = Dict(x.sig.parameters[3] => x.nargs-3 for x in methods(run_opcode!).ms)
    IntComputer(OffsetArray(copy(data), 0:length(data)-1), nargs, input, output)
end
IntComputer(str::AbstractString, input = Channel{Int}(32), output = Channel{Int}(256)) =
    IntComputer(parse.(Int, split(str, ',')), input, output)

addinput!(ic::IntComputer, inp) = put!(ic.input, inp)
getoutput(ic::IntComputer) = (close(ic.output); collect(ic.output))

compute!(ic::IntComputer, input) = (addinput!(ic, input); compute!(ic))
function compute!(ic::IntComputer)
    state = 0
    while state > -1
        modes, opcode = process_instruction(ic.data[state])
        nargs = ic.nargs[typeof(opcode)]
        modeargs = ModeIndex.(modes[1:nargs], ic.data[state .+ (1:nargs)])
        f = run_opcode!(ic, opcode, modeargs...)
        state = f == 0 ? state + nargs + 1 : f
    end
    ic
end

run_opcode!(::Any, ::Val) = error("unknown opcode")
run_opcode!(ic, ::Val{99}) = -1
run_opcode!(ic, ::Val{1}, src1, src2, dest) = (ic.data[dest] = ic.data[src1] + ic.data[src2]; 0)
run_opcode!(ic, ::Val{2}, src1, src2, dest) = (ic.data[dest] = ic.data[src1] * ic.data[src2]; 0)
run_opcode!(ic, ::Val{3}, arg) = (ic.data[arg] = takeinput!(ic); 0)
run_opcode!(ic, ::Val{4}, arg) = (put!(ic.output, ic.data[arg]); 0)
run_opcode!(ic, ::Val{5}, pred, inst) = ic.data[pred] != 0 ? ic.data[inst] : 0
run_opcode!(ic, ::Val{6}, pred, inst) = ic.data[pred] == 0 ? ic.data[inst] : 0
run_opcode!(ic, ::Val{7}, arg1, arg2, dest) = (ic.data[dest] = Int(ic.data[arg1] < ic.data[arg2]); 0)
run_opcode!(ic, ::Val{8}, arg1, arg2, dest) = (ic.data[dest] = Int(ic.data[arg1] == ic.data[arg2]); 0)

export compute!, IntComputer, getoutput, addinput!

end #OpCodes
