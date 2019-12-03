library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PONG is
  port ( CLK_50MHz: in std_logic;
         VS: out std_logic;
			HS: out std_logic;
			RED: out std_logic_vector(2 downto 0);
			GREEN: out std_logic_vector(2 downto 0);
			BLUE: out std_logic_vector(2 downto 1);
			RESET: in std_logic;
			G_RESET: in std_logic;
			P1_UP: in std_logic;
			P2_UP: in std_logic;
			P1_DOWN: in std_logic;
			P2_DOWN: in std_logic;
			PAUSE : in std_logic;
			LEVEL : in std_logic_vector(1 downto 0);
			ANODES: out std_logic_vector(3 downto 0);
			DISPLAY: out std_logic_vector(6 downto 0)
  );
end PONG;

architecture Behavioral of PONG is
  -- VGA Definitions starts
  constant HDisplayArea: integer:= 640; -- horizontal display area
  constant HLimit: integer:= 800; -- maximum horizontal amount (limit)
  constant HFrontPorch: integer:= 16; -- h. front porch
  constant HBackPorch: integer:= 48;	-- h. back porch
  constant HSyncWidth: integer:= 96;	-- h. pulse width
  constant VDisplayArea: integer:= 480; -- vertical display area
  constant VLimit: integer:= 521; -- maximum vertical amount (limit)
  constant VFrontPorch: integer:= 10;	-- v. front porch
  constant VBackPorch: integer:= 29;	-- v. back porch
  constant VSyncWidth: integer:= 2;	-- v. pulse width      
  
  signal Clk_25MHz: std_logic := '0';  
  signal HBlank, VBlank, Blank: std_logic := '0';
    
  signal CurrentHPos: std_logic_vector(10 downto 0) := (others => '0'); -- goes to 1100100000 = 800
  signal CurrentVPos: std_logic_vector(10 downto 0) := (others => '0'); -- goes to 1000001101 = 521
  signal ScanlineX, ScanlineY: std_logic_vector(10 downto 0);
  
  --Selecciona el nivel
  --signal level: std_logic_vector(2 downto 0) := (others => '0');
  signal speed: std_logic_vector(17 downto 0) := (others => '0');
  
  signal ColorOutput: std_logic_vector(7 downto 0);
  
  --signal flag: std_logic := '0';  
  -- VGA Definitions end
  
  --Cuadro
  signal SquareX: std_logic_vector(9 downto 0) := "0100110110";  
  signal SquareY: std_logic_vector(9 downto 0) := "0011100110";  
  signal SquareXMoveDir, SquareYMoveDir: std_logic := '0';
  constant SquareWidth: std_logic_vector(7 downto 0) := "00010100";
  constant SquareXmin: std_logic_vector(9 downto 0) := "0000000001";
  signal SquareXmax: std_logic_vector(9 downto 0) := "1010000000"-SquareWidth;
  constant SquareYmin: std_logic_vector(9 downto 0) := "0000000001";
  signal SquareYmax: std_logic_vector(9 downto 0) := "0111100000"-SquareWidth;
  signal ColorSelect: std_logic_vector(2 downto 0) := "001";
  signal Prescaler: std_logic_vector(17 downto 0) := (others => '0');

  --LeftBar Definition
  signal LeftBarX: std_logic_vector(9 downto 0) := "0000000000";  
  signal LeftBarY: std_logic_vector(9 downto 0) := "0010100110";  
  constant LeftBarWidth: std_logic_vector(7 downto 0) := "00010000";
  constant LeftBarHeight: std_logic_vector(7 downto 0) := "10010100";
  constant LeftBarXmin: std_logic_vector(9 downto 0) := "0000000001";
  signal LeftBarXmax: std_logic_vector(9 downto 0) := "1010000000"-LeftBarWidth;
  constant LeftBarYmin: std_logic_vector(9 downto 0) := "0000000001";
  signal LeftBarYmax: std_logic_vector(9 downto 0) := "0111100000"-LeftBarHeight;
  signal l_score_p1: std_logic_vector(3 downto 0) := "0000";
  signal r_score_p1: std_logic_vector(3 downto 0) := "0000";


  --RightBar Definition
  signal RightBarX: std_logic_vector(9 downto 0) := "1001101000";  
  signal RightBarY: std_logic_vector(9 downto 0) := "0010100110";  
  constant RightBarWidth: std_logic_vector(7 downto 0) := "00010000";
  constant RightBarHeight: std_logic_vector(7 downto 0) := "10010100";
  constant RightBarXmin: std_logic_vector(9 downto 0) := "0000000001";
  signal RightBarXmax: std_logic_vector(9 downto 0) := "1010000000"-RightBarWidth;
  constant RightBarYmin: std_logic_vector(9 downto 0) := "0000000001";
  signal RightBarYmax: std_logic_vector(9 downto 0) := "0111100000"-RightBarHeight;
  signal l_score_p2: std_logic_vector(3 downto 0) := "0000";
  signal r_score_p2: std_logic_vector(3 downto 0) := "0000";

  
  
  signal stop: std_logic := '0';
  
  signal prescaler_counter: std_logic_vector(16 downto 0) := (others => '0');
  signal counter : std_logic_vector(1 downto 0) := "00";
  signal r_anodes : std_logic_vector(3 downto 0) := "1111";

