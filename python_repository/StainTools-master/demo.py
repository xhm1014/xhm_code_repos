from __future__ import division

from utils import visual_utils as vu
from utils import misc_utils as mu
from normalization.reinhard import ReinhardNormalizer
from normalization.macenko import MacenkoNormalizer
from normalization.vahadane import VahadaneNormalizer

#load_ext autoreload
#autoreload 2

import numpy as np
import matplotlib.pyplot as plt
#matplotlib inline

i1 = vu.read_image('./data/i1.png')
i2 = vu.read_image('./data/i2.png')
i3 = vu.read_image('./data/i3.png')
i4 = vu.read_image('./data/i4.png')
i5 = vu.read_image('./data/i5.png')
i6 = vu.read_image('./data/i6.png')
stack = vu.build_stack((i1, i2, i3, i4, i5, i6))