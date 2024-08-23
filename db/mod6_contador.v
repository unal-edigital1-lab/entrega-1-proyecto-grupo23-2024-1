`timescale 1s / 100ms
module mod6_contador(
  input wire cnt,
  input wire clk,
  input wire clr,
  output reg[2:0] Q
  
);

  wire[2:0] T;
  wire [2:0] X;
  
  
  
  assign T[2]= cnt & Q[0] & Q[2] | cnt & Q[0] & Q[1];
  assign T[1]= cnt & ~Q[2] & Q[0];
  assign T[0]=cnt;
  
  
  assign X[2] = T[2] ^ Q[2];
  assign X[1]= T[1] ^ Q[1];
  assign X[0]= T[0] ^ Q[0];
  
  always @(posedge clk, negedge clr)begin
    if (clr==0)
	   Q <= 0;
	 else
	   Q <= X;
  
  
  
  end
  
  
  
  
endmodule  