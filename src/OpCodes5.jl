module OpCodes5

using Reexport
include("OpCodes2.jl")
@reexport using .OpCodes2
import .OpCodes2: run_opcode!

run_opcode!(ic, ::Val{3}, arg) = (ic.data[arg] = ic.input[]; 0)
run_opcode!(ic, ::Val{4}, arg) = (push!(ic.output, ic.data[arg]); 0)
run_opcode!(ic, ::Val{5}, pred, inst) = pred != 0 ? ic.data[inst] : 0
run_opcode!(ic, ::Val{6}, pred, inst) = pred == 0 ? ic.data[inst] : 0
run_opcode!(ic, ::Val{7}, arg1, arg2, dest) = (ic.data[dest] = Int(arg1 < arg2); 0)
run_opcode!(ic, ::Val{8}, arg1, arg2, dest) = (ic.data[dest] = Int(arg1 == arg2); 0)

end #OpCodes5
