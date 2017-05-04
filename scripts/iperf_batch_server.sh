#!/bin/bash
echo "Bandwidth Jitter PL/Total PLR" >> log
# max send rate
max=15
allInfo=""
for (( i=0; i <= $max; i=i+5 ))
do
    allInfo=""
    speed="$i""Mbits/sec"
    
    echo "======================================================================"
    echo $speed

    echo "======================================================================" >> log
    echo $speed >> log
    
    for (( j=0; j <= 2; ++j ))
    do
    # TODO the test interval shall be larger in real experiments
    # also the ip addr should be changed
    # and the time
        result="$(iperf -u -c 10.0.0.3 -b ${speed}mbit -t 5s | sed -n 11p)"
        echo "Raw Results:"
        echo $result
        
        bandwidth="$(echo $result | cut -d' ' -f8 )"
        jitter="$(echo $result | cut -d' ' -f10)"
        # packet loss
        pl="$(echo $result | cut -d' ' -f12)"
        total="$(echo $result | cut -d' ' -f13)"
        plr="$(echo $result | cut -d' ' -f14)"
        tmpAllInfo="$bandwidth ""$jitter ""$pl""$total ""$plr"
        
        allInfo="${tmpAllInfo}\n${allInfo}"
        #echo "AllInfo:"
        #echo -e "$allInfo"
        echo "Saved Results:"
        echo $tmpAllInfo
    done
    echo -e "$allInfo" >> log
    allInfo=""
    echo "All Info:"
    echo $allInfo
done
