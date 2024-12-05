// 16-input bitonic sorter, composed of 2 8-input sorters and an 16-input backend.

module bitonic_16 #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 16
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  logic                    sign_ctrl_i,
    output logic                    sign_ctrl_o,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]    y_o[DATALENGTH-1:0]
);

    /********************/
    /*     Frontend     */
    /********************/

    logic [DATAWIDTH-1:0] fe_out[DATALENGTH-1:0];
    logic [1:0]sign_ctrl_fe_out;
    
    for(genvar i = 0; i < 2; i++) begin
        bitonic_8 #(
            .DATAWIDTH(DATAWIDTH),
            .DATALENGTH(8)
        )i_bitonic_8(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .sign_ctrl_o    (sign_ctrl_fe_out[i]),
            .x_i            (x_i[8*i+:8]),
            .y_o            (fe_out[8*i+:8])
        );
    end

    /********************/
    /*     Backend      */
    /********************/

    bitonic_16_be #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_16_be(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_fe_out[0]),
        .sign_ctrl_o    (sign_ctrl_o),
        .x_i            (fe_out),
        .y_o            (y_o)
    );

endmodule
