module OpCodes2

include("OpCodes.jl")
import .OpCodes: run_opcode!
using Reexport
@reexport using .OpCodes

run_opcode!(ic, ::Val{99}) = -1
run_opcode!(ic, ::Val{1}, src1, src2, dest) =
    (ic.data[dest] = ic.data[src1] + ic.data[src2]; 0)
run_opcode!(ic, ::Val{2}, src1, src2, dest) =
    (ic.data[dest] = ic.data[src1] * ic.data[src2]; 0)

end #OpCodes2
