module Contol_ili(
        input  wire clk,    
        input  wire rst,
        input  wire [15:0] input_data, 
        input  wire frame_done, 
        output wire spi_mosi_out,
        output wire spi_sck_out,
        output wire spi_cs_out,
        output wire spi_dc_out,
        output wire data_clk,
		  output reg spi_reset
    );
	 
	 
localparam DELAY_10ms = 125000;
localparam DELAY_60ms = 750000;
localparam DELAY_50ms = 625000;
localparam DELAY_40ms = 500000;
localparam DELAY_10us = 125;
localparam DELAY_1s = 12500000;
reg spi_sck_reg;
reg spi_cs_reg;
reg spi_dc_reg;

assign spi_mosi_out = (state == START_RESET)?1'b1:spi_mosi;
assign spi_sck_out = (state == START_RESET)?spi_sck_reg:spi_sck;
assign spi_cs_out = (state == START_RESET)?spi_cs_reg:spi_cs;
assign spi_dc_out = (state == START_RESET)?spi_dc_reg:spi_dc;

reg[8:0] spi_data;
reg available_data;
reg data_byte_flag;
assign data_clk = !data_byte_flag;

reg[3:0]state;
reg[3:0]state_next_wait;

localparam START_RESET = 0;
localparam WAIT = 1;
localparam SEND_INIT_1 = 2;
localparam SEND_INIT_2 = 3;
localparam SEND_INIT_3 = 4;
localparam SEND_INIT_4 = 5;
localparam SEND_ADRESS = 6;
localparam FRAME_LOOP = 7;
localparam WAIT_FRAME = 8;

reg[8:0] INIT_SEQ_1 [0:19];
reg[8:0] INIT_SEQ_2 [0:19];
reg[8:0] INIT_SEQ_3 [0:3];
reg[8:0] INIT_SEQ_4 [0:127];
reg[8:0] ADRESS_SEQ [0:33];

reg [7:0] config_counter;
reg [31:0] delay_counter;

