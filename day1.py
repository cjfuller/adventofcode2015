from beartype import beartype

from util import load_input


instructions = load_input(1)
floor = 0
basement = None

for pos, i in enumerate(instructions):
    match i:
        case "(":
            floor += 1
        case ")":
            floor -= 1
        case _:
            raise ValueError(f"Unknown instruction {i}")

    if floor < 0 and basement is None:
        basement = pos + 1


print(f"Part 1: {floor}")
print(f"Part 2: {basement}")
