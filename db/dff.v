`timescale 1s / 100ms

module dff(
  input wire d,
  input wire clk,
  input wire clear,
  output reg q,
  output reg q_neg


);
  
  always @(posedge clk, negedge clear) begin
  
  
    if(clear==0)
	   q<=0;
		
	  else 
	    q<=d;
		 q_neg<=~d;
  
  
  
  
  
  
  
  
  end



 

endmodule