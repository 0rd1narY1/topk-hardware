// 32-input bitonic sorter, composed of 2 16-input sorters and an 32-input backend.

module bitonic_32 import sorter_pkg::*; #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 32
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  ctrl_t                   ctrl_i,
    output ctrl_t                   ctrl_o,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output data_o_t                 y_o
);

    /********************/
    /*     Frontend     */
    /********************/

    data_o_t fe_out[1:0]; //Two 16-input sorters respectively
    logic [DATAWIDTH-1:0] fe_32_out[DATALENGTH-1:0]; //32 elements for two 16-input sorters' output
    ctrl_t ctrl_fe_out[1:0];
    
    for(genvar i = 0; i < 2; i++) begin
        bitonic_16 #(
            .DATAWIDTH(DATAWIDTH),
            .DATALENGTH(16)
        )i_bitonic_16(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_i),
            .ctrl_o         (ctrl_fe_out[i]),
            .x_i            (x_i[16*i+:16]),
            .y_o            (fe_out[i])
        );
    end

    assign fe_32_out = {fe_out[1].data_16, fe_out[0].data_16};
    assign y_o.data_4 = fe_out[0].data_4;
    assign y_o.data_8 = fe_out[0].data_8;
    assign y_o.data_16 = fe_out[0].data_16;

    /********************/
    /*     Backend      */
    /********************/

    bitonic_32_be #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_32_be(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .ctrl_i         (ctrl_fe_out[0]),
        .ctrl_o         (ctrl_o),
        .x_i            (fe_32_out),
        .y_o            (y_o.data_32)
    );

endmodule
