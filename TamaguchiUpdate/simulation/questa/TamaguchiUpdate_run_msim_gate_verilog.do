transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {TamaguchiUpdate.vo}

vlog -vlog01compat -work work +incdir+C:/Users/diego/Desktop/TamaguchiUpdate/output_files {C:/Users/diego/Desktop/TamaguchiUpdate/output_files/TamaguchiUpdate_tb.v}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  TamaguchiUpdate_tb

add wave *
view structure
view signals
run -all
