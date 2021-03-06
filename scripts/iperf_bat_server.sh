#!/bin/sh
# for server
rm -f log
echo "# TimeInterval TotalBytes Bandwidth Jitter PL/Total PLR" >> log
i=$(($2))
time=$(($3))
# iteration of transmitting rate should be 0 to 60 Mbps
while [ $(($i)) -le 65 ];
do
    speed="$i""Mbits/sec"

    echo "======================================================================"
    echo $speed

    echo "======================================================================" >> log
    echo $speed >> log

    j=$((1))
    # here we can repetition times of redundant experiments
    while [ $(($j)) -le 5 ];
    do
    	# TODO the test interval shall be larger in real experiments, e.g., 30s
    	# TODO the ip addr should be changed and also before each test, restart the iperf
	# server by control+c and rerun iperf -u -s
	# TODO be sure to replace by using the exact path to iperf when running on Android
	# for example, /data/local/tmp/iperf instead of iperf
        #iperf -u -c 10.0.0.21 -b ${speed}mbit -t 30s | sed -n 11p
	# TODO if use server, we should use 11p instead of 12p
        # result="$(/data/local/tmp/iperf -u -c $1 -b ${speed}mbit -t 30s | sed -n 12p)"
	# TODO for server
	result="$(iperf -u -c $1 -b ${speed}mbit -t ${time}s | grep " ms")"
	# sleep until the last UDP connection timed out
	# TODO if use server, sleep 2s, else if use android, sleep 2
	sleep 2s
	echo "Raw Results:"
        echo $result
        # TODO change the index -f[x] to -f[7-13] if using experiment time over 10
	# otherwise use -f[8-14]
        #bandwidth="$(echo $result | cut -d' ' -f7 )"
        #jitter="$(echo $result | cut -d' ' -f9)"
        ## packet loss
        #pl="$(echo $result | cut -d' ' -f11)"
        #total="$(echo $result | cut -d' ' -f12)"
        #plr="$(echo $result | cut -d' ' -f13)"
        #tmpAllInfo="$bandwidth ""$jitter ""$pl""$total ""$plr"
        echo "${result}" >> log
        #allInfo="${tmpAllInfo}\n${allInfo}"
        #echo "AllInfo:"
        #echo -e "$allInfo"

	j=$(($j + 1))
    done

    #echo -e "$allInfo" >> log
    #allInfo=""
    #echo "All Info:"
    #echo $allInfo

    i=$(($i + 5))
done
