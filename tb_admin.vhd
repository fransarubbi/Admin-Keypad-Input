LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_admin IS
END tb_admin;
 
ARCHITECTURE behavior OF tb_admin IS 
    COMPONENT admin
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ready : IN  std_logic;
         value_in : IN  std_logic_vector(3 downto 0);
			finish : OUT std_logic;
			plot : OUT std_logic;
         first_factor : OUT  std_logic_vector(7 downto 0);
         second_factor : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ready : std_logic := '0';
   signal value_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal first_factor : std_logic_vector(7 downto 0);
   signal second_factor : std_logic_vector(7 downto 0);
	signal plot : std_logic;
	signal finish : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: admin PORT MAP (
          clk => clk,
          rst => rst,
          ready => ready,
          value_in => value_in,
			 finish => finish,
			 plot => plot,
          first_factor => first_factor,
          second_factor => second_factor
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '0';
		wait for 100 ns;
		
		rst <= '1';
		wait for 100 ns;
		
		value_in <= "1010";   -- first factor ms
		ready <= '1';
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		ready <= '1';
		value_in <= "1111";   -- first factor ls
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		ready <= '1';
		value_in <= "1010";   -- confirma first factor
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		value_in <= "1111";   -- first factor ls
		ready <= '1';
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		ready <= '1';
		value_in <= "1010";   -- first factor ms
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		ready <= '1';
		value_in <= "1010";
		wait for 50 ns;
		------------------------------- Funciona
		
		rst <= '0';
		wait for 50 ns;
		rst <= '1';
		value_in <= "0011";   -- first factor ms
		ready <= '1';
		wait for 50 ns;
		ready <= '0';
		wait for 100 ns;
		ready <= '1';
		value_in <= "1100";   -- first factor ls
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		ready <= '1';
		value_in <= "1011";   -- borra first factor
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		value_in <= "0001";   -- first factor ms
		ready <= '1';
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		ready <= '1';
		value_in <= "1000";   -- first factor ls
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		ready <= '1';
		value_in <= "1010";   -- confirma first factor
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		value_in <= "1011";   -- second factor ms
		ready <= '1';
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		ready <= '1';
		value_in <= "1011";   -- second factor ls
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		ready <= '1';
		value_in <= "1011";   -- borra second factor
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		value_in <= "1111";   -- second factor ms
		ready <= '1';
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		ready <= '1';
		value_in <= "0000";   -- second factor ls
		wait for 50 ns;
		ready <= '0';
		wait for 50 ns;
		
		ready <= '1';
		value_in <= "1010";   -- confirma second factor
		wait for 50 ns;
		
      wait;
   end process;

END;
