include("Opcodes.jl")
using .OpCodes
using StaticArrays

left =  @SMatrix [0  1;
                 -1  0]
right = @SMatrix [0 -1;
                  1  0]
dir =   @MVector [-1, 0]
pos =   @MVector [0, 0]
field = Set{typeof(pos)}()

inp = Channel{Int}(1)
outp = Channel{Int}(2)

ic = IntComputer(readline("data/Dec11_data.txt"), inp, outp)
@async compute!(ic)
put!(inp, 0)
take!(outp)
                 
