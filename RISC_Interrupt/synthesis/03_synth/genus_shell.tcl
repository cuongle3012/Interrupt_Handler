
##################################################
#
#Khai Pham 
#HCMUT LAB 203 
#
##################################################
#file setup variables#
set top_module synth_wrapper
#set_db auto_ungroup none
##################################################
#Libraries setup#
set_db library [list /opt/PDKs/skywater130/timing/sky130_fd_sc_hd__tt_025C_1v80.lib ]
set_db lef_library [ list /opt/PDKs/skywater130/tech/sky130_fd_sc_hd__nom.tlef ]
##################################################
#HDL files read#
read_hdl -sv -f 00_src/flist.f
##################################################
elaborate
set_top_module ${top_module}
write_hdl > 03_synth/${top_module}_elab.v
check_design -all
##################################################
#Timing constraint variables#
set FREQ_GHz 1.0
set FREQ [ expr ${FREQ_GHz} * 1000000000.0 ]
set PERIOD_tmp [ expr (1.0/${FREQ}) ]
set PERIOD [ expr ${PERIOD_tmp} * 1000000000000.0 ]
puts "Clock Period = ${PERIOD} ps"
set IN_DLY [ expr $PERIOD/2.0 ]
set OUT_DLY [ expr $PERIOD/2.0 ]
set UNCER [expr ${PERIOD}/100000.0]
puts "Clock Uncertainty = ${UNCER} ns"
set TRANS 1.5
puts "max transition = ${TRANS} ns"
##################################################
#set constraint for clock and input with output#
set clock [define_clock -period $PERIOD -name clk [clock_ports] ]
set_dont_touch_network [get_clocks clk]
set_clock_uncertainty ${UNCER} -setup -hold clk
set_max_transition ${TRANS} [get_design ${top_module}] 
external_delay -clock clk -input $IN_DLY  -name delay_in [all_inputs]
external_delay -clock clk -output $OUT_DLY -name delay_out [all_outputs]
##################################################
#Synthesize RTL code to generic#
syn_generic
write_hdl > 03_synth/${top_module}_generic.v
#Mapping technology to the generic#
syn_map
write_hdl > 03_synth/${top_module}_tech_map.v
#remove assignment statement 
remove_assigns_without_optimization -verbose
#Optimizing the mapped technology netlist#
syn_opt  

report timing -lint
##################################################
#design post-synthesis export#
#Export the netlist 
write_hdl > 03_synth/${top_module}_gate.v
#Export the standard delay format of the synthesized design #
write_sdf -edges check_edge -setuphold "split" -recrem split > 03_synth/${top_module}.sdf

##################################################
#Reports export#
report timing -max_paths 10 > 04_reports/${top_module}.timing.rpt
report hierarchy > 04_reports/${top_module}.hier.rpt
report gates > 04_reports/${top_module}.gates.rpt
report datapath > 04_reports/${top_module}.datapath.rpt
report qor > 04_reports/${top_module}.qor.rpt
report area > 04_reports/${top_module}.area.rpt
report power > 04_reports/${top_module}.power.rpt
##################################################
#Open genus GUI 
gui_show

