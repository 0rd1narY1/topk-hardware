debImport "-ssf" "test.fsdb"
debLoadSimResult /home/ord1nary/study/Projects/sim/test.fsdb
wvCreateWindow
srcHBSelect "testbench.i_sorter_top" -win $_nTrace1
srcSetScope -win $_nTrace1 "testbench.i_sorter_top" -delim "."
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk_i" -win $_nTrace1
srcSelect -toggle -signal "clk_i" -win $_nTrace1
srcSelect -signal "clk_i" -win $_nTrace1
srcSelect -signal "rstn_i" -win $_nTrace1
srcSelect -signal "total_length_i" -win $_nTrace1
srcSelect -signal "total_group_i" -win $_nTrace1
srcSelect -signal "x_i" -win $_nTrace1
srcSelect -signal "y_o" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectGroup -win $_nWave2 {G2}
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
wvExpandBus -win $_nWave2 {("G1" 6)}
wvSelectGroup -win $_nWave2 {G2}
wvSelectSignal -win $_nWave2 {( "G1" 8 )} 
wvSetPosition -win $_nWave2 {("G1" 8)}
wvExpandBus -win $_nWave2 {("G1" 8)}
wvSetPosition -win $_nWave2 {("G1" 14)}
wvSelectSignal -win $_nWave2 {( "G1" 12 )} 
wvSetPosition -win $_nWave2 {("G1" 12)}
wvExpandBus -win $_nWave2 {("G1" 12)}
wvSetPosition -win $_nWave2 {("G1" 22)}
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvExpandBus -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 30)}
wvSetCursor -win $_nWave2 433479.859335 -snap {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvSetCursor -win $_nWave2 310458.759591 -snap {("G1" 4)}
wvSelectSignal -win $_nWave2 {( "G1" 20 )} 
wvSetPosition -win $_nWave2 {("G1" 20)}
wvCollapseBus -win $_nWave2 {("G1" 20)}
wvSetPosition -win $_nWave2 {("G1" 20)}
wvSetPosition -win $_nWave2 {("G1" 22)}
wvSelectSignal -win $_nWave2 {( "G1" 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvCollapseBus -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 14)}
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
wvSetPosition -win $_nWave2 {("G1" 6)}
wvCollapseBus -win $_nWave2 {("G1" 6)}
wvSetPosition -win $_nWave2 {("G1" 6)}
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvExpandBus -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 38)}
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
debExit
