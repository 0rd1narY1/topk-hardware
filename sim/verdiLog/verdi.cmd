debImport "-i" "-simflow" "-simBin" "./simv" "-simDelim" "-a vcs.log"
srcTBInvokeSim
srcHBSelect "testbench.i_bitonic" -win $_nTrace1
srcHBSelect "testbench.i_bitonic" -win $_nTrace1
srcSetScope -win $_nTrace1 "testbench.i_bitonic" -delim "."
wvCreateWindow
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk_i" -win $_nTrace1
srcSelect -signal "rstn_i" -win $_nTrace1
srcSelect -signal "sign_ctrl_i" -win $_nTrace1
srcSelect -signal "x_i" -win $_nTrace1
srcSelect -signal "y_o" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
verdiDockWidgetMaximize -dock windowDock_nWave_3
srcTBRunSim
verdiDockWidgetMaximize -dock windowDock_nWave_3
wvSelectGroup -win $_nWave3 {G2}
wvSelectSignal -win $_nWave3 {( "G1" 4 )} 
wvSetPosition -win $_nWave3 {("G1" 4)}
wvExpandBus -win $_nWave3 {("G1" 4)}
wvSetPosition -win $_nWave3 {("G1" 21)}
wvSelectSignal -win $_nWave3 {( "G1" 21 )} 
wvExpandBus -win $_nWave3 {("G1" 21)}
wvSelectSignal -win $_nWave3 {( "G1" 23 )} 
wvSelectSignal -win $_nWave3 {( "G1" 21 )} 
wvScrollUp -win $_nWave3 2
wvSelectSignal -win $_nWave3 {( "G1" 4 21 )} 
wvSelectSignal -win $_nWave3 {( "G1" 4 21 )} 
wvSetRadix -win $_nWave3 -format UDec
wvSetRadix -win $_nWave3 -2Com
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollUp -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 1
verdiWindowResize -win $_Verdi_1 "0" "39" "1920" "1004"
verdiWindowResize -win $_Verdi_1 "0" "35" "1920" "1008"
verdiWindowResize -win $_Verdi_1 "0" "39" "1920" "1004"
verdiWindowResize -win $_Verdi_1 "0" "35" "1920" "1008"
