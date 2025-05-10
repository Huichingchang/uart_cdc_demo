`timescale 1ns/1ps
module cdc_sync (
	input wire clk_dst,  //目標 clock domain
	input wire rst,      //非同步重置信號
	input wire signal_src,  //來自 source domain 的 1-bit 訊號
	output reg signal_dst   //同步到 clk_dst 的版本
); 

	//兩級Flip-Flop緩衝器
	reg sync_ff1, sync_ff2;
	
	always @(posedge clk_dst or posedge rst) begin
		if (rst) begin
			sync_ff1 <= 1'b0;
			sync_ff2 <= 1'b0;
			signal_dst <= 1'b0;
		end else begin
			sync_ff1 <= signal_src;  //第1階段: sample輸入訊號
			sync_ff2 <= sync_ff1;    //第二階段: 再過濾一次
			signal_dst <= sync_ff2;  //輸出穩定訊號
			
		end
	end
endmodule