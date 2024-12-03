//Bitonic merge + sorter. Implement any list sorting.
module bitonic_16 #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 16
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  logic                    sign_ctrl_i,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]    y_o[DATALENGTH-1:0]
);

    logic [DATAWIDTH-1:0] convert_list[DATALENGTH-1:0];
    
    bitonic_merge_16 #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_merge_16(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_i),
        .origin_i       (x_i),
        .convert_o      (convert_list)
    );

    bitonic_sorter_16 #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_sorter_16(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_i),
        .x_i            (convert_list),
        .y_o            (y_o)
    );

endmodule
