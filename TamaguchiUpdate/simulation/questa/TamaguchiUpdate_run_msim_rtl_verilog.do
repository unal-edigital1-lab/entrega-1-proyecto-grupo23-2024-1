transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/diego/Desktop/TamaguchiUpdate {C:/Users/diego/Desktop/TamaguchiUpdate/ili9225_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/diego/Desktop/TamaguchiUpdate {C:/Users/diego/Desktop/TamaguchiUpdate/TamaguchiUpdate.v}
vlog -vlog01compat -work work +incdir+C:/Users/diego/Desktop/TamaguchiUpdate {C:/Users/diego/Desktop/TamaguchiUpdate/spi_master.v}

vlog -vlog01compat -work work +incdir+C:/Users/diego/Desktop/TamaguchiUpdate {C:/Users/diego/Desktop/TamaguchiUpdate/TamaguchiUpdate_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TamaguchiUpdate_tb

add wave *
view structure
view signals
run -all
