from beartype import beartype

from util import load_input


instructions = load_input(3)


@beartype
def deliveries(instructions: str) -> set[int]:
    """Find the number of houses that got at least one present.

    >>> num_deliveries(">")
    2

    >>> num_deliveries("^>v<")
    4

    >>> num_deliveries("^v^v^v^v^v")
    2
    """
    visited = set([(0, 0)])
    curr_pos = (0, 0)

    for ins in instructions:
        cx, cy = curr_pos
        match ins:
            case "^":
                curr_pos = (cx, cy - 1)
            case "v":
                curr_pos = (cx, cy + 1)
            case ">":
                curr_pos = (cx + 1, cy)
            case "<":
                curr_pos = (cx - 1, cy)
            case _:
                raise ValueError(f"Unknown instruction {ins}")
        visited.add(curr_pos)

    return visited

print(f"Part 1: {len(deliveries(instructions))}")

normal = ""
robo = ""

for i, ins in enumerate(instructions):
    if i % 2 == 0:
        normal += ins
    else:
        robo += ins

houses = deliveries(normal) | deliveries(robo)
print(f"Part 2: {len(houses)}")
