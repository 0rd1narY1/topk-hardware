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
    #30 rstn = 1; 
    x = {5,7,12,25,16,31,18,24,2,3,1,7,13,10,11,4,7,5,9,6,4,2,0,3,5,6,12,5,8,5,7,15};
    
    //1组20输入
    @(posedge clk) total_length = 20; total_group = 1;
    //1组19输入
    @(posedge clk) total_length = 19; total_group = 1;
    //1组18输入
    @(posedge clk) total_length = 18; total_group = 1;
    //1组17输入
    @(posedge clk) total_length = 17; total_group = 1;
    //1组16输入
    @(posedge clk) total_length = 16; total_group = 1;
    //1组15输入
    @(posedge clk) total_length = 15; total_group = 1;
    //1组14输入
    @(posedge clk) total_length = 14; total_group = 1;
    //1组13输入
    @(posedge clk) total_length = 13; total_group = 1;
    //1组12输入
    @(posedge clk) total_length = 12; total_group = 1;
    //1组11输入
    @(posedge clk) total_length = 11; total_group = 1;
    //1组10输入
    @(posedge clk) total_length = 10; total_group = 1;
    //1组9输入
    @(posedge clk) total_length = 9; total_group = 1;
    //1组8输入
    @(posedge clk) total_length = 8; total_group = 1;
    //1组7输入
    @(posedge clk) total_length = 7; total_group = 1;
    //1组6输入
    @(posedge clk) total_length = 6; total_group = 1;
    //1组5输入
    @(posedge clk) total_length = 5; total_group = 1;
    //1组4输入
    @(posedge clk) total_length = 4; total_group = 1;
    //1组3输入
    @(posedge clk) total_length = 3; total_group = 1;
    //1组2输入
    @(posedge clk) total_length = 2; total_group = 1;
    //1组1输入
    @(posedge clk) total_length = 1; total_group = 1;
    //1组0输入
    @(posedge clk) total_length = 0; total_group = 1;
    
    /*********多输入并行化测试***********/
    
    //2组16输入 
    @(posedge clk) total_length = 16*2; total_group = 2;
    //2组15输入 
    @(posedge clk) total_length = 15*2; total_group = 2;
    //2组14输入 
    @(posedge clk) total_length = 14*2; total_group = 2;
    //2组13输入 
    @(posedge clk) total_length = 13*2; total_group = 2;
    //2组12输入 
    @(posedge clk) total_length = 12*2; total_group = 2;
    //2组11输入 
    @(posedge clk) total_length = 11*2; total_group = 2;
    //2组10输入 
    @(posedge clk) total_length = 10*2; total_group = 2;
    //2组9输入 
    @(posedge clk) total_length = 9*2; total_group = 2;
    
    //2组8输入 
    @(posedge clk) total_length = 8*2; total_group = 2;
    //2组7输入 
    @(posedge clk) total_length = 7*2; total_group = 2;
    //2组6输入 
    @(posedge clk) total_length = 6*2; total_group = 2;
    //2组5输入 
    @(posedge clk) total_length = 5*2; total_group = 2;
    
    //2组4输入 
    @(posedge clk) total_length = 4*2; total_group = 2;
    //2组3输入 
    @(posedge clk) total_length = 3*2; total_group = 2;
    //2组2输入 
    @(posedge clk) total_length = 2*2; total_group = 2;

    //3组8输入 
    @(posedge clk) total_length = 8*3; total_group = 3;
    //3组7输入 
    @(posedge clk) total_length = 7*3; total_group = 3;
    //3组6输入 
    @(posedge clk) total_length = 6*3; total_group = 3;
    //3组5输入 
    @(posedge clk) total_length = 5*3; total_group = 3;
    
    //3组4输入 
    @(posedge clk) total_length = 4*3; total_group = 3;
    //3组3输入 
    @(posedge clk) total_length = 3*3; total_group = 3;
    //3组2输入 
    @(posedge clk) total_length = 2*3; total_group = 3;
    
    //4组8输入 
    @(posedge clk) total_length = 8*4; total_group = 4;
    //4组7输入 
    @(posedge clk) total_length = 7*4; total_group = 4;
    //4组6输入 
    @(posedge clk) total_length = 6*4; total_group = 4;
    //4组5输入 
    @(posedge clk) total_length = 5*4; total_group = 4;
    //4组4输入 
    @(posedge clk) total_length = 4*4; total_group = 4;
    //4组3输入 
    @(posedge clk) total_length = 3*4; total_group = 4;
    //4组2输入 
    @(posedge clk) total_length = 2*4; total_group = 4;
    
    
    //5组4输入 
    @(posedge clk) total_length = 4*5; total_group = 5;
    //5组3输入 
    @(posedge clk) total_length = 3*5; total_group = 5;
    //5组2输入 
    @(posedge clk) total_length = 2*5; total_group = 5;
    
    //6组4输入 
    @(posedge clk) total_length = 4*6; total_group = 6;
    //6组3输入 
    @(posedge clk) total_length = 3*6; total_group = 6;
    //6组2输入 
    @(posedge clk) total_length = 2*6; total_group = 6;
    
    //7组4输入 
    @(posedge clk) total_length = 4*7; total_group = 7;
    //7组3输入 
    @(posedge clk) total_length = 3*7; total_group = 7;
    //7组2输入 
    @(posedge clk) total_length = 2*7; total_group = 7;
    
    //8组4输入 
    @(posedge clk) total_length = 4*8; total_group = 8;
    //8组3输入 
    @(posedge clk) total_length = 3*8; total_group = 8;
    //8组2输入 
    @(posedge clk) total_length = 2*8; total_group = 8;
    
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
