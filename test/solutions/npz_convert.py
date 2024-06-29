import argparse
import cv2 as cv
import numpy as np

def npz(filename):
    if not filename.endswith('.npz'):
        raise argparse.ArgumentTypeError(f'filename argument {filename} does not have a .npz extension')
    return filename

parser = argparse.ArgumentParser(
                    prog='npz_convert',
                    description='Convert numpy .npz file to opencv .yml FileStorage file')

parser.add_argument('filename', help='.npz file to convert', type=npz)
parser.add_argument('-o', '--output', help='Destination file. Default: <filename>.yml')

args = parser.parse_args()

npz_path = args.filename
output = npz_path[:-len('.npz')] + '.yml' if args.output is None else args.output

data = np.load(npz_path)

storage = cv.FileStorage(output, cv.FileStorage_WRITE)

for key in data.keys():
    storage.write(key, data[key])

storage.release()

print('file has been written to', output)
