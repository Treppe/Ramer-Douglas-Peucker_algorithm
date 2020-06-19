#!/usr/bin/awk -f 
# Divide given polygon in two polylines

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
    record_dist = -1;   # This variable will contain a distance to the last point
    last_idx = -1;      # An index of the last post in RDP algorithm
    size = 0;
}



{
    idx = NR-1;
    # Get the first point for poilyline
    if (idx == 0){
        first_x = $1;
        first_y = $2;
    }
    else {
        # Current point coordinates
        cur_x = $1;
        cur_y = $2;
        
        # Compute a distance between starting point (points_arr[1, x], points_arr[1, y])
        # and current point (cur_x, cur_y) 
        cur_dist = two_points_sqr_distance(cur_x, cur_y, first_x, first_y);
                                    
        # Check if it is the current farthest point from starting point
        if (cur_dist > record_dist){
            record_dist = cur_dist;
            last_idx = idx;          # A current point is the current last point
        }
    } 
    # Store point's info on array
    points_arr[idx] = $0;

    size++;
}

END {
    print_idx = 0;
    new_polyline_flag = 1;
    for (i = 0; i < size; i++) {
        if (i != last_idx){
            print print_idx, points_arr[i];
        }
        else {
            print "LAST", points_arr[i];
            print "NEW POLYLINE COORDS";
            new_polyline_flag = 0;
            print_idx = 0;
        }

        print_idx++;
        
    }
}


