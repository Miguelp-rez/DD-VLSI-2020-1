-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;




-- 2. Entidad
-- Declaro entradas y salidas f�sicas
entity P5 is
Port(RELOJ	:IN  STD_LOGIC;
	 ct	:IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
	 led : OUT STD_LOGIC;
	 servo   :OUT  STD_LOGIC);
end P5;

-- 3. Arquitectura
architecture Behavioral of P5 is
	signal delay: integer range 0 to 250001:=0; -- Reloj base 50 MHz
	signal div: std_logic:='0';
	signal cont: integer :=0;
	signal pwm: std_logic:='1';
	SIGNAL b: integer;
	signal numero: integer;
	
	
	begin
	--Divisor de frecuencia
	--MCLK = Master Clock(50MHz)
	--Si T = 1[s] -> f=1/T=1[Hz]
	--NUM = MCLK/2*f = 50*10^6 Hz/2*1 Hz = 50000000
		divisor:process(RELOJ)
			begin
				if(rising_edge(RELOJ)) then
					if(delay = 5000) then	
						delay <= 0;
						div <= '1';
					else
						delay <= delay + 1;
						div <= '0';
					end if;
				end if;
		end process;

		contador:process(div, ct, b)
			begin
			b <= conv_integer(unsigned(ct)); --ENTERO DE CT
			numero <= b * 6;
				if(rising_edge(div)) then
					cont <= cont +1;
					
					if (cont<=numero) then

						pwm<='1';
						
					
					else
						
						pwm <='0';
						if (cont=99) then
							cont<=0;
						end if;
					end if;
					
				end if;
		end process;
		servo<=pwm;
		led<=pwm;





end Behavioral;

