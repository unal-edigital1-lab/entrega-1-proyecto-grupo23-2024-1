`timescale 1ns / 1ps
module tiempo (

  input Acelerar,
  input clk,
  input rst,
  output led
  
  
  
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
   
  
  

endmodule