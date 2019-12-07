parseline(line) = parse.(Int, split(line, ' '))
parselines(file) = parseline.(readlines(file))
