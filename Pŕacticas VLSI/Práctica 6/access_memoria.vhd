-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

-- 2. Entidad
-- Declaro entradas y salidas físicas
entity access_memoria is
Port(
	 SW :IN  STD_LOGIC_VECTOR (3 downto 0);
	 DISP : OUT STD_LOGIC_VECTOR (6 downto 0));
end access_memoria;

-- 3. Arquitectura
architecture x of access_memoria is
	signal data: STD_LOGIC_VECTOR (6 downto 0);
	begin
		seg_ROM_7: entity work.memoria
		port map (addr => SW, data=>data);
		DISP <= data;
end x;