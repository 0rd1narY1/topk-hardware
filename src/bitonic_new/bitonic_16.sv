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
    //assign y_o.data_4 = fe_out[0].data_4;
    //assign y_o.data_8 = fe_out[0].data_8;

    /********************/
    /*     Backend      */
    /********************/

    bitonic_16_be #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_16_be(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .ctrl_i         (ctrl_fe_out[0]),
        .ctrl_o         (ctrl_o),
        .x_i            (fe_16_out),
        .y_o            (y_o.data_16[0])
    );

endmodule
