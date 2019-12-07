in = "128392-643281"
sta, sto = parse.(Int, split(in, '-'))

ispass(dif) = any(==(0), dif) && all(>=(0), dif)
ispassword(num, pred) = pred(diff(reverse(digits(num))))
count(x->ispassword(x, ispass), sta:sto)

function ispass2(dif)
    all(>=(0), dif) || return false
    reps = findall(==(0), dif)
    isempty(reps) && return false
    for r ∈ reps
        r-1 ∈ reps || r + 1 ∈ reps || return true
    end
    false
end

count(x->ispassword(x, ispass2), sta:sto)
