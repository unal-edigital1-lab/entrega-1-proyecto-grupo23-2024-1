`timescale 1s / 100ms
module mod3_contador(
  input wire cnt,
  input wire clk,
  input wire clr,
  output reg[1:0] Q
);

  wire[1:0] T;
  wire[1:0] X;
  
  assign T[1]= cnt & (Q[1]| Q[0]);
  assign T[0]= cnt & ~Q[1];
  
  
  assign X[1] = T[1] ^ Q[1];
  assign X[0] = T[0] ^ Q[0];
  
  
  always @(posedge clk, negedge clr)begin
    if(clr==0)
	   Q <= 0;
	 else 
	   Q <= X;
  
  
  
  end
  
  
  
  
  
  
  
  
endmodule