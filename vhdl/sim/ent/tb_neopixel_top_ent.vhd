library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_neopixel_top is
  generic (
    G_CLOCK_PERIOD_NS : integer := 10;
    G_T0H_NS          : integer := 300;
    G_T0L_NS          : integer := 900;
    G_T1H_NS          : integer := 600;
    G_T1L_NS          : integer := 600;
    G_TRESET_NS       : integer := 80000
  );
end tb_neopixel_top;
