
library ieee;
  context ieee.ieee_std_context;

library vunit_lib;
  context vunit_lib.vunit_context;

entity tb_neopixel_top is
  generic (
    runner_cfg        : string;
    G_CLOCK_PERIOD_NS : integer := 10;
    G_T0H_NS          : integer := 300;
    G_T0L_NS          : integer := 900;
    G_T1H_NS          : integer := 600;
    G_T1L_NS          : integer := 600;
    G_TRESET_NS       : integer := 80000
  );
end tb_neopixel_top;

architecture behav_neopixel_top of tb_neopixel_top is

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

  aclk    <= not aclk after 5 ns;
  aresetn <= '0', '1' after 100 ns;

  main : process
  begin
    test_runner_setup(runner, runner_cfg);

    wait for 10 us;

    test_runner_cleanup(runner);
    wait;
  end process;

end behav_neopixel_top;

