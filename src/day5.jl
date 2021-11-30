using Test: @test
include("./util.jl")



function is_nice(str::AbstractString)::Bool
    if contains(str, "ab") ||
       contains(str, "cd") ||
       contains(str, "pq") ||
       contains(str, "xy")
        return false
    end
    vowel_count = length(filter(c -> c in ['a', 'e', 'i', 'o', 'u'], str))
    vowel_count >= 3 && contains(str, r"([a-z])\1")
end


@test is_nice("ugknbfddgicrmopn")
@test is_nice("aaa")
@test !is_nice("jchzalrnumimnmhp")
@test !is_nice("haegwjzuvuyypxyu")
@test !is_nice("dvszwmarrgswjxmb")

strings = split(util.load_input(5), '\n')
nice_strings = filter(is_nice, strings)

println("Part 1: $(length(nice_strings))")

function is_really_nice(str::AbstractString)::Bool
    contains(str, r"([a-z][a-z]).*\1") && contains(str, r"([a-z]).\1")
end

@test is_really_nice("qjhvhtzxzqqjkmpb")
@test is_really_nice("xxyxx")
@test !is_really_nice("uurcxstgmygtbstg")
@test !is_really_nice("ieodomkazucvgmuy")

really_nice_strings = filter(is_really_nice, strings)
println("Part 2: $(length(really_nice_strings))")
