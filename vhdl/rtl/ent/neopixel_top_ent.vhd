library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity neopixel_top is
  generic (
    G_CLOCK_PERIOD_NS : integer := 10;
    G_T0H_NS          : integer := 300;
    G_T0L_NS          : integer := 900;
    G_T1H_NS          : integer := 600;
    G_T1L_NS          : integer := 600;
    G_TRESET_NS       : integer := 80000
  );
  port (
    aclk            : in  std_logic;
    aresetn         : in  std_logic;
    
    s_axis_tdata    : in  std_logic_vector(23 downto 0);
    s_axis_tlast    : in  std_logic;
    s_axis_tvalid   : in  std_logic;
    s_axis_tready   : out std_logic;
    
    m_neopixel      : out std_logic
  );
end neopixel_top;
