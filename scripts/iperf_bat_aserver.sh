#!/bin/bash
# for android
echo "Bandwidth Jitter PL/Total PLR" >> log
# 1st param: the ip of iperf server
# 2nd param: starting transferring rate
i=$(($2))
# 3rd param: runtime of each experiment
time=$(($3))
# TODO iteration of transmitting rate should be 0 to 60 Mbps
while [ $(($i)) -le 65 ];
do
    speed="$i""Mbits/sec"

    echo "======================================================================"
    echo $speed

    echo "======================================================================" >> log
    echo $speed >> log

    j=$((1))
    # TODO here we can repetition times of redundant experiments
    while [ $(($j)) -le 5 ];
    do
    	# TODO the test interval shall be larger in real experiments, e.g., 30s
	# TODO be sure to replace by using the exact path to iperf when running on Android
	# for example, /data/local/tmp/iperf instead of iperf
	# TODO if use server, we should use 11p instead of 12p
        result="$(iperf -u -c $1 -b ${speed}mbit -t ${time}s | sed -n 11p)"
	# sleep until the last UDP connection timed out
	sleep 2
	echo "Raw Results:"
        echo $result
        # TODO change the index -f[x] to -f[7-13] if using experiment time over 10
	# otherwise use -f[8-14]
        bandwidth="$(echo $result | cut -d' ' -f7 )"
        jitter="$(echo $result | cut -d' ' -f9)"
        # packet loss
        pl="$(echo $result | cut -d' ' -f11)"
        total="$(echo $result | cut -d' ' -f12)"
        plr="$(echo $result | cut -d' ' -f13)"
        tmpAllInfo="$bandwidth ""$jitter ""$pl""$total ""$plr"
        echo "${tmpAllInfo}" >> log
        #allInfo="${tmpAllInfo}\n${allInfo}"
        #echo "AllInfo:"
        #echo -e "$allInfo"
        echo "Saved Results:"
        echo $tmpAllInfo

	j=$(($j + 1))
    done

    #echo -e "$allInfo" >> log
    #allInfo=""
    #echo "All Info:"
    #echo $allInfo

    i=$(($i + 5))
done
