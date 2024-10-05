library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity admin is
    Port ( clk           : in  STD_LOGIC;
			  rst           : in  STD_LOGIC;
           ready         : in  STD_LOGIC;
           value_in      : in  STD_LOGIC_VECTOR(3 downto 0);
			  plot          : out STD_LOGIC;
           first_factor  : out STD_LOGIC_VECTOR(7 downto 0);
           second_factor : out STD_LOGIC_VECTOR(7 downto 0));
end admin;

architecture Behavioral of admin is
	type state is (waiting, first, second, ok);
   signal state_present, state_future: state;
	
	-- Controles
	signal C_delete : std_logic;   -- Señal de control para borrar numero
	signal C_ok_first : std_logic;  -- Señal de control para confirmar primer factor
	signal C_ok_second : std_logic; -- Señal de control para confirmar segundo factor
	
	-- Numeros
	signal first_factor_ls : std_logic_vector(3 downto 0);  -- Primer factor menos significativo
	signal first_factor_ms : std_logic_vector(3 downto 0);  -- Primer factor mas significativo
	signal second_factor_ls : std_logic_vector(3 downto 0); -- Segundo factor menos significativo
	signal second_factor_ms : std_logic_vector(3 downto 0); -- Segundo factor mas significativo
	
	-- Contadores
	signal CONT_key_reg : std_logic_vector(3 downto 0);  -- Seis teclas en total 4 numeros y 2 confirmaciones
	signal CONT_key_input : std_logic_vector(3 downto 0);
	
	-- Señal para detectar flancos de ready
   signal ready_before : std_logic := '0';  -- Estado anterior de ready
   signal ready_event : std_logic;  -- Señal que indica un cambio de 0 a 1 en ready
	
begin
	-- Detecta el flanco ascendente de ready (pasa de 0 a 1)
   ready_event <= '1' when ready = '1' and ready_before = '0' else '0';
	
	-- Activa la señal de borrar cuando se han pulsado 2 o 5 teclas y hay un flanco de ready
	C_delete <= '1' when ready_event = '1' and value_in = "1011" and (CONT_key_reg = "0010" or CONT_key_reg = "0101") else '0';
	
	-- Incrementar la cantidad de teclas pulsadas o restarlas dependiendo de la situacion
	CONT_key_input <= CONT_key_reg + '1' when ready_event = '1' and C_delete = '0' else
						   std_logic_vector(unsigned(CONT_key_reg) - 2) when ready_event = '1' and C_delete = '1' else CONT_key_reg;
	
	-- Ingreso de la parte mas y menos significativa del primer factor
	first_factor_ls <= value_in when ready_event = '1' and CONT_key_reg = "0000" else first_factor_ls;
	first_factor_ms <= value_in when ready_event = '1' and CONT_key_reg = "0001" else first_factor_ms;
	
	-- Activar la señal de primer numero cargado
	C_ok_first <= '1' when ready_event = '1' and value_in = "1010" and CONT_key_reg = "0010" else '0';
	
	-- Ingreso de la parte mas y menos significativa del segundo factor
	second_factor_ls <= value_in when ready_event = '1' and CONT_key_reg = "0011" else second_factor_ls;
	second_factor_ms <= value_in when ready_event = '1' and CONT_key_reg = "0100" else second_factor_ms;

	-- Activar la señal de segundo numero cargado
	C_ok_second <= '1' when ready_event = '1' and value_in = "1010" and CONT_key_reg = "0101" else '0';

	comb:process(state_present, ready_event, C_ok_first, C_ok_second)
	begin
			state_future <= state_present;
			case state_present is
					when waiting =>
						plot <= '1';
						first_factor <= (others => '0');
						second_factor <= (others => '0');
						if ready_event = '1' then
							state_future <= first;
						end if;
					
					when first =>
						if C_ok_first = '1' then
							first_factor <= first_factor_ms & first_factor_ls;
							state_future <= second;
						end if;
					
					when second =>
						if C_ok_second = '1' then
							second_factor <= second_factor_ms & second_factor_ls;
							state_future <= ok;
						end if;
					
					when ok =>
						plot <= '0';
			end case;
	end process comb;

	sec:process(clk, rst)
	begin
		if rst = '0' then
			CONT_key_reg <= "0000";
			ready_before <= '0';
			state_present <= waiting;
		elsif clk'event and clk = '1' then
			CONT_key_reg <= CONT_key_input;
			ready_before <= ready;
			state_present <= state_future;
		end if;
	end process sec;
end Behavioral;