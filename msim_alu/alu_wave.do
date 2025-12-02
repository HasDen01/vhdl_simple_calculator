onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_alu/clk_i
add wave -noupdate -format Logic /tb_alu/reset_i
add wave -noupdate -format Logic /tb_alu/optype_i
add wave -noupdate -format Logic /tb_alu/op1_i
add wave -noupdate -format Logic /tb_alu/op2_i
add wave -position end  /tb_alu/i_alu/p_calculate/op1_17bit
add wave -position end  /tb_alu/i_alu/p_calculate/op2_17bit
add wave -noupdate -format Logic /tb_alu/result_o
add wave -position end  sim:/tb_alu/i_alu/downcounter
add wave -noupdate -format Logic /tb_alu/finished_o
add wave -noupdate -format Logic /tb_alu/sign_o
add wave -noupdate -format Logic /tb_alu/error_o
add wave -noupdate -format Logic /tb_alu/overflow_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue lefts
