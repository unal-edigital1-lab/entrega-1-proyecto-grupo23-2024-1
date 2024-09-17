module TamaguchiUpdate_tb;

    // Entradas
    reg clk;
    reg rst;

    // Salidas
    wire spi_mosi;
    wire spi_cs;
    wire spi_sck;
    wire spi_dc;
    wire sckotro;

    // Instancia del módulo bajo prueba (DUT)
    TamaguchiUpdate uut (
        .clk(clk),
        .rst(rst),
        .spi_mosi(spi_mosi),
        .spi_cs(spi_cs),
        .spi_sck(spi_sck),
        .spi_dc(spi_dc),
        .sckotro(sckotro)
    );

    // Generación de reloj de 50 MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50 MHz -> periodo de 20 ns
    end

    // Estímulos para el testbench
    initial begin
        // Inicialización
        rst = 1;

        // Espera algunos ciclos
        #30;

        // Desactiva el reset
        rst = 0;

        // Simulación de la actualización de la pantalla
        #2000;

        // Termina la simulación
        $finish;
    end

    // Monitor para ver las señales
    initial begin
        $monitor("Time = %d : spi_mosi = %b, spi_cs = %b, spi_sck = %b, spi_dc = %b, sckotro = %b", 
                 $time, spi_mosi, spi_cs, spi_sck, spi_dc, sckotro);
    end

endmodule