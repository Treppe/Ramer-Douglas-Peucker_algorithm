#!/usr/bin/awk -f
# The Ramer-Douglas-Peuker algorithm.
# Decimates a curve composed of line segments to a similar curve with fewer points.

# Essential user-defined functions
function square(number)
{
    return number * number;
}


function two_points_sqr_distance(x1, y1, x2, y2)
{
    # Returns an euqlidean distance between 2 given points
    x_sqr = square(x1 - x2);
    y_sqr = square(y1 - y2);
    return x_sqr + y_sqr;
}


function shortest_distance(pt_x, pt_y, ln_x1, ln_y1, ln_x2, ln_y2, len_sq) 
{
    # Returns the shortest distance square from a point (pt_x, pt_y) to a
    # line segment with 2 edge points (ln_x1, ln_y1) and (ln_x2, ln_y2)
    # and with a square length "len_sq"

    # Finding a projection of point on a line intersecting line segment edges
    # The ratio in which projection divide a given line segment
    ratio = ((pt_x - ln_x1) * (ln_x2 - ln_x1) + (pt_y - ln_y1)*(ln_y2 - ln_y1)) / len_sq;
    if (ratio <= 0){
        # The shortest distance is the distance between the point and the edge point 
        # (ln_x1, ln_y1)
        return two_points_sqr_distance(pt_x, pt_y, ln_x1, ln_y1);
    }
    else if (ratio >= 1){
        # The shortest distance is the distance between the point and the edge point 
        # (ln_x2, ln_y2)
        return two_points_sqr_distance(pt_x, pt_y, ln_x2, ln_y2);
    }
    else {
        # The shortest distance is the distance between the point and it's projection 
        # on the line segment
        prj_x = ln_x1 + ratio * (ln_x2 - ln_x1);
        prj_y = ln_y1 + ratio * (ln_y2 - ln_y1);
        return two_points_sqr_distance(pt_x, pt_y, prj_x, prj_y);
    }
}




# Script execution starts here
BEGIN {
    # Store a constant parameter epsilon
    EPS = ARGV[1];
    delete ARGV[1];

    max_dist = -1;
    max_idx = -1;
}


NR == 2 {
    first_x = $2;
    first_y = $3;
}


NR == 3 {
    last_x = $2;
    last_y = $3;

    len_sq = two_points_sqr_distance(first_x, first_y, last_x, last_y);
}

NR > 3 {
    # Find the point with the maximum distance in first time
    idx = NR;
    x = $1;
    y = $2;

    dist = shortest_distance(x, y, first_x, first_y, last_x, last_y, len_sq);

    if (dist > max_dist) {
        max_idx = idx;
        max_dist = dist;
    }
    
    # Put point into array
    points_arr[idx "," 0] = x;
    points_arr[idx "," 1] = y;
}


END { 
    print max_idx, max_dist, points_arr[max_idx "," 0], points_arr[max_idx "," 1]; 
}
