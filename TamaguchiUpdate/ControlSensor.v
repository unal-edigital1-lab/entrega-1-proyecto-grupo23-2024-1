module ControlSensor (
 input clk, //1Mhz
 input rst,
 input miso_sensor,
 output wire cs_sensor,
 output wire sck_sensor,
 output wire mosi_sensor,
 output wire bandera_salud
);


reg [7:0] data_1;
reg [7:0] data_2;
reg [7:0] data_3;

reg [1:0]modo;
//00 envio 2 datos
//01 envio 3 datos
//11 leer
reg load_data;

wire ready;

reg[24:0] INIT_SEQ_1 [0:1];
reg[24:0] INIT_SEQ_2 [0:25];

reg[2:0]state;

reg [4:0] config_count;
reg [31:0] delay_count;
reg [31:0] delay_limit;

localparam START = 0;
localparam SEND_INIT_1 = 1;
localparam WAIT = 2;
localparam SEND_INIT_2 = 3;
localparam READ = 4;

localparam DELAY_10ms = 15625;
localparam DELAY_100ms = 156250; // a reloj de 1.562Mhz

initial begin
	data_1 <= 0;
	data_2 <= 0;
	data_3 <= 0;
	modo <= 0;
	load_data<= 0;
	state <= 0;
	config_count <= 0;
	delay_count <= 0;
		delay_limit <= 0;
end
wire [24:0] act_config;

assign act_config = (state == 1)? INIT_SEQ_1[config_count]: INIT_SEQ_2[config_count];


initial begin
		  INIT_SEQ_1 [0] = {1'b0, 8'hD0,8'hFF,8'h00};
		  INIT_SEQ_1 [1] = {1'b0, 8'h60,8'hB6,8'h00};
	
		  INIT_SEQ_2 [0] = {1'b0, 8'hF3, 8'hFF,8'h00};
		  INIT_SEQ_2 [1] = {1'b1, 8'h88, 8'hFF,8'hFF};
        INIT_SEQ_2 [2] = {1'b1, 8'h8A, 8'hFF,8'hFF};                     
        INIT_SEQ_2 [3] = {1'b1, 8'h8C, 8'hFF,8'hFF}; 
        INIT_SEQ_2 [4] = {1'b1, 8'h8E, 8'hFF,8'hFF};
        INIT_SEQ_2 [5] = {1'b1, 8'h90, 8'hFF,8'hFF}; 
        INIT_SEQ_2 [6] = {1'b1, 8'h92, 8'hFF,8'hFF};
        INIT_SEQ_2 [7] = {1'b1, 8'h94, 8'hFF,8'hFF};
        INIT_SEQ_2 [8] = {1'b1, 8'h96, 8'hFF,8'hFF};
        INIT_SEQ_2 [9] = {1'b1, 8'h98, 8'hFF,8'hFF};
        INIT_SEQ_2 [10] = {1'b1, 8'h9A, 8'hFF,8'hFF};
        INIT_SEQ_2 [11] = {1'b1, 8'h9C, 8'hFF,8'hFF};
        INIT_SEQ_2 [12] = {1'b1, 8'h9E, 8'hFF,8'hFF};
        INIT_SEQ_2 [13] = {1'b0, 8'hA1, 8'hFF,8'h00};
        INIT_SEQ_2 [14] = {1'b1, 8'hE1, 8'hFF,8'hFF};
        INIT_SEQ_2 [15] = {1'b0, 8'hE3, 8'hFF,8'h00};
        INIT_SEQ_2 [16] = {1'b0, 8'hE4, 8'hFF,8'h00};
        INIT_SEQ_2 [17] = {1'b0, 8'hE5, 8'hFF,8'h00};
        INIT_SEQ_2 [18] = {1'b0, 8'hE6, 8'hFF,8'h00}; 
        INIT_SEQ_2 [19] = {1'b0, 8'hE5, 8'hFF,8'h00};
		  INIT_SEQ_2 [20] = {1'b0, 8'hE7, 8'hFF,8'h00};
		  INIT_SEQ_2 [21] = {1'b0, 8'h74, 8'h00,8'h00};
		  INIT_SEQ_2 [22] = {1'b0, 8'h72, 8'h05,8'h00};
		  INIT_SEQ_2 [23] = {1'b0, 8'h75, 8'h00,8'h00};
		  INIT_SEQ_2 [24] = {1'b0, 8'h74, 8'hB7,8'h00};
end

spi_sensor driver_sensor_mecheche10horasenestoayudaxd(
.clk(clk),
.rst(rst),
.miso_sensor(miso_sensor),
.data_1(data_1),
.data_2(data_2),
.data_3(data_3),
.modo(modo),
.load_data(load_data),
.cs_sensor(cs_sensor),
.sck_sensor(sck_sensor),
.mosi_sensor(mosi_sensor),
.bandera_salud(bandera_salud),
.ready(ready)
);


always @(posedge clk, posedge rst)begin
	if(rst)begin
		data_1 <= 0;
		data_2 <= 0;
		data_3 <= 0;
		modo <= 0;
		load_data<= 0;
		state <= 0;
		config_count <= 0;
		delay_count <= 0;
		delay_limit <= 0;
	end
	else begin
		case (state)
			START:begin
				state <= SEND_INIT_1;
				load_data <= 0;
			end
			SEND_INIT_1:begin
				if(ready)begin
					if(config_count == 2)begin
						state <= WAIT;
						delay_limit <= DELAY_10ms;
						delay_count <= 0;
						config_count <= 0;
						load_data <= 0;
					end
					else begin
						modo <= {1'b0,act_config[24]};
						data_1 <= act_config[23:16];
						data_2 <= act_config[15:8];
						data_3 <= act_config[7:0];
						config_count <= config_count + 1;
						load_data <= 1;
					end
				end
				else begin
					load_data <= 0;
				end
			end
			WAIT:begin
				if(delay_count == delay_limit)begin
					delay_count <= 0;
					delay_limit <= 0;
					state <= (delay_limit == DELAY_10ms)?SEND_INIT_2:READ;
				end
				else begin
					delay_count <= delay_count + 1;
				end
			end
			SEND_INIT_2:begin
				if(ready)begin
					if(config_count == 25)begin
						state <= WAIT;
						delay_limit <= DELAY_100ms;
						delay_count <= 0;
						config_count <= 0;
						load_data <= 0;
					end
					else begin
						modo <= {1'b0,act_config[24]};
						data_1 <= act_config[23:16];
						data_2 <= act_config[15:8];
						data_3 <= act_config[7:0];
						config_count <= config_count + 1;
						load_data <= 1;
					end
				end
				else begin
					load_data <= 0;
				end
			end
			READ:begin
				load_data <= 0;
				modo <= 2'b11;
			end
		endcase
	end
end

endmodule
