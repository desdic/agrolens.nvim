#!/usr/bin/env python3

import argparse
import logging

logger = logging.getLogger(__name__)


class Stuff:
    def hello(self):
        print("hello")


def hello():
    print("hello")


def main():
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument("--debug", "-d", action="store_true", help="enable debug")
    args = arg_parser.parse_args()

    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)

    hello()
    m = Stuff()
    m.hello()


if __name__ == "__main__":
    main()
