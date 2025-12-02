onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_calc_top/clk_i
add wave -noupdate -format Logic /tb_calc_top/reset_i
add wave -noupdate -format Logic /tb_calc_top/pb_i
add wave -position end  sim:/tb_calc_top/i_calc_top/pbsync
add wave -noupdate -format Logic /tb_calc_top/sw_i
add wave -position end  sim:/tb_calc_top/i_calc_top/swsync
add wave -position end  sim:/tb_calc_top/i_calc_top/i_alu/op1_i
add wave -position end  sim:/tb_calc_top/i_calc_top/i_alu/op2_i
add wave -position end  sim:/tb_calc_top/i_calc_top/i_calc_ctrl/state_interface
add wave -position end  sim:/tb_calc_top/i_calc_top/i_alu/finished_o
add wave -position end  sim:/tb_calc_top/i_calc_top/i_alu/result_o
add wave -position end  sim:/tb_calc_top/i_calc_top/ss_o
add wave -position end  sim:/tb_calc_top/i_calc_top/ss_sel_o
add wave -position end  sim:/tb_calc_top/i_calc_top/dig0
add wave -position end  sim:/tb_calc_top/i_calc_top/dig1
add wave -position end  sim:/tb_calc_top/i_calc_top/dig2
add wave -position end  sim:/tb_calc_top/i_calc_top/dig3

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
