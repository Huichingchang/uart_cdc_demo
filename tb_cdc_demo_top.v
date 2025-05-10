`timescale 1ns/1ps
module tb_cdc_demo_top;

reg clk_rx;   // source clock
reg clk_sys;  //destination clock
reg rst;
reg [7:0] rx_data;
reg rx_valid;
wire [7:0] tx_data;
wire tx_valid;
wire led;

//DUT (Device Under Test)
cdc_demo_top uut(
		.clk_rx(clk_rx),
		.clk_sys(clk_sys),
		.rst(rst),
		.rx_data(rx_data),
		.rx_valid(rx_valid),
		.tx_data(tx_data),
		.tx_valid(tx_valid),
		.led(led)
);
	
// Clock generation	
always #100 clk_rx = ~clk_rx;
always #10 clk_sys = ~clk_sys;
	
// Stimulus
initial begin
		clk_rx = 0;
		clk_sys = 0;
		rst = 1;
		rx_data = 8'h00;
		rx_valid = 0;
		
		#200;
		rst = 0;
		
		//傳送第一筆資料
		#100;
		rx_data = 8'hA5;
		rx_valid = 1;
		#200;
		rx_valid = 0;
		
		//傳送第二筆資料
		#1000;
		rx_data = 8'h3C;
		rx_valid = 1;
		#200;
		rx_valid = 0;
		
		//傳送第三筆資料
		#1000;
		rx_data = 8'h5A;
		rx_valid = 1;
		#200;
		rx_valid = 0;
		
		
		
		#3000;
		$finish;
end
endmodule
	