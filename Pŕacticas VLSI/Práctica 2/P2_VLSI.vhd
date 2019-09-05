-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 2. Entidad
-- Declaro entradas y salidas f�sicas
entity REG_COR is
Port(RELOJ :IN  STD_LOGIC;
	  RESET :IN  STD_LOGIC;
	  DIR   :IN  STD_LOGIC;
	  LEDS  :OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end REG_COR;

-- 3. Arquitectura
architecture Prac2 of REG_COR is
	signal delay: integer range 0 to 50000000:=0; -- Reloj base 50 MHz
	signal div: std_logic:='0';
	signal corrimiento: STD_LOGIC_VECTOR (7 downto 0):= x"99";
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

		registro:process(div)
			begin
				if(RESET = '0') then
					if(rising_edge(div)) then
						if(DIR = '0') then
							corrimiento(7) <= corrimiento(0);
							corrimiento(6) <= corrimiento(7);
							corrimiento(5) <= corrimiento(6);
							corrimiento(4) <= corrimiento(5);
							corrimiento(3) <= corrimiento(4);
							corrimiento(2) <= corrimiento(3);
							corrimiento(1) <= corrimiento(2);
							corrimiento(0) <= corrimiento(1);
						end if;
						if(DIR = '1') then
							corrimiento(0) <= corrimiento(7);
							corrimiento(7) <= corrimiento(6);
							corrimiento(6) <= corrimiento(5);
							corrimiento(5) <= corrimiento(4);
							corrimiento(4) <= corrimiento(3);
							corrimiento(3) <= corrimiento(2);
							corrimiento(2) <= corrimiento(1);
							corrimiento(1) <= corrimiento(0);
						end if;
					end if;
				else
					corrimiento <= x"99";
				end if;
		end process;

LEDS<= corrimiento; -- NOT porque los leds estan conectados en l�gica negada

end Prac2;