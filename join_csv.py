#!/usr/bin/env python3
"""Simple script to join all CSV files inside a folder"""
import argparse
from pathlib import Path


def main(input_dir: str):
    input_path = Path(input_dir).resolve()

    assert input_path.exists(), "You must provide a valid path!"
    assert input_path.is_dir(), "You must provide a directory!"

    list_of_csv_files = list(input_path.glob("*.csv"))
    print("List of files to merge:")
    print(list_of_csv_files)
    merged_path = input_path / "merged.csv"
    header_written = False
    with merged_path.open("w", encoding="ISO-8859-1") as writer:
        for file in list_of_csv_files:
            print(file)
            with file.open("r", encoding="ISO-8859-1") as input_file:
                header = next(input_file)  # gets header
                if not header_written:
                    writer.write(header)
                    header_written = True
                writer.write(input_file.read())
    print("Done!")
    exit(0)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Join all CSV files"
    )
    parser.add_argument(
        "input_dir",
        type=str,
        help="Input dir where CSV files are stored"
    )
    args = parser.parse_args()
    main(input_dir=args.input_dir)
