vlib work
vdel -all
vlib work
vlog -lint fsm.sv
vlog -lint 8088.svp +acc -sv
vlog -lint top-3_MARK.sv +acc -sv
vsim work.top
add wave -r /*
run -all