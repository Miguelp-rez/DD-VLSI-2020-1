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
	     addr_width: integer := 8; --numero de localidades de memoria
	     addr_bits: integer := 3; --palabra binaria para acceder a una localidad
	     data_width: integer := 14); --ancho de la palabra binaria

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
	signal contenido : rom_type:= (
	--P1,P2,P3,T1,T2,N1,N2,N3,Y1,Y2,Y3,S0,S1,S2,S3,S4,S5
		"10001101011000",		--localidad 0
		"00010010000010",		--localidad 1
		"00011011001001",		--localidad 2
		"11100110000110",		--localidad 3
		"00010010100000",		--localidad 4
		"01011110000100",		--localidad 5
		"00000000001010",		--localidad 6
		"00000000000000");	--localidad 7
	begin
		data <= contenido(conv_integer(unsigned(addr)));

end xx;