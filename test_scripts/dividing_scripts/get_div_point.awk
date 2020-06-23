#!/usr/bin/awk -f 
# Ruturns a number of the line contining the farthest point from the point on the first line and is's coordinates.

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

BEGIN {
    # Initialize starting maximal distance variables for the last point finding
    record_dist = 0;   # This variable will contain a distance to the last point
    last_line = 0;      # An index of the last post in RDP algorithm
}

NR == 1 {
    first_x = $1;
    first_y = $2;
    last_x = $1;    # In case if only 1 point was given
    last_y = $2;
}

NR > 1 {
    # Current point coordinates
    cur_x = $1;
    cur_y = $2;
        
    # Compute a distance between starting point (points_arr[1, x], points_arr[1, y])
    # and current point (cur_x, cur_y) 
    cur_dist = two_points_sqr_distance(cur_x, cur_y, first_x, first_y);
                                    
    # Check if it is the current farthest point from starting point
    if (cur_dist > record_dist){
        record_dist = cur_dist;
        last_line = NR;          # A current point is the current last point
        last_x = cur_x;
        last_y = cur_y;
    }
} 

END {
    print last_line, last_x, last_y;
}


# END {
    # Print the first and the last point
#    print "SIZE", size;
#    print "FIRST", points_arr[0];
#    print "LAST", points_arr[last_idx]; 
    # Print 2 polylines's points betwwen FIRST and LAST point
#    print_idx = 1;
#    new_polyline_flag = 1;
#    for (i = 1; i < size; i++) {
#        if (i != last_idx){
#            print print_idx, points_arr[i];
#        }
#        else {
#            print "NEW POLYLINE COORDS";
#            new_polyline_flag = 0;
#            print_idx = 0;
#        }
#
#        print_idx++;       
#    }
# }


