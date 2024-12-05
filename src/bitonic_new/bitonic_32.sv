// 32-input bitonic sorter, composed of 2 16-input sorters and an 32-input backend.

module bitonic_32 #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 32
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  logic                    sign_ctrl_i,
    //output logic                    sign_ctrl_o, //maybe it's unnecessary
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]    y_o[DATALENGTH-1:0]
);

    /********************/
    /*     Frontend     */
    /********************/

    logic [DATAWIDTH-1:0] fe_out[DATALENGTH-1:0];
    logic [1:0]sign_ctrl_fe_out;
    
    for(genvar i = 0; i < 2; i++) begin
        bitonic_16 #(
            .DATAWIDTH(DATAWIDTH),
            .DATALENGTH(16)
        )i_bitonic_16(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .sign_ctrl_o    (sign_ctrl_fe_out[i]),
            .x_i            (x_i[16*i+:16]),
            .y_o            (fe_out[16*i+:16])
        );
    end

    /********************/
    /*     Backend      */
    /********************/

    bitonic_32_be #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_32_be(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_fe_out[0]),
        .sign_ctrl_o    (/*Unused*/),
        .x_i            (fe_out),
        .y_o            (y_o)
    );

endmodule
