#!/bin/bash
EPS="$1"
size="$(wc -l < "$2")"
division_point="$(./get_div_point.awk "$2")"  # Number of the line containing coordinates of the furthest point from the point on the line 1
div_NR="$(echo "$division_point" |awk '{print $1}')"
div_x="$(echo "$division_point" | awk '{print $2}')"
div_y="$(echo "$division_point" | awk '{print $3}')"

# The first polyline in polygon
point_list1="$(awk -v div_NR="$div_NR" -v div_x="$div_x" -v div_y="$div_y" \
    'BEGIN {print "SIZE", div_NR} NR == 1 {print "FIRST", $1, $2; print "LAST", div_x, div_y} NR > 1 && NR < div_NR {print NR-1, $0}' "$2")"

# The second polyline in polygon
point_list2="$(awk -v div_NR="$div_NR" -v div_x="$div_x" -v div_y="$div_y" -v size="$size"\
    'BEGIN {print "SIZE", size - div_NR + 1} NR == 1 {print "FIRST", div_x, div_y; print "LAST", $1, $2} NR > div_NR && NR < size{print NR - div_NR, $0}' "$2")"

max_dist_info="$(echo "$point_list1" | ./find_max_dist.awk)"
max_idx="$(echo "$max_dist_info" | awk '{print $1}')"
max_dist="$(echo "$max_dist_info" | awk '{print $2}')"
max_x="$(echo "$max_dist_info" | awk '{print $3}')"
max_y="$(echo "$max_dist_info" | awk '{print $4}')"

if [[ $max_dist > $EPS ]]; then
    # Results where max is the last point
    point_sublist1="$(echo "$point_list1" | \
        awk -v max_x="$max_x" -v max_y="$max_y" -v idx="$max_idx" \
        'NR == 1 {print $1, idx + 1} NR == 3 {print "LAST", max_x, max_y} NR == 2 || NR > 3 && NR < idx + 3 {print $0}')" 

    # Results where max is the first point 
    point_sublist2="$(echo "$point_list1" |  \
        awk -v max_x="$max_x" -v max_y="$max_y" -v idx="$max_idx" \
        'BEGIN {new_idx = 1} NR == 1 {print $1, $2 - idx + 1} NR == 3 {print $0} NR == 2 {print "FIRST", max_x, max_y} NR > idx + 3 {print new_idx, $2, $3; new_idx++}')" 
fi   
