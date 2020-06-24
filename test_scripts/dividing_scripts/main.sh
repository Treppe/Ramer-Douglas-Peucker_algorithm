#!/bin/bash
douglas_perker(){
    point_list=$1
    EPS=$2
    size=$3
    first=$4
    last=$5

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
        size1="$max_NR"
        first1="$(echo "$point_sublist1" | awk 'NR == 1 {print $0; exit}')"
        last1="$max_x $max_y"

   # rec_results1="$(douglas_perker "$EPS" "$point_sublist1")"

	    # Results where max is the first point 
	point_sublist2="$(echo "$point_list" |  \
		awk -v max_x="$max_x" -v max_y="$max_y" -v idx="$max_NR" \
		'NR >= idx {print $0} NR == 1 {size = $2 - idx + 4} NR == 3 {print "SIZE", size; print "FIRST", max_x, max_y; print "LAST", $2, $3}')"

        # rec_results2="$(douglas_perker "$EPS" "$point_sublist2")"
	    # result_list="$rec_results1
# $rec_results2"
	else
        result_list="$(echo "$point_list" | awk '{if (NR > 3) {exit} else if (NR == 1) {print "SIZE", 2} else if (NR == 2) {print $0; first_x = $2; first_y = $3} else if (NR == 3) {print $0; print first_x, first_y; print $2, $3}}')"
	fi   
#	echo "$result_list"
}

main(){
	EPS="$1"
	division_point="$(echo "$2" | ./get_div_point.awk)"  # Number of the line containing coordinates of the furthest point from the point on the line 1
	div_NR="$(echo "$division_point" |awk '{print $1; exit}')"
	div_x="$(echo "$division_point" | awk '{print $2; exit}')"
	div_y="$(echo "$division_point" | awk '{print $3; exit}')"
	size="$(echo "$division_point" | awk '{print $4; exit}')"

	# The first polyline in polygon
	point_list1="$(echo "$2" | awk -v div_NR="$div_NR" \
	    '{if (NR <= div_NR) {print $0} else {exit}}')"
    size1="$div_NR"
    first1="$(echo "$2" | awk 'NR == 1 {print $0; exit}')"
    last1="$div_x $div_y"

	# The second polyline in polygon
	point_list2="$(echo "$2" | awk -v div_NR="$div_NR" -v div_x="$div_x" -v div_y="$div_y" -v size="$size"\
        'NR >= div_NR {print $0} NR == 1 {last_xy = $0} END {print last_xy}')" 
    size2=$(( size - div_NR + 2))
    first2="$div_x $div_y"
    last2="$(echo "$2" | awk 'NR == 1 {print $0; exit}')"

    douglas_perker "$point_list1" "$EPS" "$size1" "$first1" "$last1"
}

polygon="$(cat "$2")"
main  "$1" "$polygon" 


