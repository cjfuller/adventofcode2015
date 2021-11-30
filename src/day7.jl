include("./util.jl")

RegOrValue = Union{AbstractString,UInt16}

struct LShift
    value::RegOrValue
    amount::UInt16
end
struct RShift
    value::RegOrValue
    amount::UInt16
end
struct And
    lhs::RegOrValue
    rhs::RegOrValue
end
struct Or
    lhs::RegOrValue
    rhs::RegOrValue
end
struct Not
    value::RegOrValue
end
struct Store
    value::RegOrValue
end

Op = Union{LShift,RShift,And,Or,Not,Store}

struct Instruction
    op::Op
    target::String
end

function reg_or_value(s::AbstractString)::RegOrValue
    tried = tryparse(UInt16, s)
    if isnothing(tried)
        s
    else
        tried
    end
end

function Instruction(s::AbstractString)::Instruction
    re =
        r"(?:(?:(?<lhs>[a-z0-9]+) (?<op>AND|OR|RSHIFT|LSHIFT) (?<rhs>[a-z0-9]+))|(?:(?<nop>NOT) (?<nvalue>[a-z0-9]+))|(?<value>[a-z0-9]+)) -> (?<target>[a-z]+)"


    m = match(re, s)
    if isnothing(m)
        throw(DomainError("Unknown instruction $s"))
    end
    op = if isnothing(m[:op]) && isnothing(m[:nop])
        Store(reg_or_value(m[:value]))
    elseif m[:nop] == "NOT"
        Not(reg_or_value(m[:nvalue]))
    elseif m[:op] == "AND"
        And(reg_or_value(m[:lhs]), reg_or_value(m[:rhs]))
    elseif m[:op] == "OR"
        Or(reg_or_value(m[:lhs]), reg_or_value(m[:rhs]))
    elseif m[:op] == "RSHIFT"
        RShift(reg_or_value(m[:lhs]), reg_or_value(m[:rhs]))
    elseif m[:op] == "LSHIFT"
        LShift(reg_or_value(m[:lhs]), reg_or_value(m[:rhs]))
    else
        throw(DomainError("Unknown op $(m[:op])"))
    end
    Instruction(op, m[:target])
end

instructions = Dict()
cache = Dict()

inputs = map(Instruction, split(util.load_input(7), '\n'))

for i in inputs
    instructions[i.target] = i
end

function resolve(register::AbstractString)::UInt16
    if register in keys(cache)
        cache[register]
    else
        result = compute(instructions[register].op)
        cache[register] = result
        result
    end
end

resolve(value::UInt16)::UInt16 = value

compute(op::Store)::UInt16 = resolve(op.value)

compute(op::Not)::UInt16 = ~resolve(op.value)

compute(op::Or)::UInt16 = resolve(op.lhs) | resolve(op.rhs)

compute(op::And)::UInt16 = resolve(op.lhs) & resolve(op.rhs)

compute(op::RShift)::UInt16 = resolve(op.value) >> op.amount

compute(op::LShift)::UInt16 = resolve(op.value) << op.amount


reg_a = resolve("a")
println("Part 1: $reg_a")

for k in keys(cache)
    delete!(cache, k)
end
instructions["b"] = Instruction(Store(UInt16(16076)), "b")

reg_a = resolve("a")
println("Part 2: $reg_a")
