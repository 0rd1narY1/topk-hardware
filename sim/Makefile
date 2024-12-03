SRC = . \
	  ../src/*.sv \
	  ./testbench.sv 

VCS_OUTPUT = csrc DVEfiles inter.vpd simv.daidir ucli.key simv

#MODELSIM_OUTPUT = work comp.log sim.log sim.scl sim.tcl vsim.wlf
#modelsim: create_lib compile sim
#create_lib:
#	vlib work
#compile:
#	#vlog -l comp.log -v ../src/cpu_soc.v ../src/cpu.v ../src/ifu/ifu.v ../src/ctrl_unit/ctrlu.v ../src/decoder/decoder.v ../src/regfile/regfile.v testbench.v
#	vlog -l comp.log -v $(SRC)
#sim:
#	vsim -l sim.log -voptargs=+acc work.tb -do "log -r *;run -all"

# code coverage command
CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name simv
CM_DIR = -cm_dir ./covdir.vdb

VCS = vcs -R -full64 -lca -kdb -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed -debug_access+all +v2k -sverilog -timescale=1ns/1ps \
	  +acc +vpi \
	  +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	  $(CM) $(CM_NAME) $(CM_DIR)

SIMV = ./simv -l vcs.log -gui=verdi

all: comp sim cov
comp:
	$(VCS) +incdir+$(SRC)
sim:
	$(SIMV)
cov:
	dve -full64 -covdir *.vdb &
clean:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* *.log inter* novas* DVEfiles verdiLog vdCovLog covdir.vdb cov_exclusion transcript _vcs_cp_internal.dat.ord1nary.19779
