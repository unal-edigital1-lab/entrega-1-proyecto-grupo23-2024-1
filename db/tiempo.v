`timescale 1ns / 1ps
module tiempo (

  input Acelerar,
  input clk,
  input rst,
  output led,
  output seg,
  output hora
  
  );
  

  reg [32:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[32];
assign led =enable;
always @(posedge clk) begin
  if(rst==1) begin
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1;
	end
end
 reg [17:0] count =0;
 always @(posedge led) begin
   if (rst==1)begin
	  count<=0;
	end
	else begin
	  count<=count+1;
	
	end
 
 
 
 
 
 end
 
  

endmodule
