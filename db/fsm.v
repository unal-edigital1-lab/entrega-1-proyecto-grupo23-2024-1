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

wire [5:0] sec;
wire [5:0] min;
wire [4:0] hour;

tiempo mi_tiempo(.clk(clk), .rst(rst), .sec(sec), .min(min), .hour(hour), .A(acelerar));

    parameter MUERTO = 3'b000;
    parameter FELIZ = 3'b001;
    parameter ABURRIDO = 3'b010;
    parameter TRISTE = 3'b011;
    parameter NORMAL = 3'b100;
    parameter ENFERMO = 3'b101;
    parameter CANSADO = 3'b110;
    parameter HAMBRIENTO = 3'b111;

    reg [2:0] current_state, next_state;
    reg [4:0] ultima_actividad;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= NORMAL;
            ultima_actividad <= hour;
        end else begin
            current_state <= next_state;
            if (comer || jugar || descansar) begin
                ultima_actividad <= hour;
            end
        end
    end

    always @(*) begin
        next_state = current_state;

        case (current_state)
            MUERTO: begin
                if (comer || jugar || descansar) begin
                    next_state = NORMAL;
                end
            end

            FELIZ: begin
                if (hour - ultima_actividad > 2) begin
                    next_state = ABURRIDO;
                end else if (descansar) begin
                    next_state = CANSADO;
                end
            end

            ABURRIDO: begin
                if (jugar) begin
                    next_state = FELIZ;
                end else if (hour - ultima_actividad > 4) begin
                    next_state = TRISTE;
                end else if (descansar) begin
                    next_state = CANSADO;
                end
            end

            TRISTE: begin
                if (jugar) begin
                    next_state = FELIZ;
                end else if (hour - ultima_actividad > 6) begin
                    next_state = MUERTO;
                end
            end

            NORMAL: begin
                if (comer) begin
                    next_state = FELIZ;
                end else if (!jugar) begin
                    next_state = ABURRIDO;
                end else if (descansar) begin
                    next_state = CANSADO;
                end
            end

            ENFERMO: begin
                if (hour - ultima_actividad > 3) begin
                    next_state = MUERTO;
                end
            end

            CANSADO: begin
                if (comer) begin
                    next_state = HAMBRIENTO;
                end else if (hour - ultima_actividad > 2) begin
                    next_state = MUERTO;
                end
            end

            HAMBRIENTO: begin
                if (comer) begin
                    next_state = NORMAL;
                end else if (hour - ultima_actividad > 3) begin
                    next_state = MUERTO;
                end
            end

            default: next_state = NORMAL;
        endcase
    end

    always @(posedge clk) begin
        estado <= current_state;
    end

endmodule


