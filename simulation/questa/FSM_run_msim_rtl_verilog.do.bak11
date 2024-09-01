transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/kevin/github-classroom/entrega-1-proyecto-grupo23-2024-1/db {/home/kevin/github-classroom/entrega-1-proyecto-grupo23-2024-1/db/tiempo.v}

vlog -vlog01compat -work work +incdir+/home/kevin/github-classroom/entrega-1-proyecto-grupo23-2024-1/db {/home/kevin/github-classroom/entrega-1-proyecto-grupo23-2024-1/db/tb_tiempo.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tiempo_tb

add wave *
view structure
view signals
run -all
