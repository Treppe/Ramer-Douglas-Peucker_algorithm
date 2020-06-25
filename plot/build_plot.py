#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Builds plots from given sets of points
"""
import sys

import numpy as np
from matplotlib import pyplot
from shapely.geometry.polygon import LinearRing

def get_figure(file_path):
    """
        Reads a sets of points from the files in given paths and returns a 
        list of points arrays
    """
    assert isinstance(file_path, str), "file_path must be string."

    file = open(file_path, "r")
    points = []
    for line in file:
        row = line.split()
        points.append([float(row[0]), float(row[1])])

    assert len(np.shape(points)) == 2 and np.shape(points)[1] == 2, \
           "Set of points must be given as 2*n shaped array."
           
    return np.array(points)
def build_plot(points_arr):
    """
        Builds a plot of given ring shape
    """


    
def main():
    path_lst = sys.argv[1:]
    print (path_lst)
    for path in path_lst:
        figure = get_figure(str(path))
        ring = LinearRing(figure)
        x, y = ring.xy
        
        fig = pyplot.figure(1, figsize=(5, 5), dpi=90)
        polygon = fig.add_subplot(111)
        polygon.plot(x, y, marker='o')
        
    pyplot.show(block=True)

        
main()
