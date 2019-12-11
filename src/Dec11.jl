include("Opcodes.jl")
using .OpCodes
using StaticArrays

function run1(data)
    left =  @SMatrix [0  1;
                     -1  0]
    right = @SMatrix [0 -1;
                      1  0]
    dir =   @SVector [-1, 0]
    pos =   @SVector [0, 0]
    field = Set{typeof(pos)}()
    inp = Channel{Int}(1)
    outp = Channel{Int}(1)
    ic = IntComputer(data, inp, outp)
    @async compute!(ic)
    while !ic.finished[]
        instr = pos ∈ field ? 1 : 0
        put!(inp, instr)
        color = take!(outp)
        color == 1 && push!(field, pos)
    #    put!(inp, instr)
        dir = take!(outp) == 1 ? right * dir : left * dir
        pos = pos + dir
    end
end

run1(readline("data/Dec11_data.txt"))
