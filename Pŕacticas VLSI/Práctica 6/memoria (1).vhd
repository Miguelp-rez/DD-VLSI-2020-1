-- 1. Bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- 2. Entidad
-- Declaro entradas y salidas físicas
entity memoria is
generic( -- Describir la estructura de la ROM
	     addr_width: integer := 32; --numero de localidades de memoria
	     addr_bits: integer := 5; --palabra binaria para acceder a una localidad
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
		"1000001",  --localidad 0  V
		"1000111",  --localidad 1  L
		"0010010",  --localidad 2  S
		"1001111",  --localidad 3  I
		"0111111",  --localidad 4  -
		"0100100",  --localidad 5  2
		"0000000",  --localidad 6  0
		"0100100",  --localidad 7  2
		"0000000",  --localidad 8  0
		"0111111",  --localidad 9  -
		"1111001",  --localidad 10 1
		"0111111",  --localidad 11 -
		"0001000",  --localidad 12 A
		"1000111",  --localidad 13 L
		"1001000",  --localidad 14 M
		"0001000",  --localidad 15 A
		"1001000",  --localidad 16 M
		"1001000",  --localidad 17 M
		"1000110",  --localidad 18 C
		"0000010",  --localidad 19 G
		"1001000",  --localidad 20 M
		"1111000",  --localidad 21 T
		"1001000",  --localidad 22 M
		"0001000",  --localidad 23 A
		"0001100",  --localidad 24 P
		"1000000",  --localidad 25 Q
		"0000000",  --localidad 26 
		"0000000",  --localidad 27 
		"0000000",  --localidad 28 
		"0000000",  --localidad 29 
		"0000000",  --localidad 30  
		"0000000"); --localidad 31 
	
	begin
		data <= seg7(to_integer(unsigned(addr)));

end xx;