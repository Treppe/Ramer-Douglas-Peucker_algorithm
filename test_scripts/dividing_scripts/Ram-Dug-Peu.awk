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
    print ratio;
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


function douglas(polyline, len, eps):
{
    # Decites a polyline to a similar polyline with fewer points using
    # the Ramer-Doglas-Peuker algorithm.
    # -----------------------------------------------------------------
    #
    # Parameters.
    # -----------
    # polyline : array[index "," x|y]
    #   An ordered list of points coordinates in polyline.
    # len : int
    #   A length of the given polyline / a number of points in list.
    # eps: float
    #   An apoximation coefficient

    # Find the point with the maximum distance
    dist_max = -1;
    idx = -1;

    for (i = 1; i < len; i++){
        dist = shortest_ditance(polyline[i "," 0], polyline[i "," 1],
                                polyline[0 "," 0], polyline[0 "," 1],
                                polyline[len-1 "," 0], poly_line[len-1 "," 0]);
        if (dist > dist_max){
            idx = i;
            dist_max = dist;
        }
    }

    # If max distance is greater than epsilon, recursively simplify
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
}

