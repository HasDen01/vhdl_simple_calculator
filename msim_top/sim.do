vsim -t ns -novopt -lib work work.tb_calc_top_cfg
view *
do calc_top_wave.do
run 250 ms
