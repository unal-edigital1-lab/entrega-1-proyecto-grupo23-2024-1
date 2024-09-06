module fsm (
    input rst,
    input comer,
    input jugar,
    input descansar,
    input test,
    input clk,
    input acelerar,
    output reg [1:0] estado
);

wire [5:0] sec;
wire [5:0] min;
wire [4:0] hour;

tiempo mi_tiempo(.clk(clk), .rst(rst), .sec(sec), .min(min), .hour(hour), .A(acelerar));

reg [2:0] tiempo;
reg [1:0] state, nextstate;
parameter  muy_hambriento = 2'b00;
parameter  hambriento     = 2'b01;
parameter  satisfecho     = 2'b10;
parameter  lleno          = 2'b11;

always @(posedge clk or posedge rst)
    if (rst)
        tiempo <= 0;
    else if (tiempo == 4)
        tiempo <= 0;
    else
        tiempo <= tiempo + 1;

always @(posedge clk or posedge rst)
    if (rst)
        state <= satisfecho;
    else
        state <= nextstate;

always @(*) begin
    nextstate = state;  

    case(state)
        muy_hambriento: begin
            if (comer)
                nextstate = hambriento;
            else if (tiempo == 4)
                nextstate = muy_hambriento;
        end

        hambriento: begin
            if (comer)
                nextstate = satisfecho;
            else if (tiempo == 4)
                nextstate = muy_hambriento;
        end

        satisfecho: begin
            if (comer)
                nextstate = lleno;
            else if (tiempo == 4)
                nextstate = hambriento;
        end

        lleno: begin
            if (comer)
                nextstate = lleno;
            else if (tiempo == 4)
                nextstate = satisfecho;
        end
    endcase
end

always @(posedge clk or posedge rst)
    if (rst)
        estado <= satisfecho;
    else
        estado <= state;

endmodule


