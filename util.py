from dataclasses import is_dataclass
from typing import TypeVar, Type

from beartype import beartype

T = TypeVar("T")


def bear_init(cls: Type[T]) -> Type[T]:
    """From: https://github.com/beartype/beartype/issues/56"""
    assert is_dataclass(cls)
    cls.__init__ = beartype(cls.__init__)
    return cls


@beartype
def load_input(day: int, strip: bool = True) -> str:
    with open(f"inputs/day_{day}.txt") as f:
        s = f.read()
        if strip:
            return s.strip()
        return s
