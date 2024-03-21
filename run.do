vlib work
vlog 8088.svp -lint 
vlog fsm.sv -lint 
vlog interface.sv -lint +acc
vlog top-3_MARK.sv -lint +acc
vsim work.top
add wave -r *
run -all
