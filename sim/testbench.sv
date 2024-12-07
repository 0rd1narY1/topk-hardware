`timescale 1ns/1ps

module testbench import sorter_pkg::*;;

parameter int DATAWIDTH = 8;
parameter int DATALENGTH = 32;
logic clk, rstn;
logic sign_ctrl;
logic [5:0]in_data_length;
logic [DATAWIDTH-1:0] x[DATALENGTH-1:0];
logic [DATAWIDTH-1:0] x1[7:0], x2[7:0],
                      x3[7:0], x4[7:0];
sorter_top_io_t y;


always #10 begin 
    clk = ~clk;
end

//fsdb waveform generation
initial 
begin
	$fsdbDumpfile("test.fsdb"); //指定生成的的fsdb
	$fsdbDumpvars(0,testbench, "+mda", "+all");   //0表示生成testbench模块及以下所有的仿真数据(支持多维数组)
	$vcdpluson;   //下面这两个是保存所有仿真数据
	$vcdplusmemon;
end

initial begin
    clk = 0; rstn = 0; sign_ctrl = 0; x = '{32{'0}}; in_data_length = 0;
    #30 rstn = 1; in_data_length = 32;
    x = {5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5,9,6,4,2,0,3,5,6,12,5,8,5,7,15};
    @(posedge clk) sign_ctrl = 1;
    x = {-100,-95,-90,-60,-40,-20,-18,-14,-8,-5,-1,0,5,10,25,35,-100,-5,-6,-9,-8,-7,-52,-75,10,23,56,0,-5,-6,1,25};
    @(posedge clk) sign_ctrl = 1; in_data_length = 19;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,10,25,35,-10,-5,-6,-9,-8,-7,-52,-75,10,23,56,0,-5,-6,1,25};
    @(posedge clk) sign_ctrl = 0; in_data_length = 18;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5};
    @(posedge clk) in_data_length = 20;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5,4,17};
    @(posedge clk) in_data_length = 16;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4};
    @(posedge clk) in_data_length = 14;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10};
    @(posedge clk) in_data_length = 11;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14};
    @(posedge clk) in_data_length = 8;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6};
    @(posedge clk) in_data_length = 8;
    x = {5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5,9,6,4,2,0,3,5,6,12,5,8,5,7,15};
    @(posedge clk) in_data_length = 6;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2};
    @(posedge clk) in_data_length = 4;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2};
    @(posedge clk) in_data_length = 3;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9};
    @(posedge clk) x = '{32{'0}};
    //并行化: 并行执行4组8元素排序 
    @(posedge clk) in_data_length = 32;
    x1 = {7,4,6,5,2,3,8,1}; x2 = {9,10,8,6,2,3,7,12}; x3 = {12,15,4,1,3,8,7,14}; x4 = {1,4,7,5,6,2,8,3};
    x = {x4, x3, x2, x1};
    repeat (20) begin 
        @(posedge clk);
    end
    $finish;
end

sorter_top #(
    .DATAWIDTH(DATAWIDTH),
    .MAX_DATALENGTH(DATALENGTH)
)i_sorter_top(
    .clk_i              (clk),
    .rstn_i             (rstn),
    .sign_ctrl_i        (sign_ctrl),
    .in_data_length_i   (in_data_length),
    .x_i                (x),
    .y_o                (y)
);

endmodule
