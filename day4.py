import hashlib

d5_input = "iwrupvqb"


def find_with_prefix(prefix: str) -> int:
    curr = 1

    while True:
        md = hashlib.md5()
        md.update(f"{d5_input}{curr}".encode("ascii"))
        h = md.hexdigest()
        if h.startswith(prefix):
            break
        else:
            curr += 1

    return curr


print(f"Part 1: {find_with_prefix('00000')}")
print(f"Part 2: {find_with_prefix('000000')}")
