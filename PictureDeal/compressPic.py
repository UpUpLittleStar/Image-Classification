from __future__ import division
from PIL import Image
import os, sys
folderPath = r"./picture/"  # pic folder path
tfile = os.listdir(folderPath)
picSet = []
for picIdx in range(0, len(tfile)):
    infile = folderPath + "/" + tfile[picIdx]
    p, fe = os.path.split(infile)
    f, e = os.path.splitext(fe)
    outputFp = f + ".jpg"
    picSet.append(outputFp)
    normal_outfile = r"./download/" + outputFp  #output filepath
    im = Image.open(infile)
    im_ratio = im.width / im.height
    normal_out = im.resize((int(480 * im_ratio), 480))  # Set resolution
    normal_out.save(normal_outfile, quality=95)  # set quality (0-100) default=95
