module fsm (
    input rst,
    input comer,
    input jugar,
    input descansar,
    input test,
    input clk,
	 input acelerar,
    output reg [2:0] estado
);

wire [5:0]sec;
wire [5:0] min;
wire [4:0] hour;

tiempo mi_tiempo(.clk(clk),.rst(rst),.sec(sec),.min(min),.hour(hour),.A(acelerar));
    
    parameter MUERTO = 3'b000;
    parameter FELIZ1 = 3'b001;
    parameter FELIZ2 = 3'b010;
    parameter FELIZ3 = 3'b011;
    parameter FELIZ4 = 3'b100;
    parameter ABURRIDO1 = 3'b101;
    parameter ABURRIDO2 = 3'b110;
    parameter ABURRIDO3 = 3'b111;
    parameter TRISTE1 = 3'b000;
    parameter TRISTE2 = 3'b001;
    parameter TRISTE3 = 3'b010;
    parameter NORMAL1 = 3'b011;
    parameter NORMAL2 = 3'b100;
    parameter NORMAL3 = 3'b101;
    parameter ENFERMO = 3'b110;

    reg [2:0] current_state, next_state;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= MUERTO;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        next_state = current_state;

        case (current_state)
            MUERTO: begin
                if (test) begin
                    next_state = NORMAL1;
                end
            end

            FELIZ1: begin
                if (comer) begin
                    next_state = FELIZ2;
                end else if (jugar) begin
                    next_state = FELIZ3;
                end
            end
            FELIZ2: begin
                if (comer) begin
                    next_state = FELIZ3;
                end else if (jugar) begin
                    next_state = FELIZ4;
                end
            end
            FELIZ3: begin
                if (comer) begin
                    next_state = FELIZ4;
                end else if (descansar) begin
                    next_state = NORMAL1;
                end
            end
            FELIZ4: begin
                if (!comer && !jugar) begin
                    next_state = NORMAL1;
                end
            end

            ABURRIDO1: begin
                if (!jugar) begin
                    next_state = ABURRIDO2;
                end
            end
            ABURRIDO2: begin
                if (!jugar) begin
                    next_state = ABURRIDO3;
                end
            end
            ABURRIDO3: begin
                if (comer) begin
                    next_state = FELIZ1;
                end else if (descansar) begin
                    next_state = TRISTE1;
                end
            end

            TRISTE1: begin
                if (!comer) begin
                    next_state = TRISTE2;
                end
            end
            TRISTE2: begin
                if (!comer) begin
                    next_state = TRISTE3;
                end else if (jugar) begin
                    next_state = FELIZ1;
                end
            end
            TRISTE3: begin
                if (!comer) begin
                    next_state = MUERTO;
                end else if (jugar) begin
                    next_state = FELIZ1;
                end
            end

            NORMAL1: begin
                if (comer) begin
                    next_state = FELIZ1;
                end else if (!jugar) begin
                    next_state = ABURRIDO1;
                end
            end
            NORMAL2: begin
                if (!jugar) begin
                    next_state = ABURRIDO2;
                end
            end
            NORMAL3: begin
                if (descansar) begin
                    next_state = ENFERMO;
                end
            end

            ENFERMO: begin
                if (test) begin
                    next_state = NORMAL1;
                end else if (!comer && !jugar && !descansar) begin
                    next_state = MUERTO;
                end
            end

            default: next_state = MUERTO;
        endcase
    end

   
    always @(posedge clk) begin
        estado <= current_state;
    end

endmodule

