#create a Simulator object
set ns [new Simulator]
set tracefile [open out.tr w]

# define different colours for data flows
$ns color 1 Blue
$ns color 2 Red

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
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

# setting queing limit
$ns queue-limit $n2 $n3 10

# giving node positions for nam
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

# monitoring the queue for link n2 and n3
$ns duplex-link-op $n2 $n3 queuePos 0.5

#setting a tcp connection
set tcp [new Agent/TCP]
$tcp set class_ 2

$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#Set up a ftp over tcp connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Set up a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null
$udp set fid_ 2

#Set up a cbr over a udp connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

#schedule events for cbr and ftp agents
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"

#calling finish proc
$ns at 5.0 "finish"

$ns run


$ns run




















