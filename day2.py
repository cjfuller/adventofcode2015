from dataclasses import dataclass

from util import load_input, bear_init


box_specs = load_input(2)


@bear_init
@dataclass
class Box:
    l: int
    w: int
    h: int

    @classmethod
    def from_str(cls, s: str) -> "Box":
        l, w, h = tuple(map(int, s.split("x")))
        return Box(l, w, h)

    @property
    def surface_area(self) -> int:
        return 2 * self.l * self.w + 2 * self.w * self.h + 2 * self.h * self.l

    @property
    def paper_area(self) -> int:
        """Total area of paper required.

        >>> Box.from_str("2x3x4").paper_area
        58

        >>> Box.from_str("1x1x10").paper_area
        43
        """
        return self.surface_area + min(
            self.l * self.w, self.w * self.h, self.h * self.l
        )

    @property
    def perimeters(self) -> tuple[int, int, int]:
        return (2 * (self.l + self.w), 2 * (self.w + self.h), 2 * (self.h + self.l))

    @property
    def ribbon_length(self) -> int:
        return min(self.perimeters) + self.l * self.w * self.h


boxes = [Box.from_str(spec) for spec in box_specs.splitlines()]

total_sqft = sum(box.paper_area for box in boxes)

print(f"Part 1: {total_sqft}")

total_ribbon_ft = sum(box.ribbon_length for box in boxes)

print(f"Part 2: {total_ribbon_ft}")
