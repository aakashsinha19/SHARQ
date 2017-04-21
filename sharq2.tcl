# create a Simulator object
set ns [new Simulator]
set tracefile [open out.tr w]

# define different colours for data flows
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

# define trace file open.nam
$ns trace-all $tracefile
set nf [open out.nam w]
$ns namtrace-all $nf

# defining finish procedure
proc finish {} {
    global ns tracefile nf
    $ns flush-trace
    close $nf
    close $tracefile
    exec nam out.nam &
    exit 0
}

# creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# creating links between nodes
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail
$ns duplex-link $n1 $n3 1.7Mb 20ms DropTail


# setting queing limit
$ns queue-limit $n1 $n3 10

# giving node positions for nam
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n2 $n3 orient right-up


# monitoring the queue for link n2 and n3
$ns duplex-link-op $n1 $n3 queuePos 0.5




#setting a tcp connection
set tcp1 [new Agent/TCP]
set tcp2 [new Agent/TCP]
$tcp1 set class_ 1
$tcp2 set class_ 2

$ns attach-agent $n0 $tcp1
$ns attach-agent $n0 $tcp2
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1
$ns attach-agent $n3 $sink2
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$tcp1 set fid_ 1
$tcp2 set fid_ 2

#Set up a ftp over tcp connection
set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2
$ftp1 set type_ FTP
$ftp2 set type_ FTP

#Set up a UDP connection
set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]
$ns attach-agent $n1 $udp1
$ns attach-agent $n2 $udp2
set null1 [new Agent/Null]
set null2 [new Agent/Null]
$ns attach-agent $n3 $null1
$ns attach-agent $n3 $null2
$ns connect $udp1 $null1
$ns connect $udp2 $null2
$udp1 set fid_ 1
$udp2 set fid_ 2

#Set up a cbr over a udp connection
set cbr1 [new Application/Traffic/CBR]
set cbr2 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr2 attach-agent $udp2

$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 1mb
$cbr1 set random_ false

$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb
$cbr2 set random_ false

#schedule events for cbr and ftp agents
#$ns at 0.1 "$cbr1 start"
#$ns at 0.1 "$cbr2 start"
$ns at 0.5 "$ns connect $udp2 $null2"
$ns at 0.5 "$ftp1 start"
$ns at 0.5 "$ftp2 start"
$ns at 4.0 "$ftp1 stop"
$ns at 4.0 "$ftp2 stop"
#$ns at 4.5 "$cbr1 stop"
#$ns at 4.5 "$cbr2 stop"

#calling finish proc
$ns at 5.0 "finish"

$ns run