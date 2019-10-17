-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- 2. Entidad
-- Declaro entradas y salidas fisicas
entity access_memoria is
Port(RELOJ   :IN  STD_LOGIC;
     ENTRADAS:IN STD_LOGIC_VECTOR(2 DOWNTO 0); --A,B,C
     SALIDAS :OUT STD_LOGIC_VECTOR(5 DOWNTO 0)); --S0,S1,S2,S3,S4,S5
end access_memoria;

-- 3. Arquitectura
architecture x of access_memoria is

	signal data: STD_LOGIC_VECTOR (8 downto 0);
	signal SW: STD_LOGIC_VECTOR (5 downto 0) := "000000";
	signal delay: integer range 0 to 50000000:=0; -- Reloj base 50 MHz
	signal div: std_logic:='0';
	
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
		
		seg_ROM_7: entity work.carta_asm_trayectoria
		port map (addr => SW, data=>data);
		
		cambio:process(div)
			begin
				if(rising_edge(div)) then
					SW(5 downto 3) <= data(8 downto 6);
					SW(2 downto 0) <= ENTRADAS;
					SALIDAS <= data(5 downto 0);
				end if;
		end process;
		
end x;