`timescale 1ns/1ps

module tiempo (
    input wire clk,        
    input wire rst,        
    output reg [5:0] sec,  
    output reg [5:0] min,  
    output reg [4:0] hour,
    input wire A
);

    
    localparam FRECUENCIA_BASE = 50000000;  
    localparam FRECUENCIA_A = FRECUENCIA_BASE / 1000;  
    localparam MAX_COUNT_BASE = FRECUENCIA_BASE - 1;
    localparam MAX_COUNT_A = FRECUENCIA_A - 1;

    reg [25:0] count;  
    reg [25:0] max_count;

    
    always @* begin
        if (A) begin
            max_count = MAX_COUNT_A;
        end else begin
            max_count = MAX_COUNT_BASE;
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            sec <= 0;   
            min <= 0;   
            hour <= 0; 
        end else begin
            if (count == max_count) begin
                count <= 0;
                if (sec == 59) begin
                    sec <= 0;
                    if (min == 59) begin
                        min <= 0;
                        if (hour == 23) begin
                            hour <= 0;
                        end else begin
                            hour <= hour + 1;
                        end
                    end else begin
                        min <= min + 1;
                    end
                end else begin
                    sec <= sec + 1;
                end
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule


  