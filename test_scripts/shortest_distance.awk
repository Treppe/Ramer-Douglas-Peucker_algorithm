#!/usr/bin/awk -f
function square(number)
{
    return number * number;
}

function two_points_sqr_distance(x1, y1, x2, y2)
{
    # Returns an euqlidean distance square between 2 given points
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
        print 1;
        # The shortest distance is the distance between the point and the edge point 
        # (ln_x1, ln_y1)
        return two_points_sqr_distance(pt_x, pt_y, ln_x1, ln_y1);
    }
    else if (ratio >= 1){
        print 2;
        # The shortest distance is the distance between the point and the edge point 
        # (ln_x2, ln_y2)
        return two_points_sqr_distance(pt_x, pt_y, ln_x2, ln_y2);
    }
    else {
        print 3;
        # The shortest distance is the distance between the point and it's projection 
        # on the line segment
        prj_x = ln_x1 + ratio * (ln_x2 - ln_x1);
        prj_y = ln_y1 + ratio * (ln_y2 - ln_y1);
        return two_points_sqr_distance(pt_x, pt_y, prj_x, prj_y);
    }
}

# Script execution starts here
{
    print shortest_distance($1, $2, $3, $4, $5, $6, $7);
}
