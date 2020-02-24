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

architecture rtl_neopixel_top of neopixel_top is

  type T_SIG_BIT_STATE is (S_IDLE, S_NEXT_BIT, S_ONE, S_ZERO, S_DONE, S_RESET);

  signal sig_bit_s        : T_SIG_BIT_STATE;

  signal sig_count        : unsigned(31 downto 0);
  signal sig_bit_cnt      : integer range 0 to s_axis_tdata'length;
  signal sig_bit_idx      : integer range s_axis_tdata'range;
  signal sig_output       : std_logic;

begin

  S_sample: process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        sig_output <= '0';
      else
        sig_output <= '1' when sig_bit_s = S_ONE else '0';
      end if;
    end if;
  end process S_sample;

  S_sig_count: process(aclk) is
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        sig_count <= (others => '0');
      else
        if sig_bit_s = S_ONE or sig_bit_s <= S_ZERO then
          if sig_count /= (sig_count'range=> '1') then
            sig_count <= sig_count + 1;
          end if;
        else
          sig_count <= (others => '0');
        end if;
      end if;
    end if;
  end process;

  S_sig_bit: process(aclk) is
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        sig_bit_cnt <= 0;
        sig_bit_idx <= 0;
      else
        if sig_bit_cnt < s_axis_tdata'length and sig_bit_s = S_NEXT_BIT then
          sig_bit_cnt <= sig_bit_cnt + 1;
        end if;
        if sig_bit_idx <= s_axis_tdata'high and sig_bit_s = S_NEXT_BIT then
          sig_bit_idx <= sig_bit_idx + 1;
        end if;
      end if;
    end if;
  end process;

  S_sig_bit_s: process(aclk) is
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        sig_bit_s   <= S_IDLE;
        sig_output  <= '0';
      else
        case sig_bit_s is
          when S_IDLE =>
            if s_axis_tvalid = '1' then
              sig_bit_s <= S_NEXT_BIT;
            end if;

          when S_NEXT_BIT =>
            if sig_bit_cnt >= s_axis_tdata'length then
              sig_bit_s <= S_DONE;
            elsif s_axis_tdata(sig_bit_idx) = '1' then
              sig_bit_s <= S_ONE;
            else
              sig_bit_s <= S_ZERO;
            end if;

          when S_ONE =>
            sig_bit_s   <= S_ONE when sig_count < (G_T1H_NS + G_T1L_NS) else S_IDLE;
            sig_output  <=   '1' when sig_count < G_T1H_NS              else '0';

          when S_ZERO =>
            sig_bit_s   <= S_ZERO when sig_count < (G_T0H_NS + G_T0L_NS) else S_IDLE;
            sig_output  <=    '1' when sig_count < G_T0H_NS              else '0';

          when S_DONE =>
            sig_bit_s   <= S_RESET when s_axis_tlast = '1' else S_IDLE;

          when S_RESET =>
            sig_bit_s   <= S_RESET when sig_count < G_TRESET_NS else S_IDLE;

        end case;
      end if;
    end if;
  end process;

end rtl_neopixel_top;
