#!/bin/bash
douglas_peuker(){
    point_list=$1
    EPS=$2
    first=$3
    last=$4

    # Get first and last x and y value: first_x, first_y, last_x, last_y 
    eval "$(echo "$first" | awk '{print "first_x="$1; print "first_y="$2}')"
    eval "$(echo "$last" | awk '{print "last_x="$1; print "last_y="$2}')"

    max_dist_info="$(echo "$point_list" | \
        awk -v FIRST_X="$first_x" -v FIRST_Y="$first_y" -v LAST_X="$last_x" \
        -v LAST_Y="$last_y" -f ./find_max_dist.awk)"    # DON'T CHANGE VARIABLES NAMES
    eval "$max_dist_info"   # Create variables:
                            # max_NR : a number of the line containing the point the 
                            # furthest from the line segment {(first_x, first_,y), 
                            # (last_x, last_y)}
                            # max_dist : the shortest distance from this point to the 
                            # line segment
                            # max_x : it's x value
                            # max_y : it's y value  

    # Recursive step
	if [[ $max_dist > $EPS ]]; then
	    # Results where max is the last point
	    point_sublist1="$(echo "$point_list" | \
            awk -v max_NR="$max_NR" '{if (NR <= max_NR) {print $0} else {exit}}')" 
        first1="$first"
        last1="$max_x $max_y"
        rec_results1="$(douglas_peuker "$point_sublist1" "$EPS" "$first1" "$last1")"

	    # Results where max is the first point 
    	point_sublist2="$(echo "$point_list" |  \
            awk -v max_NR="$max_NR" \
		    'NR >= max_NR {print $0}')"
        first2="$max_x $max_y"
        last2="$last"
        rec_results2="$(douglas_peuker "$point_sublist2" "$EPS" "$first2" "$last2")"
        
        # Delete max from one of the lists before connecting to avoid duplicates 
        # in result_list
        rec_results2="$(echo "$rec_results2" | awk 'NR>1')"

        # Conectate recursive results in one list
	    result_list="$rec_results1
$rec_results2" 
    # Base case
	else
        result_list="$first
$last"
	fi   

	echo "$result_list"
}


main(){
	EPS="$1"

    # Get the first and the last point in list
    eval "$(echo "$2" | awk 'NR == 1 {print "first=\""$0"\""} NR > 1 {prev = $0} END {print "last=\""prev"\""}')"

    # Filter points in list
    douglas_peuker "$2" "$EPS" "$first" "$last" 
}


# Script execution starts here
polygon="$(cat "$2")"
main  "$1" "$polygon" 


