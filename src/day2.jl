include("./util.jl")
using Test: @test

box_specs = util.load_input(2)

struct Box
    l::Int
    w::Int
    h::Int
end


function Box(s::AbstractString)::Box
    l, w, h = tuple(map(part -> parse(Int, part), split(s, 'x'))...)
    Box(l, w, h)
end

surface_area(b::Box)::Int = 2 * b.l * b.w + 2 * b.w * b.h + 2 * b.h * b.l

paper_area(b::Box)::Int = surface_area(b) + min(b.l * b.w, b.w * b.h, b.h * b.l)

@test paper_area(Box("2x3x4")) == 58
@test paper_area(Box("1x1x10")) == 43

perimeters(b::Box)::Tuple{Int,Int,Int} = (2 * (b.l + b.w), 2 * (b.w + b.h), 2 * (b.h + b.l))

ribbon_length(b::Box)::Int = min(perimeters(b)...) + b.l * b.w * b.h

boxes = map(Box, split(box_specs, '\n'))

total_sqft = sum(map(paper_area, boxes))
println("Part 1: $total_sqft")

total_ribbon_ft = sum(map(ribbon_length, boxes))
println("Part 2: $total_ribbon_ft")
