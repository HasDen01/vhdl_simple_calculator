@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto 6ed63359fcec4d3cb08bd9fea91ae9b9 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot calc_top_behav xil_defaultlib.calc_top -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
