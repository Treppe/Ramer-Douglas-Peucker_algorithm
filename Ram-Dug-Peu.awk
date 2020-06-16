#!/usr/bin/awk -f
# The Ramer-Douglas-Peuker algorithm.
# Decimates a curve composed of line segments to a similar curve with fewer points.

# Create an array of points
{
    for (dummy = 0; dummy <= 1; dummy++){
        dummy == 0 ? points_arr[NR, x] = $1 : points_arr[NR, y] = $2; 
        }
    print points_arr[NR, x], points_arr[NR, y]
}

