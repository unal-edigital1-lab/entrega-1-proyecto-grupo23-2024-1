`timescale 1s / 100ms

module dff(
  input wire d,
  input wire clk,
  input wire clear,
  output reg q,
  output reg q_neg


);
  
  always @(posedge clk, negedge clear) begin
  
  
    if(clear==0)begin
	   q<=0;
		q_neg <= 1;
		
	  end else begin 
	    q<=d;
		 q_neg<=~d;
		 end
  
  end



 

endmodule