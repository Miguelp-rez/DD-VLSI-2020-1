-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

-- 2. Entidad
-- Declaro entradas y salidas físicas
entity memoria is
generic( -- Describir la estructura de la ROM
	     addr_width: integer := 16; --numero de localidades de memoria
	     addr_bits: integer := 4; --palabra binaria para acceder a una localidad
	     data_width: integer := 7); --ancho de la palabra binaria

Port(
	 addr :IN  STD_LOGIC_VECTOR (addr_bits-1 downto 0);
	 data : OUT STD_LOGIC_VECTOR (data_width-1 downto 0));
end memoria;

-- 3. Arquitectura
architecture xx of memoria is
	type rom_type is array(0 to addr_width-1) of
		STD_LOGIC_VECTOR (data_width-1 downto 0);
	-- MSB         LSB
	--  g f e d c b a
	signal seg7: rom_type:= (
		"1000000",  --localidad 0
		"1111001",  --localidad 1
		"0100100",  --localidad 2
		"0110000",  --localidad 3
		"0011001",  --localidad 4
		"0010010",  --localidad 5
		"0000011",  --localidad 6
		"1111000",  --localidad 7
		"0000000",  --localidad 8
		"0001100",  --localidad 9
		"0001000",  --localidad 10
		"0000011",  --localidad 11
		"1000110",  --localidad 12
		"0100001",  --localidad 13
		"0000110",  --localidad 14
		"0001110");  --localidad 15
	
	begin
		data <= seg7(conv_integer(unsigned(addr)));

end xx;