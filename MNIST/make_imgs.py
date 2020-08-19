#!/usr/bin/env python3

import csv
import os
import pathlib

import imageio
import numpy as np


IMG_WIDTH = 28
IMG_HEIGHT = 28


def run(infile, outdir, label=None):
    _make_dir(outdir)

    # parse file
    reader = csv.DictReader(infile)

    fieldnames = None

    for i, row in enumerate(reader):
        if fieldnames is None:
            fieldnames = [x for x in reader.fieldnames if x != label]

        label_val = row.pop(label) if label else None
        pixels = [row[x] for x in fieldnames]

        array = np.array(pixels, dtype=np.uint8)
        array = array.reshape((IMG_WIDTH, IMG_HEIGHT))

        # print(label_val)
        # print(pixels)
        # print(array)

        path_parts = [outdir]
        if label:
            path_parts.append(label_val)
        _make_dir(os.path.join(*path_parts))
        path_parts.append(f'{i:05}.png')

        filename = os.path.join(*path_parts)
        # print(filename)

        imageio.imwrite(filename, array)


_EXISTING_PATHS = set()

def _make_dir(dirpath):
    if dirpath not in _EXISTING_PATHS and not os.path.exists(dirpath):
        # mkdir -p
        pathlib.Path(dirpath).mkdir(parents=True, exist_ok=True)
        _EXISTING_PATHS.add(dirpath)



def _make_img(grays):
    pass


##

def main():
    import argparse
    import sys
    parser = argparse.ArgumentParser(description='CSV manipulator')
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin,
                        help='CSV file to parse')
    parser.add_argument('outdir', type=str, help='path to output directory')
    parser.add_argument('--label', '-', type=str, default=None,
                        help='optional label column name (if training data)')
    args = parser.parse_args()

    run(args.infile, args.outdir, args.label)


if __name__ == '__main__':
    main()
