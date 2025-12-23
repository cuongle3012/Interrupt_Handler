set fp [open data.txt r]

while {[gets $fp line] >= 0} {

    if {$line eq ""} { continue }

    set is_generated [lindex $line 2]
    set master_clock [lindex $line 3]
    set port         [lindex $line 4]
    set sinks        [lindex $line 5]   ;# integer
    set latency      [lindex $line 6]   ;# float (e.g. 1.223)

    if {$is_generated eq "TRUE"} {

        # Initialize when first seen
        if {![info exists sum_sinks($master_clock)]} {
            set sum_sinks($master_clock)   0
            set sum_latency($master_clock) 0.0
            set master_port($master_clock) $port
        }

        # Integer accumulation
        incr sum_sinks($master_clock) $sinks

        # Floating-point accumulation
        set sum_latency($master_clock) \
            [expr {$sum_latency($master_clock) + $latency}]
    }
}

close $fp

foreach master_clock [array names sum_sinks] {

    set total_sinks   $sum_sinks($master_clock)
    set total_latency $sum_latency($master_clock)

    if {$total_sinks == 0} { continue }

    set result [expr {$total_latency / double($total_sinks)}]
    set result_fmt [format "%.4f" $result]

    set port $master_port($master_clock)

    puts "set_clock_latency -source $result_fmt \[get_port $port\] -clock $master_clock"
}
