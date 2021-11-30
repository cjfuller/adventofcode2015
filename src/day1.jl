include("./util.jl")

instructions = util.load_input(1)

floor = 0
basement = nothing

for (pos, i) in enumerate(instructions)
    if i == '('
        global floor += 1
    elseif i == ')'
        global floor -= 1
    else
        throw(DomainError("unknown instruction $i"))
    end

    if floor < 0 && isnothing(basement)
        global basement = pos
    end
end

println("Part 1: $floor")
println("Part 2: $basement")
