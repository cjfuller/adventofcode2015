include("./util.jl")
using Test: @test

instructions = util.load_input(3)

function deliveries(instructions::String)::Set{Tuple{Int,Int}}
    visited = Set()
    curr_pos = (0, 0)
    push!(visited, curr_pos)

    for ins in instructions
        cx, cy = curr_pos
        if ins == '^'
            curr_pos = (cx, cy - 1)
        elseif ins == 'v'
            curr_pos = (cx, cy + 1)
        elseif ins == '>'
            curr_pos = (cx + 1, cy)
        elseif ins == '<'
            curr_pos = (cx - 1, cy)
        else
            throw(DomainError("Unknown instruction $ins"))
        end

        push!(visited, curr_pos)
    end
    visited
end

num_deliveries(instructions) = length(deliveries(instructions))

@test num_deliveries(">") == 2
@test num_deliveries("^>v<") == 4
@test num_deliveries("^v^v^v^v^v") == 2

println("Part 1: $(num_deliveries(instructions))")

normal = ""
robo = ""

for (i, ins) in enumerate(instructions)
    if i % 2 == 0
        global normal *= ins
    else
        global robo *= ins
    end
end

houses = union(deliveries(normal), deliveries(robo))
println("Part 2: $(length(houses))")