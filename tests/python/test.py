#!/usr/bin/env python3

"""
Python implementation of person
"""

from datetime import datetime


class Person:
    def __init__(self, name: str, born: str):
        self.name = name
        self.born = born

    def print(self, format):
        print(format(self))
        pass


def format(p: Person) -> str:
    """
    Format returns the Person formatted
    """
    borndate = datetime.strptime(p.born, "%d-%m-%Y")
    now = datetime.today()

    days = (now - borndate).days

    return f"{p.name} is {days} days old"


def main():
    # Create Donald
    donald = Person(name="Donald Duck", born="07-09-1934")
    donald.print(format)


if __name__ == "__main__":
    main()
