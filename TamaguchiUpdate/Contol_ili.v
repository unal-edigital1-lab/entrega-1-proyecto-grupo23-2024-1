module controlador_ili9225(
        input  wire clk,    
        input  wire rst,
        input  wire [15:0] input_data, 
        input  wire frame_done, 
        output wire spi_mosi,
        output wire spi_sck,
        output wire spi_cs,
        output wire spi_dc,
        output wire data_clk,
		  output reg spi_reset
    );
	 
	 
localparam DELAY_10ms = 62500;
localparam DELAY_60ms = 375000;
localparam DELAY_50ms = 312500;
localparam DELAY_40ms = 250000;

reg[15:0] spi_data;
reg available_data;
reg data_byte_flag;

reg[3:0]state;

localparam START_RESET = 0;
localparam WAIT = 1;
localparam SEND_INIT_1 = 2;
localparam SEND_INIT_2 = 3;
localparam SEND_INIT_3 = 4;
localparam SEND_INIT_4 = 5;
localparam SEND_ADRESS = 6;
localparam FRAME_LOOP = 7;
localparam END = 8;
localparam WAIT_FRAME = 9;

reg[8:0] INIT_SEQ_1 [0:19];
reg[8:0] INIT_SEQ_2 [0:19];
reg[8:0] INIT_SEQ_3 [0:3];
reg[8:0] INIT_SEQ_4 [0:127];
reg[8:0] ADRESS_SEQ [0:33];
reg[8:0] END_SEQ[0:15];

reg [7:0] config_counter;
reg [18:0] delay_counter;

spi_master spi(
		.clk(clk), 
        .rst(rst),
        .spi_mosi(spi_mosi),
		.spi_sck(spi_sck), 
        .spi_cs(spi_cs), 
        .spi_dc(spi_dc), 
		.input_data(spi_data),
        .available_data(available_data),
        .idle(idle)
    );
	 
initial begin
        state <= START_RESET;
        config_counter <= 'b0;
        spi_data <= 'b0;
        delay_counter <= 'b0;
        available_data <= 'b0;
        data_byte_flag <= 1'b1;
end
	 
