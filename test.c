# Open input file
set fp [open data.txt r]

# Arrays to accumulate total sinks and total latency per master clock
array set sum_sinks   {}
array set sum_latency {}

# Store one port per master clock (only the final value will be used)
array set master_port {}

# Read file line by line
while {[gets $fp line] >= 0} {

    # Skip empty lines
    if {$line eq ""} { continue }

    # note: column index starts from 0
    set clock        [lindex $line 0]
    set is_generated [lindex $line 2]
    set master_clock [lindex $line 3]
    set port         [lindex $line 4]
    set sinks        [lindex $line 5]
    set latency      [lindex $line 6]

    # Process only generated clocks
    if {$is_generated eq "TRUE"} {

        # Initialize accumulation for this master clock
        if {![info exists sum_sinks($master_clock)]} {
            set sum_sinks($master_clock)   0
            set sum_latency($master_clock) 0
            set master_port($master_clock) $port
        }

        # Accumulate sinks and latency
        incr sum_sinks($master_clock)   $sinks
        incr sum_latency($master_clock) $latency
    }
}

# Close input file
close $fp

# Generate final output
# Only one line will be printed for each master clock
foreach master_clock [array names sum_sinks] {

    set total_sinks   $sum_sinks($master_clock)
    set total_latency $sum_latency($master_clock)

    # Avoid division by zero
    if {$total_sinks == 0} { continue }

    # Calculate source latency
    set result [expr {double($total_latency) / $total_sinks}]

    # Format result to 4 decimal places
    set result_fmt [format "%.4f" $result]

    set port $master_port($master_clock)

    # Print final command
    puts "set_clock_latency -source $result_fmt \[get_port $port\] -clock $master_clock"
}
