module ControlImagen (
 input clk,
 input rst,
 input [2:0]hambre,
 input [2:0]diversion,
 input [2:0]energia,
 input salud,
 input [2:0]state,
 input modo,
 output wire spi_mosi,
 output wire spi_cs,
 output wire spi_sck,
 output wire spi_dc,
 output wire spi_reset
);

wire clk_input_data;

reg [15:0] current_pixel;
reg transmission_done;
reg [15:0] contador_pixel;



wire [7:0]modulex;
wire [4:0]x;
wire [4:0]y;

wire [7:0] c_pixel_imagen;
wire [15:0] pixel_actual;


assign modulex = contador_pixel%220;
assign x = modulex/11;
assign y = contador_pixel/2420;
assign c_pixel_imagen = x - 1 + (y - 2)*13;

initial begin
	contador_pixel <= 0;
	transmission_done <= 0;
	current_pixel <= 16'hFFFF;

end

Contol_ili ili9225(
		.clk(clk), 
		.rst(rst),
      .frame_done(transmission_done), 
      .input_data(current_pixel),
      .spi_mosi_out(spi_mosi),
		.spi_sck_out(spi_sck), 
      .spi_cs_out(spi_cs), 
      .spi_dc_out(spi_dc),
      .data_clk(clk_input_data),
		.spi_reset(spi_reset)
);

Memoria ROMmemory (
		.clk(clk), 
		.rst(rst),
		.adress(state),
		.contador_pixel(c_pixel_imagen),
		.pixel(pixel_actual)
);






always @(posedge clk_input_data, posedge rst)begin
	if(rst)begin
		transmission_done <= 0;
			contador_pixel <= 0;
			current_pixel <= 16'hFFFF;
	end
	else begin
			if(contador_pixel == 38719)begin
				contador_pixel <= 0;
				current_pixel <= 16'hFFFF;
				transmission_done <= 1;
			end
			else begin
				if(!transmission_done)begin
				case (x)
					0: begin current_pixel <= 16'hFFFF; end
					14:begin current_pixel <= 16'hFFFF; end
					15:begin current_pixel <= 16'hFFFF; end
					16:begin
						if(salud)begin
							current_pixel <= 16'hF800;
						end
						else begin
							current_pixel <= (y>11)?16'hF800:16'hFFFF;
						end
					end
					17: begin
						if(y < 4)begin
							current_pixel <= (hambre > 3)? 16'hFB20:16'hFFFF;
						end
						else begin
							if (y<8)begin
								current_pixel <= (hambre > 2)? 16'hFB20:16'hFFFF;
							end	
							else begin
								if(y < 12)begin
									current_pixel <= (hambre > 1)? 16'hFB20:16'hFFFF;
								end
								else begin
									current_pixel <= (hambre > 0)? 16'hFB20:16'hFFFF;
								end
							end
						end
					end
					18: begin
						if(y < 4)begin
							current_pixel <= (energia > 3)? 16'h07E0:16'hFFFF;
						end
						else begin
							if (y<8)begin
								current_pixel <= (energia > 2)? 16'h07E0:16'hFFFF;
							end	
							else begin
								if(y < 12)begin
									current_pixel <= (energia > 1)? 16'h07E0:16'hFFFF;
								end
								else begin
									current_pixel <= (energia > 0)? 16'h07E0:16'hFFFF;
								end
							end
						end
					end
					19:begin
						if(y < 4)begin
							current_pixel <= (diversion > 3)? 16'hFFE0:16'hFFFF;
						end
						else begin
							if (y<8)begin
								current_pixel <= (diversion > 2)? 16'hFFE0:16'hFFFF;
							end	
							else begin
								if(y < 12)begin
									current_pixel <= (diversion > 1)? 16'hFFE0:16'hFFFF;
								end
								else begin
									current_pixel <= (diversion > 0)? 16'hFFE0:16'hFFFF;
								end
							end
						end
					end
					default: begin
						if(x == 7 & y == 0)begin
							current_pixel <=(modo)? 16'h001F: 16'hFFFF;
						end
						else begin
							if(x > 0 & x <14)begin
								if (y == 0 | y == 1 | y == 15)begin
									current_pixel <= 16'hFFFF;
								end
								else begin
									current_pixel <= pixel_actual;
								end
							end
						end
					end	
				endcase
				contador_pixel <= contador_pixel + 1;
				end
				else begin
						transmission_done <= 0;
						current_pixel <= 16'hFFFF;
				end
		end		
	end
end

endmodule

	 
	 
	 