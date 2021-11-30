include("./util.jl")

struct On end
struct Off end
struct Toggle end

Op = Union{On,Off,Toggle}

parse_op(str::AbstractString)::Op =
    if str == "turn on"
        On()::Op
    elseif str == "turn off"
        Off()::Op
    elseif str == "toggle"
        Toggle()::Op
    else
        throw(DomainError("Unknown operation $str"))
    end

struct Instruction{T<:Op}
    op::T
    start::Tuple{Int,Int}
    finish::Tuple{Int,Int}
end

function process!(ins::Instruction{On}, arr::Array{Bool,2})::Nothing
    x0, y0 = ins.start
    x1, y1 = ins.finish
    arr[x0:x1, y0:y1] .= true
    nothing
end

function process!(ins::Instruction{Off}, arr::Array{Bool,2})::Nothing
    x0, y0 = ins.start
    x1, y1 = ins.finish
    arr[x0:x1, y0:y1] .= false
    nothing
end

function process!(ins::Instruction{Toggle}, arr::Array{Bool,2})::Nothing
    x0, y0 = ins.start
    x1, y1 = ins.finish
    arr[x0:x1, y0:y1] = broadcast(!, arr[x0:x1, y0:y1])
    nothing
end

function process!(ins::Instruction{On}, arr::Array{Int,2})::Nothing
    x0, y0 = ins.start
    x1, y1 = ins.finish
    arr[x0:x1, y0:y1] .+= 1
    nothing
end

function process!(ins::Instruction{Off}, arr::Array{Int,2})::Nothing
    x0, y0 = ins.start
    x1, y1 = ins.finish
    arr[x0:x1, y0:y1] .-= 1
    arr[x0:x1, y0:y1] = broadcast(v -> max(v, 0), arr[x0:x1, y0:y1])
    nothing
end

function process!(ins::Instruction{Toggle}, arr::Array{Int,2})::Nothing
    mod_ins = Instruction(On(), ins.start, ins.finish)
    process!(mod_ins, arr)
    process!(mod_ins, arr)
    nothing
end

function Instruction(str::AbstractString)::Instruction
    re =
        r"(?<op>turn on|turn off|toggle) (?<source_x>\d+),(?<source_y>\d+) through (?<target_x>\d+),(?<target_y>\d+)"
    m = match(re, str)
    if isnothing(m)
        throw(DomainError("No match for $str"))
    end
    Instruction(
        parse_op(m[:op]),
        (parse(Int, m[:source_x]), parse(Int, m[:source_y])),
        (parse(Int, m[:target_x]), parse(Int, m[:target_y])),
    )
end

instructions = map(Instruction, split(util.load_input(6), '\n'))

state = zeros(Bool, (1000, 1000))

for instruction in instructions
    process!(instruction, state)
end

println("Part 1: $(sum(state))")

new_state = zeros(Int, (1000, 1000))
for instruction in instructions
    process!(instruction, new_state)
end
println("Part 2: $(sum(new_state))")
