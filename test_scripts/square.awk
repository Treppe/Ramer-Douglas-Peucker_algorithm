#!/usr/bin/awk -f
function square(number)
{
    return number * number;
}

{
    print square($1)
}
