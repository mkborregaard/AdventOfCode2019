using Test

### Question 1

function runcodes!(p)
    for j in 1:4:length(p)
        p[j] == 99 && break
        src1, src2, dest = p[j .+ (1:3)] .+ 1
        if p[j] == 1
            p[dest] = p[src1] + p[src2]
        elseif p[j] == 2
            p[dest] = p[src1] * p[src2]
        else
            error("Unknown opcode")
        end
    end
end

# test cases

test1 = [1,9,10,3,2,3,11,0,99,30,40,50]
runcodes!(test1)
@test test1 == [3500,9,10,70, 2,3,11,0, 99, 30,40,50]
test2 = [2,4,4,5,99,0]
runcodes!(test2)
@test test2 == [2,4,4,5,99,9801]
test3 = [1,1,1,4,99,5,6,0,99]
runcodes!(test3)
@test test3 == [30,1,1,4,2,5,6,0,99]

p = parse.(Int, split(readline("Dec2_data.txt"), ','))
p[2:3] .= (12,2)
runcodes!(p)
p[1]

### Question 2

function fun2(input)
    for i in 0:99, j in 0:99
        p = copy(input)
        p[2:3] .= (i, j)
        runcodes!(p)
        p[1] == 19690720 && return(100i + j)
    end
    error("no input gave the right result")
end
p = parse.(Int, split(readline("Dec2_data.txt"), ','))
fun2(p)
