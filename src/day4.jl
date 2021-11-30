using MD5: md5

d5_input = "iwrupvqb"

function find_with_prefix(prefix::String)::Int
    curr = 1
    while true
        h = bytes2hex(md5("$d5_input$curr"))
        if startswith(h, prefix)
            break
        else
            curr += 1
        end
    end
    curr
end

part_1 = find_with_prefix("00000")
println("Part 1: $part_1")
part_2 = find_with_prefix("000000")
println("Part 2: $part_2")

