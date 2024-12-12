// 8-input bitonic sorter, composed of 2 4-input sorters and an 8-input backend.

module bitonic_8 import topk_pkg::*; #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 8
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
    data_o_t fe_out[1:0]; //Two 4-input sorters respectively
    logic [DATAWIDTH-1:0]fe_8_out[DATALENGTH-1:0];
    ctrl_t ctrl_fe_out[1:0];
    ctrl_t ctrl_be_in;
    
    for(genvar i = 0; i < 2; i++) begin
        bitonic_4 #(
            .DATAWIDTH(DATAWIDTH),
            .DATALENGTH(4)
        )i_bitonic_4(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_i),
            .ctrl_o         (ctrl_fe_out[i]),
            .x_i            (x_i[4*i+:4]),
            .y_o            (fe_out[i])
        );
        
        //Gather sub-modules'data to the father module's output port.
        assign y_o.data_4[i] = fe_out[i].data_4[0];
    end

    assign fe_8_out = {fe_out[1].data_4[0], fe_out[0].data_4[0]};
    
    //Set channel_4 signal to 0, because it shouldn't transport to backend and
    //16/32-sorters.
    assign ctrl_be_in.sign_ctrl = ctrl_fe_out[0].sign_ctrl;
    assign ctrl_be_in.channel.channel_4 = 8'b0;
    assign ctrl_be_in.channel.channel_8 = ctrl_fe_out[0].channel.channel_8;
    assign ctrl_be_in.channel.channel_16 = ctrl_fe_out[0].channel.channel_16;
    assign ctrl_be_in.channel.channel_32 = ctrl_fe_out[0].channel.channel_32;

    /********************/
    /*     Backend      */
    /********************/ 

    ctrl_t ctrl_be_out;
    
    bitonic_8_be #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_8_be(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .ctrl_i         (ctrl_be_in),
        .ctrl_o         (ctrl_be_out),
        .x_i            (fe_8_out),
        .y_o            (y_o.data_8[0])
    );

    assign ctrl_o.sign_ctrl = ctrl_be_out.sign_ctrl;
    assign ctrl_o.channel.channel_4 = ctrl_fe_out[0].channel.channel_4;
    assign ctrl_o.channel.channel_8 = ctrl_be_out.channel.channel_8;
    assign ctrl_o.channel.channel_16 = ctrl_be_out.channel.channel_16;
    assign ctrl_o.channel.channel_32 = ctrl_be_out.channel.channel_32;

endmodule
