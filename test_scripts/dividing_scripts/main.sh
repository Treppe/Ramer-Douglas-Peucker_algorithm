#!/bin/bash
EPS="$1"
division_point="$(./get_div_point.awk "$2")"  # Number of the line containing coordinates of the furthest point from the point on the line 1
div_NR="$(echo "$division_point" |awk '{print $1; exit}')"
div_x="$(echo "$division_point" | awk '{print $2; exit}')"
div_y="$(echo "$division_point" | awk '{print $3; exit}')"
size="$(echo "$division_point" | awk '{print $4; exit}')"

# The first polyline in polygon
point_list1="$(awk -v div_NR="$div_NR" -v div_x="$div_x" -v div_y="$div_y" \
    'BEGIN {print "SIZE", div_NR} {if (NR > div_NR){exit} else if (NR > 1 && NR <= div_NR) {print $0} else if (NR == 1) {print "FIRST", $0; print "LAST", div_x, div_y; print $0}}' "$2")"

# The second polyline in polygon
point_list2="$(awk -v div_NR="$div_NR" -v div_x="$div_x" -v div_y="$div_y" -v size="$size"\
    'BEGIN {print "SIZE", size - div_NR + 1} {if (NR > div_NR && NR < size) {print $0} else if (NR == 1) {print "FIRST", div_x, div_y; print "LAST", $1, $2; print div_x, div_y; last_xy = $0} else {next}} END{print last_xy}' "$2")"

max_dist_info="$(echo "$point_list1" | ./find_max_dist.awk)"
max_idx="$(echo "$max_dist_info" | awk '{print $1; exit}')"
max_dist="$(echo "$max_dist_info" | awk '{print $2; exit}')"
max_x="$(echo "$max_dist_info" | awk '{print $3; exit}')"
max_y="$(echo "$max_dist_info" | awk '{print $4; exit}')"

if [[ $max_dist > $EPS ]]; then
    # Results where max is the last point
    point_sublist1="$(echo "$point_list1" | \
        awk -v max_x="$max_x" -v max_y="$max_y" -v idx="$max_idx" \
        'NR > 3 {if (NR < idx) {print $0} else {exit}}')" 
    rec_results1="$(echo "$point_sublist1" | ./main.sh "$EPS")" 

    # Results where max is the first point 
    point_sublist2="$(echo "$point_list1" |  \
        awk -v max_x="$max_x" -v max_y="$max_y" -v idx="$max_idx" \
        'NR >= idx {print $0}')"
    rec_results2="$(echo "$point_sublist2" | ./main.sh "$EPS")"
    echo "$rec_results1"  
    echo "$rec_results2"
fi   



