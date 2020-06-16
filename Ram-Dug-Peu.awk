#!/usr/bin/awk -f
# The Ramer-Douglas-Peuker algorithm.
# Decimates a curve composed of line segments to a similar curve with fewer points.

# Essential user-defined functions
function square(number)
{
    return number * number;
}

function two_points_distance(x1, y1, x2, y2)
{
    # Returns an euqlidean distance between 2 given points
    x_sqr = square(x1 - x2);
    y_sqr = square(y1 - y2);
    return sqrt(x_sqr + y_sqr);
}

function point_line_segment_distance(pt_x, pt_y, ln_x1, ln_y1, ln_x2, ln_y2)
{
    # Returns a distance of point from line segment in 2D space 
    return 0;
     
}

function shortest_distance(pt_x, pt_y, ln_x1, ln_y1, ln_x2, ln_y2) 
{
    return 0;
}

# Script execution starts here.
# Create an array of points
BEGIN {
    # Initialize starting maximal distance variables for the last point finding
    record_dist = -1;   # This variable will contain a distance to the last point
    last_idx = -1;      # An index of the last post in RDP algorithm
}

{
    # Current poin coordinates
    # Store a point in a points array
    points_arr[NR-1 "," 0] = $1;
    points_arr[NR-1 "," 1] = $2; 
    print points_arr[NR-1 "," 0], points_arr[NR-1 "," 1]; 

    cur_x = $1;
    cur_y = $2;
    # Compute a distance between starting point (points_arr[1, x], points_arr[1, y])
    # and current point (cur_x, cur_y) 
    cur_dist = two_points_distance(cur_x, cur_y, 
                                   points_arr[0 "," 0], points_arr[0 "," 1])
    
    # Check if it is the current farthest point from starting point
    if (cur_dist > record_dist){
        record_dist = cur_dist;
        last_idx = NR-1;          # A current point is the current last point
    }
}

END {
    print "(", points_arr[0 "," 0], ",", points_arr[0 "," 1], ") (", points_arr[last_idx "," 0], ",",  points_arr[last_idx "," 1], ")";
}
