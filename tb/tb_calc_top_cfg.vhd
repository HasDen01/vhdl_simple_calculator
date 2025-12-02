-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : tb_calc_top_cfg.vhd                       --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_calc_top_cfg of tb_calc_top is
  for sim
    for i_calc_top : calc_top
      use configuration work.calc_top_struct_cfg;
    end for;
  end for;
end tb_calc_top_cfg;