`timescale 1ns/1ps

module testbench import sorter_pkg::*;;

parameter int DATAWIDTH = 8;
parameter int DATALENGTH = 32;
logic clk, rstn;
logic sign_ctrl;
logic [5:0]total_length;
logic [3:0]total_group;
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
    clk = 0; rstn = 0; sign_ctrl = 0; x = '{32{'0}}; total_length = 0; total_group = 0;
    //是否带符号、单组长度改变测试
    #30 rstn = 1; total_length = 32; total_group = 1;
    x = {5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5,9,6,4,2,0,3,5,6,12,5,8,5,7,15};
    @(posedge clk) sign_ctrl = 1; total_group = 1;
    x = {-100,-95,-90,-60,-40,-20,-18,-14,-8,-5,-1,0,5,10,25,35,-100,-5,-6,-9,-8,-7,-52,-75,10,23,56,0,-5,-6,1,25};
    @(posedge clk) sign_ctrl = 1; total_length = 19; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,10,25,35,-10,-5,-6,-9,-8,-7,-52,-75,10,23,56,0,-5,-6,1,25};
    @(posedge clk) sign_ctrl = 0; total_length = 18; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5};
    @(posedge clk) total_length = 20; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5,4,17};
    @(posedge clk) total_length = 16; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4};
    @(posedge clk) total_length = 14; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14,12,13,10};
    @(posedge clk) total_length = 11; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6,8,15,14};
    @(posedge clk) total_length = 8; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2,3,6};
    @(posedge clk) total_length = 8; total_group = 1;
    x = {5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4,7,5,9,6,4,2,0,3,5,6,12,5,8,5,7,15};
    @(posedge clk) total_length = 6; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2};
    @(posedge clk) total_length = 4; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9,1,0,2};
    @(posedge clk) total_length = 3; total_group = 1;
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,7,9};
    @(posedge clk) x = '{32{'0}};
    //并行化: 并行执行4组8元素排序 
    @(posedge clk) total_length = 32; total_group = 4;
    x1 = {7,4,6,5,2,3,8,1}; x2 = {9,10,8,6,2,3,7,12}; x3 = {12,15,4,1,3,8,7,14}; x4 = {1,4,7,5,6,2,8,3};
    x = {x4, x3, x2, x1};
    //并行化: 并行执行2组8元素排序 
    @(posedge clk) total_length = 16; total_group = 2;
    x1 = {9,10,8,6,2,3,7,12}; x2 = {1,4,7,5,6,2,8,3};
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, x2, x1};
    //并行化: 并行执行2组6元素排序 
    @(posedge clk) total_length = 12; total_group = 2;
    x1 = {0,0,8,6,2,3,7,12}; x2 = {0,0,7,5,6,2,8,3};
    x = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, x2, x1};
    @(posedge clk) total_length = 32; x = '{32{'0}};
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
    .total_length_i     (total_length),
    .total_group_i      (total_group),
    .x_i                (x),
    .y_o                (y)
);

endmodule
