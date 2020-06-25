#!/bin/bash
douglas_perker(){
    point_list=$1
    EPS=$2
    first=$3
    last=$4

    first_x="$(echo "$first" | awk '{print $1; exit}')"
    first_y="$(echo "$first" | awk '{print $2; exit}')"
    last_x="$(echo "$last" | awk '{print $1; exit}')"
    last_y="$(echo "$last" | awk '{print $2; exit}')"

    max_dist_info="$(echo "$point_list" | \
        awk -v FIRST_X="$first_x" -v FIRST_Y="$first_y" -v LAST_X="$last_x" -v LAST_Y="$last_y" -f ./find_max_dist.awk)" # DON'T CHANGE VARIABLES NAMES
	max_NR="$(echo "$max_dist_info" | awk '{print $1; exit}')"
	max_dist="$(echo "$max_dist_info" | awk '{print $2; exit}')"
	max_x="$(echo "$max_dist_info" | awk '{print $3; exit}')"
	max_y="$(echo "$max_dist_info" | awk '{print $4; exit}')"

	if [[ $max_dist > $EPS ]]; then
	    # Results where max is the last point
	    point_sublist1="$(echo "$point_list" | \
            awk -v max_NR="$max_NR" '{if (NR <= max_NR) {print $0} else {exit}}')" 
        first1="$first"
        last1="$max_x $max_y"
        rec_results1="$(douglas_perker "$point_sublist1" "$EPS" "$first1" "$last1")"

	    # Results where max is the first point 
    	point_sublist2="$(echo "$point_list" |  \
            awk -v max_NR="$max_NR" \
		    'NR >= max_NR {print $0}')"
        first2="$max_x $max_y"
        last2="$last"
        rec_results2="$(douglas_perker "$point_sublist2" "$EPS" "$first2" "$last2")"
        
        # Delete max from one of the lists before connecting to avoid duplicates in result_list
        rec_results2="$(echo "$rec_results2" | awk 'NR>1')"

        # Conectate recursive results in one list
	    result_list="$rec_results1
$rec_results2"
	else
        result_list="$first
$last"
	fi   
	echo "$result_list"
}

main(){
	EPS="$1"
	division_point="$(echo "$2" | ./get_div_point.awk)"  # Number of the line containing coordinates of the furthest point from the point on the line 1
	div_NR="$(echo "$division_point" |awk '{print $1; exit}')"
	div_x="$(echo "$division_point" | awk '{print $2; exit}')"
	div_y="$(echo "$division_point" | awk '{print $3; exit}')"

	# The first polyline in polygon
	point_list1="$(echo "$2" | awk -v div_NR="$div_NR" \
	    '{if (NR <= div_NR) {print $0} else {exit}}')"
    first1="$(echo "$2" | awk 'NR == 1 {print $0; exit}')"
    last1="$div_x $div_y"

	# The second polyline in polygon
	point_list2="$(echo "$2" | awk -v div_NR="$div_NR" \
        'NR >= div_NR {print $0} NR == 1 {last_xy = $0} END {print last_xy}')" 
    first2="$div_x $div_y"
    last2="$(echo "$2" | awk 'NR == 1 {print $0; exit}')"

    results1="$(douglas_perker "$point_list1" "$EPS" "$first1" "$last1")"
    results2="$(douglas_perker "$point_list2" "$EPS" "$first2" "$last2" | awk 'NR > 2 { print prev } { prev = $0 }')"
    echo "$results1
$results2"
}

polygon="$(cat "$2")"
main  "$1" "$polygon" 


