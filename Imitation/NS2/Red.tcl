set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf
set tf [open out.tr w]
set windowVsTime [open win w]
set param [open parameters w]
$ns trace-all $tf

proc finish {} {
global ns tf nf
$ns flush-trace
close $tf
close $nf
exec nam out.nam &
exit 0
}

set n2 [$ns node]
set n3 [$ns node]
$ns duplex-link $n2 $n3 1Mb 20ms RED

set NumbSrc 4
set Duration 100

for {set j 1} {$j<=$NumbSrc} {incr j} {
set S($j) [$ns node]
}

set rng [new RNG]
$rng seed 3

set RVstart [new RandomVariable/Uniform]
$RVstart set min_ 0
$RVstart set max_ 10
$RVstart use-rng $rng

for {set i 1} {$i<=$NumbSrc} {incr i} {
set startT($i) [expr [$RVstart value]]
set dly($i) 1
puts $param "startT($i) $startT($i) sec"
}

for {set j 1} {$j<=$NumbSrc} {incr j} {
$ns duplex-link $S($j) $n2 10Mb $dly($j)ms DropTail
$ns queue-limit $S($j) $n2 20
}

$ns queue-limit $n2 $n3 100

for {set j 1} {$j<=$NumbSrc} {incr j} {
set tcp_src($j) [new Agent/TCP/Reno]
$tcp_src($j) set window_ 8000
}

for {set j 1} {$j<=$NumbSrc} {incr j} {
set tcp_snk($j) [new Agent/TCPSink]
}

for {set j 1} {$j<=$NumbSrc} {incr j} {
$ns attach-agent $S($j) $tcp_src($j)
$ns attach-agent $n3 $tcp_snk($j)
$ns connect $tcp_src($j) $tcp_snk($j)
}

for {set j 1} {$j<=$NumbSrc} {incr j} {
set ftp($j) [$tcp_src($j) attach-source FTP]
}

for {set j 1} {$j<=$NumbSrc} {incr j} {
$tcp_src($j) set packetSize_ 512
}

for {set i 1} {$i<=$NumbSrc} {incr i} {
$ns at $startT($i) "$ftp($i) start"
$ns at $Duration "$ftp($i) stop"
}

proc plotWindow {tcpSource file k} {
global ns NumbSrc
set time 0.03
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
if {$k == 1} {
puts -nonewline $file "$now \t $cwnd \t"
} else {
if {$k < $NumbSrc} {
puts -nonewline $file "$cwnd \t" }
}
if {$k == $NumbSrc} {
puts -nonewline $file "$cwnd \n"}
$ns at [expr $now+$time] "plotWindow $tcpSource $file $k"}

for {set j 1} {$j<=$NumbSrc} {incr j} {
$ns at 0.1 "plotWindow $tcp_src($j) $windowVsTime $j"
}
set qfile [$ns monitor-queue $n2 $n3 [open queue.tr w] 0.05]
[$ns link $n2 $n3] queue-sample-timeout;

$ns at [expr $Duration] "finish"
$ns run



