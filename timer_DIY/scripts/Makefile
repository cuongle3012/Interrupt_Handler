TESTNAME	?=

all: clean  build run

build:
	mkdir -p log
	mkdir -p wave
	vlib work
	vmap work work
	vlog -f compile.f

run:
	vsim -l $(TESTNAME).log -voptargs=+acc work.$(TESTNAME) -do "log -r /*;run -all; exit"
	mv $(TESTNAME).log ./log
	cp -rf vsim.wlf wave/$(TESTNAME).wlf	
	ln -sf ./log/$(TESTNAME).log sim.log

reg_grp:
	make all TESTNAME=tdr_write_read_test
	make all TESTNAME=tcr_write_read_test
	make all TESTNAME=tsr_write_read_test
cnt_down:
	make all TESTNAME=clk2_countdown
	make all TESTNAME=clk4_countdown
	make all TESTNAME=clk8_countdown
	make all TESTNAME=clk16_countdown
	make all TESTNAME=clk2_countdown_pause
	make all TESTNAME=clk2_countdown_reset
	make all TESTNAME=clk2_countdown_load
	make all TESTNAME=clk2_countdown_fake
cnt_up:
	make all TESTNAME=clk2_countup
	make all TESTNAME=clk4_countup
	make all TESTNAME=clk8_countup
	make all TESTNAME=clk16_countup
	make all TESTNAME=clk2_countup_pause 
	make all TESTNAME=clk2_countup_reset
	make all TESTNAME=clk2_countup_load
	make all TESTNAME=clk2_countup_fake
	

clean:
	rm -rf work
	rm -rf log
	rm -rf wave
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript
	

dump:
	vsim -gui work.$(TESTNAME)
