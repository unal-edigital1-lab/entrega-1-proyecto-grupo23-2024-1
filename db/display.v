`timescale 1ns / 1ps
module display(
    input clk,
    output [0:6] sseg,
    output reg [5:0] an,
	 input rst_neg,
	 output led
    );

wire rst = ~rst_neg;
reg [3:0]bcd=0;
//wire [15:0] num=16'h4321;
wire [5:0]sec;
wire [5:0] min;
wire [4:0] hour;

tiempo mi_tiempo(.clk(clk),.rst(rst),.sec(sec),.min(min),.hour(hour));
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));

reg [26:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[16];
assign led =enable;
always @(posedge clk) begin
  if(rst==1) begin
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1;
	end
end

reg [2:0] count =0;
always @(posedge enable) begin
		if(rst==1) begin
			count<= 0;
			an<=6'b111111; 
		end else begin 
			count<= count+1; 
			case (count) 
				3'h0: begin bcd <= sec % 10;   an<=6'b111110; end 
				3'h1: begin bcd <= (sec / 10) % 10;   an<=6'b111101; end 
				3'h2: begin bcd <= min % 10;  an<=6'b111011; end 
				3'h3: begin bcd <= (min / 10) % 10; an<=6'b110111; end 
				3'h4: begin bcd <= hour % 10; an<=6'b101111; end
			   3'h5: begin bcd <= (hour / 10) % 10; an<=6'b011111; end 	
			endcase
		end
end

endmodule