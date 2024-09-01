`timescale 1s / 100ms
module bcd_contador(
  input wire cnt,
  input wire clk,
  input wire clr,
  output reg[3:0] Q
);  
  wire[3:0] T;
  wire[3:0] X;
  
  assign T[3]= (Q[3] & Q[0] & cnt) | (Q[2] & Q[1] & Q[0] & cnt);
  assign T[2] = Q[1] & Q[0] & cnt;
  assign T[1]= ~Q[3] & Q[0] & cnt;
  assign T[0] = cnt;
  
  assign X[3] = T[3] ^ Q[3];
  assign X[2] = T[2] ^ Q[2];
  assign X[1] = T[1] ^ Q[1];
  assign X[0] = T[0] ^ Q[0];
  
  always @(posedge clk, negedge clr )begin
    if (clr==0)
	   Q <= 0;
	 else
	   Q <= X;
  
  
  
  end
  
endmodule