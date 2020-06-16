#!/usr/bin/awk -f
# The Ramer-Douglas-Peuker algorithm.
# Decimates a curve composed of line segments to a similar curve with fewer points.

# Essential user-defined functions
function square(number)
{
    return number * number;
}

function two_points_dist(x1, y1, x2, y2)
{
    # Returns an euqlidean distance between 2 given points
    x_sqr = square(x1 - x2);
    y_sqr = square(y1 - y2);
    return sqrt(x_sqr + y_sqr);
}

fucntion point_line_segment_distance(pt_x, pt_y, ln_x1, ln_y1, ln_x2, ln_y2)
{
    # Returns a distance of point from line segment in 2D space 
     
}

function shortest_distance(pt_x, pt_y, ln_x1, ln_y1, ln_x2, ln_y2) 
{

}

# Script execution starts here.
# Create an array of points
{
    for (dummy = 0; dummy <= 1; dummy++){
        dummy == 0 ? points_arr[NR, x] = $1 : points_arr[NR, y] = $2; 
        }
}

