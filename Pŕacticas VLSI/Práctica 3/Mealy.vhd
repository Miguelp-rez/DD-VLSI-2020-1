----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:30:47 09/11/2019 
-- Design Name: 
-- Module Name:    Mealy - Behavioral 
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

entity Mealy is
    Port ( RELOJ : in  STD_LOGIC;
           H : in  STD_LOGIC;
           A : out  STD_LOGIC;
           B : out  STD_LOGIC);
end Mealy;

architecture Behavioral of Mealy is
	type estado is (E0,E1,E2,E3);
	signal edo_pres, edo_sig: estado;
begin

--Proceso para asignar estados
asignacion: process(RELOJ)
	begin
	if(rising_edge(RELOJ)) then
		edo_pres<=edo_sig;
	end if;
end process;

--Proceso para manejo de entradas y salidas
seleccion: process(edo_pres, H)
	begin
	case edo_pres is
		when E0 =>
			if(H='1') then
				A<='0';
				B<='0';
				edo_sig<=E0;
			else
				A<='1';
				B<='0';
				edo_sig<=E1;
			end if;
		when E1 =>
			if(H='1') then
				A<='0';
				B<='0';
				edo_sig<=E2;
			else
				A<='1';
				B<='0';
				edo_sig<=E1;
			end if;
		when E2 =>
			if(H='1') then
				A<='0';
				B<='0';
				edo_sig<=E2;
			else
				A<='0';
				B<='1';
				edo_sig<=E3;
			end if;
		when E3 =>
			if(H='1') then
				A<='0';
				B<='0';
				edo_sig<=E0;
			else
				A<='0';
				B<='1';
				edo_sig<=E3;
			end if;
	end case;
end process;


end Behavioral;

