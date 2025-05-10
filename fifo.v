`timescale 1ns/1ps
module fifo (
	clk_rx,  //寫入clock
	clk_tx,  //讀取clock
	rst,     //非同步重置信號
	wr_en,   //寫入使能
	rd_en,   //讀取使能
	data_in, //寫入資料
	data_out,  //讀出資料
	empty      // FIFO為空

);

//===Parameters===
parameter DATA_WIDTH = 8;
parameter DEPTH = 16;

//===Ports===
input wire clk_rx;  //寫入clock
input wire clk_tx;  //讀取clock
input wire rst;     //非同步重置信號
input wire wr_en;   //寫入使能
input wire rd_en;   //讀取使能
input wire [DATA_WIDTH-1:0] data_in;  //寫入資料
output reg [DATA_WIDTH-1:0] data_out;  //讀出資料
output wire empty;  //FIFO為空	
	
//===Internal===
reg [DATA_WIDTH-1:0] mem [0: DEPTH-1];
reg [$clog2(DEPTH)-1:0] wr_ptr;
reg [$clog2(DEPTH)-1:0] rd_ptr;
reg [$clog2(DEPTH):0] count;  //可記錄最大深度,注意這邊是DEPTH bits + 1
	
assign empty = (count == 0);
	
	
//===寫入端邏輯(clk_rx)===
always @(posedge clk_rx or posedge rst) begin
	if (rst) begin
		wr_ptr <= 0;
		count <= 0;  //<-把count歸零
	end else begin
		if (wr_en) begin
		    mem[wr_ptr] <= data_in;
		    wr_ptr <= wr_ptr + 1;
			 if (count < DEPTH)
				 count <= count + 1;  //寫入時增加count
		end
	end
end
	
//===讀取端邏輯(clk_tx)===
always @(posedge clk_tx or posedge rst) begin
	if (rst) begin
		rd_ptr <= 0;
		data_out <= 0;
	end else begin
	    if (rd_en && !empty) begin
		    data_out <= mem[rd_ptr];
		    rd_ptr <= rd_ptr + 1;
			 count <= count - 1;  //讀出時減少count
		 end
	end
end

endmodule	
	