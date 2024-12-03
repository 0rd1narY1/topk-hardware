`timescale 1ns/1ps

module testbench;

parameter int DATAWIDTH = 8;
parameter int DATALENGTH = 16;
typedef logic[DATAWIDTH-1:0] elent;
logic clk, rstn;
logic sign_ctrl;
elent x[DATALENGTH-1:0], y[DATALENGTH-1:0];

always #10 begin 
    clk = ~clk;
end

initial begin
end

initial begin
    clk = 0; rstn = 0; sign_ctrl = 0;
    x = {0,18,23,35,40,60,90,95,20,14,12,10,9,8,5,3};
    #20 rstn = 1;
    #120 $display(x,y);
    #20 x = {5,7,9,1,0,2,3,6,8,15,14,12,13,10,11,4};
    #120 $display(x,y);
    #20 sign_ctrl = 1;
    x = {-100,-95,-90,-60,-40,-20,-18,-14,-8,-5,-1,0,5,10,25,35};
    #120 $display(x,y);
    #20 x = {-2,-15,-85,-6,0,-52,-4,-1,15,-57,8,10,0,1,1,-45};
    #120 $display(x,y);
    #200;
    $finish;
end

bitonic_16 #(
    .DATAWIDTH(DATAWIDTH),
    .DATALENGTH(DATALENGTH)
)i_bitonic(
    .clk_i          (clk),
    .rstn_i         (rstn),
    .sign_ctrl_i    (sign_ctrl),
    .x_i            (x),
    .y_o            (y)
);

//odd_even_16 #(
//    .DATAWIDTH(DATAWIDTH),
//    .DATALENGTH(DATALENGTH)
//)i_odd_even(
//    .clk_i          (clk),
//    .rstn_i         (rstn),
//    .sign_ctrl_i    (sign_ctrl),
//    .x_i            (x),
//    .y_o            (y)
//);

endmodule
