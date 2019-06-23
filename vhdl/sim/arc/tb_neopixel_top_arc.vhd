library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

architecture behav_neopixel_top of tb_neopixel_top is

  signal test_done       : boolean := false;

  signal aclk            : std_logic := '0';
  signal aresetn         : std_logic;
  signal s_axis_tdata    : std_logic_vector(23 downto 0);
  signal s_axis_tlast    : std_logic;
  signal s_axis_tvalid   : std_logic;
  signal s_axis_tready   : std_logic;
  signal m_neopixel      : std_logic;

begin

  UUT : entity work.neopixel_top
    generic map(
      G_CLOCK_PERIOD_NS => G_CLOCK_PERIOD_NS,
      G_T0H_NS          => G_T0H_NS,
      G_T0L_NS          => G_T0L_NS,
      G_T1H_NS          => G_T1H_NS,
      G_T1L_NS          => G_T1L_NS,
      G_TRESET_NS       => G_TRESET_NS
    )
    port map(
      aclk            => aclk,
      aresetn         => aresetn,
      s_axis_tdata    => s_axis_tdata,
      s_axis_tlast    => s_axis_tlast,
      s_axis_tvalid   => s_axis_tvalid,
      s_axis_tready   => s_axis_tready,
      m_neopixel      => m_neopixel
    );

  process
  begin
    wait for 5 ns;
    aclk <= not aclk;
    if test_done then wait; end if;
  end process;

  aresetn <= '0', '1' after 100 ns;

  process
  begin
    for i in 0 to 3 loop
      wait for 1 ns;
      assert aresetn = '1' report "reset is not 1" severity error;
    end loop;

    assert false report "end of test" severity note;
    test_done <= true;
    wait;
  end process;

end behav_neopixel_top;