reg[31:0] delay_limit;
reg[3:0] step_reset;

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
		  spi_reset <= 1'b1;
		  spi_sck_reg<= 'b0;
		  spi_cs_reg<= 'b1;
		  spi_dc_reg<= 'b1;
		  step_reset <= 0;
		  delay_limit <= 0;
		  state_next_wait <= 0;
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
		  
		  ADRESS_SEQ [0] = {1'b0, 8'h00};
        ADRESS_SEQ [1] = {1'b0, 8'h07};
        ADRESS_SEQ [2] = {1'b1, 8'h10};                     
        ADRESS_SEQ [3] = {1'b1, 8'h17}; 
        ADRESS_SEQ [4] = {1'b0, 8'h00};
        ADRESS_SEQ [5] = {1'b0, 8'h02};  
        ADRESS_SEQ [6] = {1'b1, 8'h10}; 
        ADRESS_SEQ [7] = {1'b1, 8'h38}; 
        ADRESS_SEQ [8] = {1'b0, 8'h00};
        ADRESS_SEQ [9] = {1'b0, 8'h36};
        ADRESS_SEQ [10] = {1'b1, 8'h00};
        ADRESS_SEQ [11] = {1'b1, 8'hAF};
        ADRESS_SEQ [12] = {1'b0, 8'h00};
        ADRESS_SEQ [13] = {1'b0, 8'h37};
        ADRESS_SEQ [14] = {1'b1, 8'h00};
        ADRESS_SEQ [15] = {1'b1, 8'h00}; 
        ADRESS_SEQ [16] = {1'b0, 8'h00};
        ADRESS_SEQ [17] = {1'b0, 8'h38};
        ADRESS_SEQ [18] = {1'b1, 8'h00};   
        ADRESS_SEQ [19] = {1'b1, 8'hDB};
        ADRESS_SEQ [20] = {1'b0, 8'h00};
        ADRESS_SEQ [21] = {1'b0, 8'h39};
        ADRESS_SEQ [22] = {1'b1, 8'h00};                     
        ADRESS_SEQ [23] = {1'b1, 8'h00}; 
        ADRESS_SEQ [24] = {1'b0, 8'h00};
        ADRESS_SEQ [25] = {1'b0, 8'h20};  
        ADRESS_SEQ [26] = {1'b1, 8'h00}; 
        ADRESS_SEQ [27] = {1'b1, 8'h00}; 
        ADRESS_SEQ [28] = {1'b0, 8'h00};
        ADRESS_SEQ [29] = {1'b0, 8'h21};
        ADRESS_SEQ [30] = {1'b1, 8'h00};
        ADRESS_SEQ [31] = {1'b1, 8'h00};
        ADRESS_SEQ [32] = {1'b0, 8'h00};
        ADRESS_SEQ [33] = {1'b0, 8'h22};
		  
    end 
	 
	 always @(posedge clk, posedge rst)begin
	 if (rst)begin
		state <= START_RESET;
        config_counter <= 'b0;
        spi_data <= 'b0;
        delay_counter <= 'b0;
        available_data <= 'b0;
        data_byte_flag <= 1'b1;
		  spi_reset <= 1'b1;
		  spi_sck_reg<= 'b0;
		  spi_cs_reg<= 'b1;
		  spi_dc_reg<= 'b1;
		  step_reset <= 0;
		  delay_limit <= 0;
		  state_next_wait <= 0;
	 
	 end
	 else begin
			case(state)
			START_RESET: begin
				case (step_reset)
				0: begin
					spi_sck_reg <= 1;
					if(delay_counter == DELAY_10ms)begin //es 60 ms 
						delay_counter <= 0;
						step_reset <= 1;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				1: begin
					spi_reset <= 0;
					if(delay_counter == DELAY_10us)begin
						delay_counter <= 0;
						step_reset <= 2;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				2: begin
					spi_dc_reg <= 0;
					if(delay_counter == DELAY_10us)begin
						delay_counter <= 0;
						step_reset <= 3;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				3: begin
					spi_cs_reg <= 0;
					if(delay_counter == DELAY_10us/2)begin
						delay_counter <= 0;
						step_reset <= 4;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end	
				4: begin
					spi_cs_reg <= 1;
					if(delay_counter == DELAY_10us)begin
						delay_counter <= 0;
						step_reset <= 5;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				5: begin
					spi_sck_reg <= 0;
					if(delay_counter == DELAY_10us/2)begin
						delay_counter <= 0;
						step_reset <= 6;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				6: begin
					spi_reset <= 1;
					if(delay_counter == DELAY_10us*100)begin
						delay_counter <= 0;
						step_reset <= 7;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				7:begin
					spi_reset <= 0;
					if(delay_counter == DELAY_10ms)begin
						delay_counter <= 0;
						step_reset <= 8;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				8:begin
					spi_reset <= 1;
					if(delay_counter == DELAY_10ms)begin
						delay_counter <= 0;
						state <= WAIT;
						state_next_wait <= SEND_INIT_1;
						delay_limit <= DELAY_10ms;//50ms
						step_reset <= 0;
					end
					else begin
						delay_counter <= delay_counter + 1;
					end
				end
				endcase
			end
			WAIT: begin
				if(delay_counter == delay_limit)begin
					delay_counter <= 0;
					state <= state_next_wait;
				end
				else begin
					delay_counter <= delay_counter + 1;
				end
				if(idle) begin
               available_data <= 1'b0;
				end
			end
			SEND_INIT_1: begin
				if(idle)begin
					if(config_counter == 20)begin
						state = WAIT;
						config_counter <= 0;
						state_next_wait <= SEND_INIT_2;
						delay_counter <= 0;
						delay_limit <= DELAY_10ms;//40ms
					end
					else begin
						available_data <= 1;
						spi_data <= INIT_SEQ_1[config_counter];
						config_counter <= config_counter + 1;
					end
				end
				else begin
					available_data <= 0;
				end
			end
			SEND_INIT_2: begin
				if(idle)begin
					if(config_counter == 20)begin
						state = WAIT;
						config_counter <= 0;
						state_next_wait <= SEND_INIT_3;
						delay_counter <= 0;
						delay_limit <= DELAY_10ms;
					end
					else begin
						available_data <= 1;
						spi_data <= INIT_SEQ_2[config_counter];
						config_counter <= config_counter + 1;
					end
				end
				else begin
					available_data <= 0;
				end
			end
			SEND_INIT_3: begin
				if(idle)begin
					if(config_counter == 4)begin
						state = WAIT;
						config_counter <= 0;
						state_next_wait <= SEND_INIT_4;
						delay_counter <= 0;
						delay_limit <= DELAY_10ms;//50ms
					end
					else begin
						available_data <= 1;
						spi_data <= INIT_SEQ_3[config_counter];
						config_counter <= config_counter + 1;
					end
				end
				else begin
					available_data <= 0;
				end
			end
			SEND_INIT_4: begin
				if(idle)begin
					if(config_counter == 128)begin
						state = WAIT;
						config_counter <= 0;
						state_next_wait <= SEND_ADRESS;
						delay_counter <= 0;
						delay_limit <= DELAY_10ms;//50ms
					end
					else begin
						available_data <= 1;
						spi_data <= INIT_SEQ_4[config_counter];
						config_counter <= config_counter + 1;
					end
				end
				else begin
					available_data <= 0;
				end
			end
			SEND_ADRESS: begin
				if(idle)begin
					if(config_counter == 34)begin
						state = FRAME_LOOP;
						config_counter <= 0;
					end
					else begin
						available_data <= 1;
						spi_data <= ADRESS_SEQ[config_counter];
						config_counter <= config_counter + 1;
					end
				end
				else begin
					available_data <= 0;
				end
			end
			FRAME_LOOP: begin
				if(idle) begin
					if(frame_done & config_counter>6)begin
						state <= WAIT_FRAME;
						config_counter <= 0;
						delay_limit <= DELAY_1s/4;
						delay_counter <= 0;
					end 
					else begin
							spi_data <= !data_byte_flag ? {1'b1, input_data[7:0]} :{1'b1, input_data[15:8]};
							available_data <= 1'b1;
							data_byte_flag <= !data_byte_flag;
							if(config_counter < 10)config_counter <= config_counter +1;
					end
            end else begin
                available_data <= 1'b0;
            end
			end
			WAIT_FRAME: begin
				if(idle) begin
						if(delay_counter == delay_limit)begin
							available_data <= 1'b0;
							state <= SEND_ADRESS;
							config_counter <= 'b0;
							spi_data <= 'b0;
							delay_counter <= 'b0;
							available_data <= 'b0;
							data_byte_flag <= 1'b1;
							spi_reset <= 1'b1;
							spi_sck_reg<= 'b0;
							spi_cs_reg<= 'b1;
							spi_dc_reg<= 'b1;
							step_reset <= 0;
							delay_limit <= 0;
							state_next_wait <= 0;
						end
						else begin
							delay_counter <= delay_counter + 1;
						end
					end
				end
		endcase
	 end
end
endmodule
	 
	 