#!/usr/bin/awk -f
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

{
    print two_points_dist($1, $2, $3, $4);
}
