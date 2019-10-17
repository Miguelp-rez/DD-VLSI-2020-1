----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:37:49 10/10/2019 
-- Design Name: 
-- Module Name:    access_memoria - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity access_memoria is
    Port (RELOJ   :IN  STD_LOGIC;
			 ENTRADAS:IN STD_LOGIC_VECTOR(2 DOWNTO 0); --A,B,C
			 SALIDAS :OUT STD_LOGIC_VECTOR(5 DOWNTO 0)); --S0,S1,S2,S3,S4,S5
end access_memoria;

-- 3. Arquitectura
architecture x of access_memoria is
	signal data: STD_LOGIC_VECTOR (13 downto 0);
	signal SW: STD_LOGIC_VECTOR (2 downto 0) := "000";	--Edo. sig
	signal test : STD_LOGIC_VECTOR (1 downto 0) := "00";	--Test input
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
		
		seg_ROM_7: entity work.memoria
		port map (addr => SW, data=>data);
		
		cambio:process(div, ENTRADAS)
			begin
				if(rising_edge(div)) then
					--test <= data(13 downto 12);
					case data (13 downto 12) is
						when "01" =>	--Entrada A
							if(ENTRADAS(2) = '0') then
								SW <= data(11 downto 9);	--Liga falsa
							else
								SW <= data(8 downto 6);		--Liga verdadera
							end if;
						when "10" =>	--Entrada B
							if(ENTRADAS(1) = '0') then
								SW <= data(11 downto 9);	--Liga falsa
							else
								SW <= data(8 downto 6);		--Liga verdadera
							end if;
						when "11" =>	--Entrada C
							if(ENTRADAS(0) = '0') then
								SW <= data(11 downto 9);	--Liga falsa
							else
								SW <= data(8 downto 6);		--Liga verdadera
							end if;
						when others =>	--Entrada auxiliar
							--Directo
							SW <= data(11 downto 9);
					end case;
					SALIDAS <= data(5 downto 0);
				end if;
		end process;
end x;
