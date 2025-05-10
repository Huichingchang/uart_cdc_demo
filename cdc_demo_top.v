`timescale 1ns/1ps
module cdc_demo_top (
	input wire clk_rx,  //RX clock domain
	input wire clk_sys, //SYS (TX) clock domain
	input wire rst,     //非同步重置信號
	input wire [7:0] rx_data,  //假設來自UART的資料
	input wire rx_valid,       //UART 發送資料有效
	output wire [7:0] tx_data, //要送出UART的資料
	output wire tx_valid,      //UART發送資料有效
	output wire led            //狀態燈號
	
);
   
//=== CDC同步 ===
wire rx_valid_sync;
	
cdc_sync u_cdc_sync (
	.clk_dst(clk_sys),
	.rst(rst),
	.signal_src(rx_valid),
	.signal_dst(rx_valid_sync)
);
	
//=== FIFO介面===
reg wr_en;
reg rd_en;
wire [7:0] fifo_dout;
wire fifo_empty;
	
//寫入條件: RX domain detect到valid,寫入FIFO
always @(posedge clk_rx or posedge rst) begin
	if (rst)
		wr_en <= 0;
	else
		wr_en <= rx_valid;
end
	
//讀取條件:在 TX domain接收同步後的valid
always @(posedge clk_sys or posedge rst) begin
	if (rst)
		rd_en <= 0;
	else
		rd_en <= rx_valid_sync;
end	
	
fifo u_fifo(
	  .clk_rx(clk_rx),
	  .clk_tx(clk_sys),
	  .rst(rst),
	  .wr_en(wr_en),
	  .rd_en(rd_en),
	  .data_in(rx_data),
	  .data_out(fifo_dout),
	  .empty(fifo_empty)
		
);
	
//=== TX & LED控制 ===
assign tx_data = fifo_dout;
assign tx_valid = ~fifo_empty;
	
reg led_reg;
always @(posedge clk_sys or posedge rst) begin
	if (rst)
		led_reg <= 0;
	else if (rd_en)
		led_reg <= ~led_reg;
end
	
assign led = led_reg;
endmodule
		
		