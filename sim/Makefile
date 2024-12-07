SRC = . ../src/sorter_pkg.sv \
	  ../src/sorter_top.sv \
	  ../src/cas.sv \
	  ../src/bitonic_new/*.sv \
	  ./testbench.sv 

VCS_OUTPUT = csrc DVEfiles inter.vpd simv.daidir ucli.key simv

#MODELSIM_OUTPUT = work comp.log sim.log sim.scl sim.tcl vsim.wlf
#run: create_lib compile sim
#create_lib:
#	vlib work
#compile:
#	vlog -work work $(SRC)
#sim:
#	vsim -l sim.log -voptargs=+acc work.tb -do "log -r *;run -all"

# code coverage command
CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name simv
CM_DIR = -cm_dir ./covdir.vdb

VCS = vcs -R -full64 -lca -kdb -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,--no-as-needed -debug_all +v2k -sverilog -timescale=1ns/1ps \
	  +vpi \
	  -P ${VERDI_HOME}/share/PLI/VCS/LINUXAMD64/novas.tab ${VERDI_HOME}/share/PLI/VCS/LINUXAMD64/pli.a \
	  +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	  $(CM) $(CM_NAME) $(CM_DIR)

SIMV = ./simv

all: comp vcs
comp:
	$(VCS) +incdir+$(SRC)
vcs:
	$(SIMV)
verdi:
	verdi -ssf test.fsdb 
cov:
	dve -full64 -covdir *.vdb &
clean:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* *.log \
		   inter* novas* DVEfiles verdiLog vdCovLog covdir.vdb cov_exclusion \
		   transcript *.fsdb *.vpd


