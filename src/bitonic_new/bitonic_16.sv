// 16-input bitonic sorter, composed of 2 8-input sorters and an 16-input backend.

module bitonic_16 import sorter_pkg::*; #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 16
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  ctrl_t                   ctrl_i,
    output ctrl_t                   ctrl_o,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output data_o_t                y_o
);

    /********************/
    /*     Frontend     */
    /********************/

    data_o_t fe_out[1:0]; //Two 8-input sorters respectively
    logic [DATAWIDTH-1:0] fe_16_out[DATALENGTH-1:0];
    ctrl_t ctrl_fe_out[1:0];
    ctrl_t ctrl_be_in;
    
    for(genvar i = 0; i < 2; i++) begin
        bitonic_8 #(
            .DATAWIDTH(DATAWIDTH),
            .DATALENGTH(8)
        )i_bitonic_8(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_i),
            .ctrl_o         (ctrl_fe_out[i]),
            .x_i            (x_i[8*i+:8]),
            .y_o            (fe_out[i])
        );

        //Gather sub-modules'data to the father module's output port.
        assign y_o.data_4[2*i+:2] = fe_out[i].data_4[1:0]; //Only the first 2 channels of data_4 have data.
        assign y_o.data_8[i] = fe_out[i].data_8[0]; //Only the first channel of data_8 has data.
    end

    assign fe_16_out = {fe_out[1].data_8[0], fe_out[0].data_8[0]};

    //Set channel_8 signal to 0, because it shouldn't transport to backend and 32-sorters.
    assign ctrl_be_in.sign_ctrl = ctrl_fe_out[0].sign_ctrl;
    assign ctrl_be_in.channel.channel_4 = 8'b0;
    assign ctrl_be_in.channel.channel_8 = 4'b0;
    assign ctrl_be_in.channel.channel_16 = ctrl_fe_out[0].channel.channel_16;
    assign ctrl_be_in.channel.channel_32 = ctrl_fe_out[0].channel.channel_32;
    
    /********************/
    /*     Backend      */
    /********************/

    ctrl_t ctrl_be_out;
    
    bitonic_16_be #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_16_be(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .ctrl_i         (ctrl_be_in),
        .ctrl_o         (ctrl_be_out),
        .x_i            (fe_16_out),
        .y_o            (y_o.data_16[0])
    );

    assign ctrl_o.sign_ctrl = ctrl_be_out.sign_ctrl;
    assign ctrl_o.channel.channel_4 = ctrl_fe_out[0].channel.channel_4;
    assign ctrl_o.channel.channel_8 = ctrl_fe_out[0].channel.channel_8;
    assign ctrl_o.channel.channel_16 = ctrl_be_out.channel.channel_16;
    assign ctrl_o.channel.channel_32 = ctrl_be_out.channel.channel_32;

endmodule
