-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 2. Entidad
-- Declaro entradas y salidas físicas
entity CONT8B is
Port(RELOJ:IN  STD_LOGIC;
	 RESET:IN  STD_LOGIC;
	 IP   :IN  STD_LOGIC;
	 LEDS :OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end cont8b;

-- 3. Arquitectura
architecture Prac1 of CONT8B is
	signal delay: integer range 0 to 50000000:=0; -- Reloj base 50 MHz
	signal div: std_logic:='0';
	signal cont: STD_LOGIC_VECTOR (7 downto 0):="00000000";
	begin
	--Divisor de frecuencia
	--MCLK = Master Clock(50MHz)
	--Si T = 1[s] -> f=1/T=1[Hz]
	--NUM = MCLK/2*f = 50*10^6 Hz/2*1 Hz = 50000000
		divisor:process(RELOJ)
			begin
				if(rising_edge(RELOJ)) then
					if(delay = 49999999) then	
						delay <= 0;
						div <= '1';
					else
						delay <= delay + 1;
						div <= '0';
					end if;
				end if;
		end process;

		contador:process(div)
			begin
				if(rising_edge(div)) then
					-- IP = 0 PARA
					-- IP = 1 INICIA
					-- RESET = 0 CUENTA
					-- RESET = 1 RESET
					if(RESET = '1' OR cont = "11111111") then
						cont <= "00000000"; --X"00"
					elsif(IP = '1') then
						cont <= cont + '1';
					else
						cont <= cont + '0';
					end if;
				end if;
		end process;

LEDS<= cont; -- NOT porque los leds estan conectados en lógica negada

end Prac1;

