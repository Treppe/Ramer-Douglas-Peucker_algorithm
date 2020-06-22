#!/usr/bin/awk -f
BEGIN {
    print ARGV[1];   
    delete ARGV[1];
}
{
    print $0;
}
