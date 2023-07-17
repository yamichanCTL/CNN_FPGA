-- Created by IP Generator (Version 2020.3-SP4 build 69652)
-- Instantiation Template
--
-- Insert the following codes into your VHDL file.
--   * Change the_instance_name to your own instance name.
--   * Change the net names in the port map.


COMPONENT System_Clock_PLL
  PORT (
    pll_rst : IN STD_LOGIC;
    clkin1 : IN STD_LOGIC;
    pll_lock : OUT STD_LOGIC;
    clkout0 : OUT STD_LOGIC
  );
END COMPONENT;


the_instance_name : System_Clock_PLL
  PORT MAP (
    pll_rst => pll_rst,
    clkin1 => clkin1,
    pll_lock => pll_lock,
    clkout0 => clkout0
  );