initial begin
		  INIT_SEQ_1 [0] = {1'b0, 8'h00};
        INIT_SEQ_1 [1] = {1'b0, 8'h10};
        INIT_SEQ_1 [2] = {1'b1, 8'h00};                     
        INIT_SEQ_1 [3] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [4] = {1'b0, 8'h00};
        INIT_SEQ_1 [5] = {1'b0, 8'h11};  
        INIT_SEQ_1 [6] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [7] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [8] = {1'b0, 8'h00};
        INIT_SEQ_1 [9] = {1'b0, 8'h12};
        INIT_SEQ_1 [10] = {1'b1, 8'h00};
        INIT_SEQ_1 [11] = {1'b1, 8'h00};
        INIT_SEQ_1 [12] = {1'b0, 8'h00};
        INIT_SEQ_1 [13] = {1'b0, 8'h13};
        INIT_SEQ_1 [14] = {1'b1, 8'h00};
        INIT_SEQ_1 [15] = {1'b1, 8'h00}; 
        INIT_SEQ_1 [16] = {1'b0, 8'h00};
        INIT_SEQ_1 [17] = {1'b0, 8'h14};
        INIT_SEQ_1 [18] = {1'b1, 8'h00};   
        INIT_SEQ_1 [19] = {1'b1, 8'h00};
	
		  INIT_SEQ_2 [0] = {1'b0, 8'h00};
        INIT_SEQ_2 [1] = {1'b0, 8'h11};
        INIT_SEQ_2 [2] = {1'b1, 8'h00};                     
        INIT_SEQ_2 [3] = {1'b1, 8'h18}; 
        INIT_SEQ_2 [4] = {1'b0, 8'h00};
        INIT_SEQ_2 [5] = {1'b0, 8'h12};  
        INIT_SEQ_2 [6] = {1'b1, 8'h61}; 
        INIT_SEQ_2 [7] = {1'b1, 8'h21}; 
        INIT_SEQ_2 [8] = {1'b0, 8'h00};
        INIT_SEQ_2 [9] = {1'b0, 8'h13};
        INIT_SEQ_2 [10] = {1'b1, 8'h00};
        INIT_SEQ_2 [11] = {1'b1, 8'h6F};
        INIT_SEQ_2 [12] = {1'b0, 8'h00};
        INIT_SEQ_2 [13] = {1'b0, 8'h14};
        INIT_SEQ_2 [14] = {1'b1, 8'h49};
        INIT_SEQ_2 [15] = {1'b1, 8'h6F}; 
        INIT_SEQ_2 [16] = {1'b0, 8'h00};
        INIT_SEQ_2 [17] = {1'b0, 8'h10};
        INIT_SEQ_2 [18] = {1'b1, 8'h08};   
        INIT_SEQ_2 [19] = {1'b1, 8'h00};
		  
		  INIT_SEQ_3 [0] = {1'b0, 8'h00};
        INIT_SEQ_3 [1] = {1'b0, 8'h11};
        INIT_SEQ_3 [2] = {1'b1, 8'h10};                     
        INIT_SEQ_3 [3] = {1'b1, 8'h3B};
		  
        INIT_SEQ_4 [0] = {1'b0, 8'h00};
        INIT_SEQ_4 [1] = {1'b0, 8'h01};
        INIT_SEQ_4 [2] = {1'b1, 8'h01};                     
        INIT_SEQ_4 [3] = {1'b1, 8'h1C}; 
        INIT_SEQ_4 [4] = {1'b0, 8'h00};
        INIT_SEQ_4 [5] = {1'b0, 8'h02};  
        INIT_SEQ_4 [6] = {1'b1, 8'h01}; 
        INIT_SEQ_4 [7] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [8] = {1'b0, 8'h00};
        INIT_SEQ_4 [9] = {1'b0, 8'h03};
        INIT_SEQ_4 [10] = {1'b1, 8'h10};
        INIT_SEQ_4 [11] = {1'b1, 8'h38};
        INIT_SEQ_4 [12] = {1'b0, 8'h00};
        INIT_SEQ_4 [13] = {1'b0, 8'h07};
        INIT_SEQ_4 [14] = {1'b1, 8'h00};
        INIT_SEQ_4 [15] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [16] = {1'b0, 8'h00};
        INIT_SEQ_4 [17] = {1'b0, 8'h08};
        INIT_SEQ_4 [18] = {1'b1, 8'h08};   
        INIT_SEQ_4 [19] = {1'b1, 8'h08};
        INIT_SEQ_4 [20] = {1'b0, 8'h00};
        INIT_SEQ_4 [21] = {1'b0, 8'h0B};
        INIT_SEQ_4 [22] = {1'b1, 8'h11};                     
        INIT_SEQ_4 [23] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [24] = {1'b0, 8'h00};
        INIT_SEQ_4 [25] = {1'b0, 8'h0C};  
        INIT_SEQ_4 [26] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [27] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [28] = {1'b0, 8'h00};
        INIT_SEQ_4 [29] = {1'b0, 8'h0F};
        INIT_SEQ_4 [30] = {1'b1, 8'h0D};
        INIT_SEQ_4 [31] = {1'b1, 8'h01};
        INIT_SEQ_4 [32] = {1'b0, 8'h00};
        INIT_SEQ_4 [33] = {1'b0, 8'h1A};
        INIT_SEQ_4 [34] = {1'b1, 8'h00};
        INIT_SEQ_4 [35] = {1'b1, 8'h20};
        INIT_SEQ_4 [36] = {1'b0, 8'h00};
        INIT_SEQ_4 [37] = {1'b0, 8'h20};
        INIT_SEQ_4 [38] = {1'b1, 8'h00};   
        INIT_SEQ_4 [39] = {1'b1, 8'h00};
		  INIT_SEQ_4 [40] = {1'b0, 8'h00};
        INIT_SEQ_4 [41] = {1'b0, 8'h21};
        INIT_SEQ_4 [42] = {1'b1, 8'h00};                     
        INIT_SEQ_4 [43] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [44] = {1'b0, 8'h00};
        INIT_SEQ_4 [45] = {1'b0, 8'h30};  
        INIT_SEQ_4 [46] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [47] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [48] = {1'b0, 8'h00};
        INIT_SEQ_4 [49] = {1'b0, 8'h31};
        INIT_SEQ_4 [50] = {1'b1, 8'h00};
        INIT_SEQ_4 [51] = {1'b1, 8'hDB};
        INIT_SEQ_4 [52] = {1'b0, 8'h00};
        INIT_SEQ_4 [53] = {1'b0, 8'h32};
        INIT_SEQ_4 [54] = {1'b1, 8'h00};
        INIT_SEQ_4 [55] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [56] = {1'b0, 8'h00};
        INIT_SEQ_4 [57] = {1'b0, 8'h33};
        INIT_SEQ_4 [58] = {1'b1, 8'h00};   
        INIT_SEQ_4 [59] = {1'b1, 8'h00};
		  INIT_SEQ_4 [60] = {1'b0, 8'h00};
        INIT_SEQ_4 [61] = {1'b0, 8'h34};
        INIT_SEQ_4 [62] = {1'b1, 8'h00};                     
        INIT_SEQ_4 [63] = {1'b1, 8'hDB}; 
        INIT_SEQ_4 [64] = {1'b0, 8'h00};
        INIT_SEQ_4 [65] = {1'b0, 8'h3A};  
        INIT_SEQ_4 [66] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [67] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [68] = {1'b0, 8'h00};
        INIT_SEQ_4 [69] = {1'b0, 8'h36};
        INIT_SEQ_4 [70] = {1'b1, 8'h00};
        INIT_SEQ_4 [71] = {1'b1, 8'h5F};
        INIT_SEQ_4 [72] = {1'b0, 8'h00};
        INIT_SEQ_4 [73] = {1'b0, 8'h37};
        INIT_SEQ_4 [74] = {1'b1, 8'h00};
        INIT_SEQ_4 [75] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [76] = {1'b0, 8'h00};
        INIT_SEQ_4 [77] = {1'b0, 8'h38};
        INIT_SEQ_4 [78] = {1'b1, 8'h00};   
        INIT_SEQ_4 [79] = {1'b1, 8'hDB};
		  INIT_SEQ_4 [80] = {1'b0, 8'h00};
        INIT_SEQ_4 [81] = {1'b0, 8'h39};
        INIT_SEQ_4 [82] = {1'b1, 8'h00};                     
        INIT_SEQ_4 [83] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [84] = {1'b0, 8'h00};
        INIT_SEQ_4 [85] = {1'b0, 8'h60}; 
        INIT_SEQ_4 [86] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [78] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [88] = {1'b0, 8'h00};
        INIT_SEQ_4 [89] = {1'b0, 8'h61};
        INIT_SEQ_4 [90] = {1'b1, 8'h08};
        INIT_SEQ_4 [91] = {1'b1, 8'h08};
        INIT_SEQ_4 [92] = {1'b0, 8'h00};
        INIT_SEQ_4 [93] = {1'b0, 8'h62};
        INIT_SEQ_4 [94] = {1'b1, 8'h08};
        INIT_SEQ_4 [95] = {1'b1, 8'h0A}; 
        INIT_SEQ_4 [96] = {1'b0, 8'h00};
        INIT_SEQ_4 [97] = {1'b0, 8'h63};
        INIT_SEQ_4 [98] = {1'b1, 8'h00};   
        INIT_SEQ_4 [99] = {1'b1, 8'h0A};
		  INIT_SEQ_4 [100] = {1'b0, 8'h00};
        INIT_SEQ_4 [101] = {1'b0, 8'h64};
        INIT_SEQ_4 [102] = {1'b1, 8'h0A};                     
        INIT_SEQ_4 [103] = {1'b1, 8'h08}; 
        INIT_SEQ_4 [104] = {1'b0, 8'h00};
        INIT_SEQ_4 [105] = {1'b0, 8'h66};  
        INIT_SEQ_4 [106] = {1'b1, 8'h08}; 
        INIT_SEQ_4 [107] = {1'b1, 8'h08}; 
        INIT_SEQ_4 [108] = {1'b0, 8'h00};
        INIT_SEQ_4 [109] = {1'b0, 8'h66};
        INIT_SEQ_4 [110] = {1'b1, 8'h00};
        INIT_SEQ_4 [111] = {1'b1, 8'h00};
        INIT_SEQ_4 [112] = {1'b0, 8'h00};
        INIT_SEQ_4 [113] = {1'b0, 8'h67};
        INIT_SEQ_4 [114] = {1'b1, 8'h0A};
        INIT_SEQ_4 [115] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [116] = {1'b0, 8'h00};
        INIT_SEQ_4 [117] = {1'b0, 8'h68};
        INIT_SEQ_4 [118] = {1'b1, 8'h07};   
        INIT_SEQ_4 [119] = {1'b1, 8'h10};
		  INIT_SEQ_4 [120] = {1'b0, 8'h00};
        INIT_SEQ_4 [121] = {1'b0, 8'h69};
        INIT_SEQ_4 [122] = {1'b1, 8'h07};                     
        INIT_SEQ_4 [123] = {1'b1, 8'h10}; 
        INIT_SEQ_4 [124] = {1'b0, 8'h00};
        INIT_SEQ_4 [125] = {1'b0, 8'h17};  
        INIT_SEQ_4 [126] = {1'b1, 8'h00}; 
        INIT_SEQ_4 [127] = {1'b1, 8'h12}; 
		  
		  END_SEQ[0] = {1'b0,8'h00};
		  END_SEQ[1] = {1'b0,8'h33};
		  END_SEQ[2] = {1'b1,8'h00};
		  END_SEQ[3] = {1'b1,8'hAF};
		  END_SEQ[4] = {1'b0,8'h00};
		  END_SEQ[5] = {1'b0,8'h37};
		  END_SEQ[6] = {1'b1,8'h00};
		  END_SEQ[7] = {1'b1,8'h00};
		  END_SEQ[8] = {1'b0,8'h00};
		  END_SEQ[9] = {1'b0,8'h38};
		  END_SEQ[10] = {1'b1,8'h00};
		  END_SEQ[11] = {1'b1,8'hDB};
		  END_SEQ[12] = {1'b0,8'h00};
		  END_SEQ[13] = {1'b0,8'h39};
		  END_SEQ[14] = {1'b1,8'h00};
		  END_SEQ[15] = {1'b1,8'h00};
    end 
	 
	 
	 endmodule
	 
	 