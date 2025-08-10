vlib work
vlog SPI_old.v ram.v top.v tb.v
vsim -voptargs=+acc tb
add wave *
run -all
#quit -sim
