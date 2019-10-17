-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity CARTA_ASM_TRAYECTORIA is
generic( -- Describir la estructura de la ROM
	     addr_width: integer := 64; --numero de localidades de memoria
	     addr_bits: integer := 6; --palabra binaria para acceder a una localidad
	     data_width: integer := 9); --ancho de la palabra binaria

Port(
	 addr :IN  STD_LOGIC_VECTOR (addr_bits-1 downto 0);
	 data :OUT STD_LOGIC_VECTOR (data_width-1 downto 0));
end CARTA_ASM_TRAYECTORIA;

architecture Behavioral of CARTA_ASM_TRAYECTORIA is
	type rom_type is array(0 to addr_width-1) of
		STD_LOGIC_VECTOR (data_width-1 downto 0);
		
	signal memoria: rom_type:= (
		--L2,L1,L0,S0,S1,S2,S3,S4,S5
		--estado 0
		"001011010",  --localidad 0
		"001011010",  --localidad 1
		"011011100",  --localidad 2
		"011011100",  --localidad 3
		"001011010",  --localidad 4
		"001011010",  --localidad 5
		"011011100",  --localidad 6
		"011011100",  --localidad 7
		--estado 1
		"010001001",  --localidad 8
		"010001001",  --localidad 9
		"010001001",  --localidad 10
		"010001001",  --localidad 11
		"010001001",  --localidad 12
		"010001001",  --localidad 13
		"010001001",  --localidad 14
		"010001001",  --localidad 15
		--estado 2
		"001100110",  --localidad 16
		"100000110",  --localidad 17
		"001100110",  --localidad 18
		"100000110",  --localidad 19
		"001100110",  --localidad 20
		"100000110",  --localidad 21
		"001100110",  --localidad 22
		"100000110",  --localidad 23
		--estado 3
		"010000100",  --localidad 24
		"010000100",  --localidad 25
		"010000100",  --localidad 26 
		"010000100",  --localidad 27 
		"100000100",  --localidad 28 
		"100000100",  --localidad 29 
		"100000100",  --localidad 30  
		"100000100",  --localidad 31
		--estado 4
		"000001010",  --localidad 32
		"000001010",  --localidad 33
		"000001010",  --localidad 34 
		"000001010",  --localidad 35 
		"000001010",  --localidad 36
		"000001010",  --localidad 37 
		"000001010",  --localidad 38  
		"000001010",  --localidad 39
		--vacios
		"010000100",  --localidad 40
		"010000100",  --localidad 41
		"010000100",  --localidad 42 
		"010000100",  --localidad 43
		"100000100",  --localidad 44 
		"100000100",  --localidad 45 
		"100000100",  --localidad 46  
		"100000100",  --localidad 47
		"010000100",  --localidad 48
		"010000100",  --localidad 49
		"010000100",  --localidad 50 
		"010000100",  --localidad 51 
		"100000100",  --localidad 52 
		"100000100",  --localidad 53 
		"100000100",  --localidad 54  
		"100000100",  --localidad 55
		"010000100",  --localidad 56
		"010000100",  --localidad 57
		"010000100",  --localidad 58 
		"010000100",  --localidad 59 
		"100000100",  --localidad 60 
		"100000100",  --localidad 61 
		"100000100",  --localidad 62  
		"100000100"); --localidad 63 
	
begin

	data <= memoria(to_integer(unsigned(addr)));

end Behavioral;

