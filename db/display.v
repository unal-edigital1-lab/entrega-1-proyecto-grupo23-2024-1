`timescale 1ns / 1ps
module display(
    input clk,
    output [0:6] sseg,
    output reg [4:0] an,
	 output reg [15:0] num,
	 input rst,
	 output led
    );



reg [3:0]bcd=0;
//wire [15:0] num=16'h4321;


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
			an<=5'b11111; 
		end else begin 
			count<= count+1; 
			case (count) 
				3'h0: begin bcd <= num % 10;   an<=5'b11110; end 
				3'h1: begin bcd <= (num / 10) % 10;   an<=5'b11101; end 
				3'h2: begin bcd <= (num / 100) % 10;  an<=5'b11011; end 
				3'h3: begin bcd <= (num / 1000) % 10; an<=5'b10111; end 
				3'h4: begin bcd <= (num / 10000) % 10; an<=5'b01111; end 
			endcase
		end
end

endmodule
