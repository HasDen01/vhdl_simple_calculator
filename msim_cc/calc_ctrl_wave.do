onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_calc_ctrl/clk_i
add wave -noupdate -format Logic /tb_calc_ctrl/reset_i
add wave -noupdate -format Logic /tb_calc_ctrl/result_i
add wave -noupdate -format Logic /tb_calc_ctrl/finished_i
add wave -noupdate -format Logic /tb_calc_ctrl/sign_i
add wave -noupdate -format Logic /tb_calc_ctrl/error_i
add wave -noupdate -format Logic /tb_calc_ctrl/overflow_i

add wave -noupdate -format Logic /tb_calc_ctrl/swsync_i
add wave -noupdate -format Logic /tb_calc_ctrl/pbsync_i
add wave -noupdate -format Logic /tb_calc_ctrl/dig0_o
add wave -noupdate -format Logic /tb_calc_ctrl/dig1_o
add wave -noupdate -format Logic /tb_calc_ctrl/dig2_o
add wave -noupdate -format Logic /tb_calc_ctrl/dig3_o
add wave -noupdate -format Logic /tb_calc_ctrl/led_o
add wave -noupdate -format Logic /tb_calc_ctrl/start_o
add wave -noupdate -format Logic /tb_calc_ctrl/optype_o
add wave -noupdate -format Logic /tb_calc_ctrl/op1_o
add wave -noupdate -format Logic /tb_calc_ctrl/op2_o
add wave -position end  sim:/tb_calc_ctrl/i_calc_ctrl/state_interface

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue lefts
