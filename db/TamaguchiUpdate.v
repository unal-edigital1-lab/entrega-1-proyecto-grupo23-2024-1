module TamaguchiUpdate #(parameter RESOLUTION = 220*176, parameter PIXEL_SIZE = 16)(
        input wire clk, //50
        input wire rst,
        output wire spi_mosi,
        output wire spi_cs,
        output wire spi_sck,
        output wire spi_dc
    );

    reg clk_out;
    wire clk_input_data;
	 reg [6:0] contador;
    reg [PIXEL_SIZE-1:0] current_pixel;
	

    reg [$clog2(RESOLUTION)-1:0] pixel_counter;
    reg transmission_done;

    initial begin
        current_pixel <= 'b0;
        pixel_counter <= 'b0;
        transmission_done <= 'b0; 
		  clk_out <= 'b0;
		  contador <= 0;
    end

	 always@(posedge clk)begin
		clk_out <= !clk_out;
	 end
    

    always @(posedge clk_input_data or posedge rst) begin
        if (rst) begin
            pixel_counter <= 'b0;
            current_pixel <= 'b0;
            transmission_done <= 'b0; 
        end else if (!transmission_done) begin
            current_pixel <= 16'b1111100000000000;
            pixel_counter <= pixel_counter + 'b1;
            if (pixel_counter == RESOLUTION-1) begin
                transmission_done <= 'b1; 
            end
        end
    end

    ili9225_controller ili9225(
		.clk(clk_out), 
		.rst(rst),
        .frame_done(transmission_done), 
        .input_data(current_pixel),
        .spi_mosi(spi_mosi),
		.spi_sck(spi_sck), 
        .spi_cs(spi_cs), 
        .spi_dc(spi_dc),
        .data_clk(clk_input_data)
    );

endmodule