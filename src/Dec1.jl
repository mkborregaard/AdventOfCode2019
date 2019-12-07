p = parse.(Int, readlines("Dec1_data.txt"))

# Question 1
fun(x) = div(x, 3) - 2

# test cases
fun(1969)    # should be 654
fun(100756)  # should be 33583

# result 1
sum(fun, p)

# Question 2
function fun2(rem)
    ret = fun(rem)
    ret <= 0 ? 0 : ret += fun2(ret)
end

# test cases
fun2(1969)    # should be 966
fun2(100756)  # should be 100756

# result 2
sum(fun2, p)
