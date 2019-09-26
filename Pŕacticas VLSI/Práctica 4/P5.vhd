----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:50:43 09/19/2019 
-- Design Name: 
-- Module Name:    p4 - Behavioral 
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

entity P5 is
    Port ( sd : in  STD_LOGIC;
           si : in  STD_LOGIC;
           adelante : out  STD_LOGIC;
           atras : out  STD_LOGIC;
           giro_der : out  STD_LOGIC;
           giro_izq : out  STD_LOGIC;
			  RESET : in STD_LOGIC;
			  display : out STD_LOGIC_VECTOR(6 downto 0);
			  RELOJ : in STD_LOGIC);
end P5;

architecture Behavioral of P5 is
	type estado is (E0,E1,E2,E3,E4,E5,E6,E7,E8,E9,E10,E11);	
	signal qt: estado;  --estado siguiente
	
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
	
		seleccion:process(div)
			begin
				if(rising_edge(div)) then
					if (RESET = '1') then 
						qt <= E0;
					else
						case qt is
							when E0 =>
								atras <= '0';
								adelante <= '0';
								giro_der <= '0';
								giro_izq <= '0';
								display <= "1000000";
								if (si = '0') then
									if (sd = '1') then
										qt <= E1;
									else
										qt <= E0;
									end if;
								else 
									if (sd = '0') then
										qt <= E3;
									else 
										qt <= E5;
									end if;
								end if;
							when E1 =>
								display <= "1111001";
								atras <= '1';
								adelante <= '0';
								giro_der <= '0';
								giro_izq <= '0';
								qt <= E2;
							when E2 =>
								display <= "0100100";
								atras <= '0';
								adelante <= '0';
								giro_der <= '0';
								giro_izq <= '1';
								qt <= E0;
							when E3 =>
								display <= "0110000";
								atras <= '1';
								adelante <= '0';
								giro_der <= '0';
								giro_izq <= '0';
								qt <= E4;
							when E4 =>
								display <= "0011001";
								atras <= '0';
								adelante <= '0';
								giro_der <= '1';
								giro_izq <= '0';
								qt <= E0;
							when E5 =>
								display <= "0010010";
								atras <= '1';
								adelante <= '0';
								giro_der <= '0';
								giro_izq <= '0';
								qt <= E6;
							when E6 =>
								display <= "0000010";
								atras <= '0';
								adelante <= '0';
								giro_der <= '0';
								giro_izq <= '1';
								qt <= E7;
							when E7 =>
								display <= "1111000";
								atras <= '0';
								adelante <= '0';
								giro_der <= '0';
								giro_izq <= '1';
								qt <= E8;
							when E8 =>
								display <= "0000000";
								atras <= '0';
								adelante <= '1';
								giro_der <= '0';
								giro_izq <= '0';
								qt <= E9;
							when E9 =>
								display <= "0010000";
								atras <= '0';
								adelante <= '1';
								giro_der <= '0';
								giro_izq <= '0';
								qt <= E10;
							when E10 =>
								display <= "0001000";
								atras <= '0';
								adelante <= '0';
								giro_der <= '1';
								giro_izq <= '0';
								qt <= E11;
							when E11 =>
								display <= "0000011";
								atras <= '0';
								adelante <= '0';
								giro_der <= '1';
								giro_izq <= '0';
								qt <= E0;
							end case;
						end if;
				end if;
		end process;
end Behavioral;