begin

  Generate25MHz: process (CLK_50MHz)
  begin
    if rising_edge(CLK_50MHz) then
	   Clk_25MHz <= not Clk_25MHz;
	 end if;
  end process Generate25MHz;
  
  PrescalerCounter: process(CLK_50Mhz, RESET)
  begin
	
	if RESET = '1' then
		Prescaler <= (others => '0');
		SquareX <= "0100110110";
		SquareY <= "0011100110";
		SquareXMoveDir <= '1';
		SquareYMoveDir <= '0';
		ColorSelect <= "001";
	   stop <= '0';
    elsif rising_edge(CLK_50Mhz) then
	   if G_RESET = '1' then
			Prescaler <= (others => '0');
			SquareX <= "0100110110";
			SquareY <= "0011100110";
			SquareXMoveDir <= '1';
			SquareYMoveDir <= '0';
			ColorSelect <= "001";
			stop <= '0';
			l_score_p1 <= "0000";
			r_score_p1 <= "0000";
			l_score_p2 <= "0000";
			r_score_p2 <= "0000";
		end if;
	 	if PAUSE = '0' and stop = '0' then
      Prescaler <= Prescaler + 1;
		case level is 
		   when "00" => speed <= "100100100111110000";
			when "01" => speed <="110000110101000000";
			when others => speed <= "111101000010010000";
		end case; 
      if Prescaler = speed then  -- Activated every 0,002 sec (2 msec)
  	     if SquareXMoveDir = '0' then
		    if SquareX < SquareXmax then
				SquareX <= SquareX + 1;		--sigue
				if SquareX = "1001101000" - SquareWidth then	--posible choque en 616.Está muy difícil hacerlo bien, prro
					if SquareY >= RightBarY AND SquareY <= RightBarY + RightBarHeight then --choque
						SquareXMoveDir <= '1';	--Cambia direccion
						ColorSelect <= ColorSelect(1 downto 0) & ColorSelect(2);
					else		--No choca
						SquareX <= SquareX + 1;	--Derrota inminente
					end if;
				end if;
		    else
			   if r_score_p1 = "1001" then
					r_score_p1 <= "0000";
					l_score_p1 <= l_score_p1 + 1;
				else
					r_score_p1 <= r_score_p1 + 1;
				end if;
 		      LeftBarX <= "0000000001";
				LeftBarY <= "0010100110";
				RightBarX <= "1001101000";
				RightBarY <= "0010100110";
				stop <= '1';
				--SquareXMoveDir <= '1';	--Pierde
				--Accion
		    end if;
	     else
		    if SquareX > SquareXmin then
				SquareX <= SquareX - 1;		--sigue
				if SquareX = SquareXmin + LeftBarWidth then	--posible choque
					if SquareY >= LeftBarY AND SquareY <= LeftBarY + LeftBarHeight then --choque
						SquareXMoveDir <= '0';	--Cambia direccion
						ColorSelect <= ColorSelect(1 downto 0) & ColorSelect(2);
					else		--No choca
						SquareX <= SquareX - 1;	--Derrota inminente
					end if;
				end if;
		    else
			    if r_score_p2 = "1001" then
					r_score_p2 <= "0000";
					l_score_p2 <= l_score_p2 + 1;
				 else
					r_score_p2 <= r_score_p2 + 1;
				 end if;
 		       LeftBarX <= "0000000001";
				 LeftBarY <= "0010100110";
				 RightBarX <= "1001101000";
				 RightBarY <= "0010100110";
				 stop <= '1';
				--SquareXMoveDir <= '0';	--Pierde
				--Accion
		    end if; 
		  end if;
		  
  	     if SquareYMoveDir = '0' then
		    if SquareY < SquareYmax then
		      SquareY <= SquareY + 1;
		    else
 		      SquareYMoveDir <= '1';
				ColorSelect <= ColorSelect(1 downto 0) & ColorSelect(2);
		    end if;
	     else
	       if SquareY > SquareYmin then
		      SquareY <= SquareY - 1;
		    else
		      SquareYMoveDir <= '0';
				ColorSelect <= ColorSelect(1 downto 0) & ColorSelect(2);
		    end if;	 
		  end if;

			--Left bar
			if P1_DOWN = '1' then
		    if LeftBarY < LeftBarYmax then
		      LeftBarY <= LeftBarY + 1;
		    end if;
			end if;
			if P1_UP = '1' then
		    if LeftBarY > LeftBarYmin then
		      LeftBarY <= LeftBarY - 1;
		    end if;
			end if;
			
			--Right bar
			if P2_DOWN = '1' then
		    if RightBarY < RightBarYmax then
		      RightBarY <= RightBarY + 1;
		    end if;
			end if;
			if P2_UP = '1' then
		    if RightBarY > RightBarYmin then
		      RightBarY <= RightBarY - 1;
		    end if;
			end if;
		  
		  Prescaler <= (others => '0');
		end if;
		end if;
	 end if;
  end process PrescalerCounter; 

  VGAPosition: process (Clk_25MHz, RESET)
  begin
    if RESET = '1' then
	   CurrentHPos <= (others => '0');
		CurrentVPos <= (others => '0');
    elsif rising_edge(CLK_25MHz) then
	   if CurrentHPos < HLimit-1 then
		  CurrentHPos <= CurrentHPos + 1;
		else
		  if CurrentVPos < VLimit-1 then
		    CurrentVPos <= CurrentVPos + 1;
		  else
		    CurrentVPos <= (others => '0'); -- reset Vertical Position
		  end if;
		  CurrentHPos <= (others => '0'); -- reset Horizontal Position
		end if;
	 end if;
  end process VGAPosition;

  -- Timing definition for HSync, VSync and Blank (http://tinyvga.com/vga-timing/640x480@60Hz)
     HS <= '0' when CurrentHPos < HSyncWidth else
	        '1';
	  
	  VS <= '0' when CurrentVPos < VSyncWidth else
	        '1';
	  
	  HBlank <= '0' when (CurrentHPos >= HSyncWidth + HFrontPorch) and (CurrentHPos < HSyncWidth + HFrontPorch + HDisplayArea) else
	           '1';
				  
	  VBlank <= '0' when (CurrentVPos >= VSyncWidth + VFrontPorch) and (CurrentVPos < VSyncWidth + VFrontPorch + VDisplayArea) else
	           '1';				  
	  
	  Blank <= '1' when HBlank = '1' or VBlank = '1' else
	           '0';
	  
	  ScanlineX <= CurrentHPos - HSyncWidth - HFrontPorch when Blank = '0' else
	               (others => '0');

	  ScanlineY <= CurrentVPos - VSyncWidth - VFrontPorch when Blank = '0' else
	               (others => '0');	

     RED <= ColorOutput(7 downto 5) when Blank = '0' else
            "000";	  
     GREEN <= ColorOutput(4 downto 2) when Blank = '0' else
            "000";				
     BLUE <= ColorOutput(1 downto 0) when Blank = '0' else
            "00";								
  
  ColorOutput <= "11100000" when ColorSelect(0) = '1' AND ScanlineX >= SquareX AND ScanlineY >= SquareY AND ScanlineX < SquareX+SquareWidth AND ScanlineY < SquareY+SquareWidth else          
                 "00011100" when ColorSelect(1) = '1' AND ScanlineX >= SquareX AND ScanlineY >= SquareY AND ScanlineX < SquareX+SquareWidth AND ScanlineY < SquareY+SquareWidth else          
					  "00000011" when ColorSelect(2) = '1' AND ScanlineX >= SquareX AND ScanlineY >= SquareY AND ScanlineX < SquareX+SquareWidth AND ScanlineY < SquareY+SquareWidth else          					  
					  "11111111" when ScanlineX >= LeftBarX AND ScanlineY >= LeftBarY AND ScanlineX < LeftBarX+LeftBarWidth AND ScanlineY < LeftBarY+LeftBarHeight else
					  "11111111" when ScanlineX >= RightBarX AND ScanlineY >= RightBarY AND ScanlineX < RightBarX+RightBarWidth AND ScanlineY < RightBarY+RightBarHeight else
					  "00000000";

     SquareXmax <= "1010000000"-SquareWidth;
     SquareYmax <= "0111100000"-SquareWidth;	


multiplex:process(counter,l_score_p1,r_score_p1,l_score_p2,r_score_p2)
begin

	case counter is
		when "00" => r_anodes <= "1110";
		when "01" => r_anodes <= "1101";
		when "10" => r_anodes <= "1011";
		when "11" => r_anodes <= "0111";
		when others => r_anodes <= "1111";
	end case;
	case r_anodes is
		when "1011" => 
			  case r_score_p1 is
					when "0000" => DISPLAY <= "0000001"; -- 0
					when "0001" => DISPLAY <= "1001111"; -- 1
					when "0010" => DISPLAY <= "0010010"; -- 2
					when "0011" => DISPLAY <= "0000110"; -- 3
					when "0100" => DISPLAY <= "1001100"; -- 4
					when "0101" => DISPLAY <= "0100100"; -- 5
					when "0110" => DISPLAY <= "0100000"; -- 6
					when "0111" => DISPLAY <= "0001111"; -- 7
					when "1000" => DISPLAY <= "0000000"; -- 8
					when others => DISPLAY <= "0000100"; -- 9
				end case;
		
		when "1110" => 
				 case r_score_p2 is
					when "0000" => DISPLAY <= "0000001"; -- 0
					when "0001" => DISPLAY <= "1001111"; -- 1
					when "0010" => DISPLAY <= "0010010"; -- 2
					when "0011" => DISPLAY <= "0000110"; -- 3
					when "0100" => DISPLAY <= "1001100"; -- 4
					when "0101" => DISPLAY <= "0100100"; -- 5
					when "0110" => DISPLAY <= "0100000"; -- 6
					when "0111" => DISPLAY <= "0001111"; -- 7
					when "1000" => DISPLAY <= "0000000"; -- 8
					when others => DISPLAY <= "0000100"; -- 9
				end case;
		
		
		when "0111" => 
				 case l_score_p1 is
					when "0000" => DISPLAY <= "0000001"; -- 0
					when "0001" => DISPLAY <= "1001111"; -- 1
					when "0010" => DISPLAY <= "0010010"; -- 2
					when "0011" => DISPLAY <= "0000110"; -- 3
					when "0100" => DISPLAY <= "1001100"; -- 4
					when "0101" => DISPLAY <= "0100100"; -- 5
					when "0110" => DISPLAY <= "0100000"; -- 6
					when "0111" => DISPLAY <= "0001111"; -- 7
					when "1000" => DISPLAY <= "0000000"; -- 8
					when others => DISPLAY <= "0000100"; -- 9
				end case;
		
		
		when "1101" => 
				 case l_score_p2 is
					when "0000" => DISPLAY <= "0000001"; -- 0
					when "0001" => DISPLAY <= "1001111"; -- 1
					when "0010" => DISPLAY <= "0010010"; -- 2
					when "0011" => DISPLAY <= "0000110"; -- 3
					when "0100" => DISPLAY <= "1001100"; -- 4
					when "0101" => DISPLAY <= "0100100"; -- 5
					when "0110" => DISPLAY <= "0100000"; -- 6
					when "0111" => DISPLAY <= "0001111"; -- 7
					when "1000" => DISPLAY <= "0000000"; -- 8
					when others => DISPLAY <= "0000100"; -- 9
				end case;
		when others => DISPLAY <= "1111111";
		
	end case;
end process;
	 
count:process(CLK_50MHz,counter) 
begin 
	if rising_edge(CLK_50MHz) then
		prescaler_counter <= prescaler_counter + 1;
		if prescaler_counter = "11000011010100000" then 
			counter <= counter + 1;
			prescaler_counter <= (others => '0');
		end if;
	end if;
end process;

anodes <= r_anodes;
 

end Behavioral;