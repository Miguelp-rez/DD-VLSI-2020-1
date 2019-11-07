-- 1. Bibliotecas
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

-- 2. Entidad
-- Declaro entradas y salidas fisicas
-- 2. Entidad
-- Declaro entradas y salidas fisicas
entity MAIN is
    Port (
			 SWITCH:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 LEDS  :OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
			 CLK   :IN STD_LOGIC;
			 RX    :IN STD_LOGIC;	--Pin de recepción de RS232
			 TX    :OUT STD_LOGIC);	--Pin de transmisión de RS232
			 
end MAIN;

-- 3. Arquitectura
architecture xx of MAIN is
	Signal rx_in_s : std_logic ;		
	Signal datain_s : std_logic_vector(7 downto 0);
	Signal dout_s : std_logic_vector(7 downto 0):= "00110000";
	Signal tx_ini_s : std_logic := '1' ;
	Signal tx_fin_s : std_logic;
	component RS232 is
	generic	(	FPGA_CLK :			INTEGER := 50000000;	--FRECUENCIA DEL FPGA 
					BAUD_RS232 :		INTEGER := 9600		--BAUDIOS
				);
	port	(	CLK : 		in std_logic ;			--Reloj de FPGA
				RX :			in std_logic ;			--Pin de recepción de RS232
				TX_INI :		in std_logic ;			--Debe ponerse a '1' para inciar transmisión
				TX_FIN :		out std_logic ;		--Se pone '1' cuando termina la transmisión
				TX :			out std_logic ;		--Pin de transmisión de RS232
				RX_IN :		out std_logic ;		--Se pone a '1' cuando se ha recibido un Byte. Solo dura un 
															--Ciclo de reloj
				DATAIN :		in std_logic_vector(7 downto 0); --Puerto de datos de entrada para transmisión
				DOUT :		out std_logic_vector(7 downto 0) --Puerto de datos de salida para recepción
			);
	end component;
	
	begin
		U1: RS232 generic map(
				FPGA_CLK => 50000000,
				BAUD_RS232 => 9600)
			port map(
				CLK => CLK,
				RX => RX,
				TX_INI => tx_ini_s,
				TX_FIN => tx_fin_s,
				TX => TX,
				RX_IN => rx_in_s,
				DATAIN => datain_s,
				DOUT => dout_s);
	
		process(CLK, rx_in_s, dout_s)
			begin
				if(rx_in_s = '1') then
					LEDS <= std_logic_vector(unsigned(dout_s) - x"30");
				end if;
		end process;
		
		process(CLK, datain_s)
			begin
				if tx_fin_s = '0' then
					tx_ini_s <= '1';
					datain_s(7 downto 4) <= "0011";
					datain_s(3 downto 0) <= SWITCH;
					--datain_s <= std_logic_vector(unsigned(datain_s) + x"30");
				else
					tx_ini_s <= '0';
				end if;
		end process;

end xx;