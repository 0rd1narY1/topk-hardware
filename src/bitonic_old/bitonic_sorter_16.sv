// 16-input bitonic sorter
module bitonic_sorter_16 #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 16
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  logic                    sign_ctrl_i,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]    y_o[DATALENGTH-1:0]
);

    /*************/
    /** Stage 1 **/
    /*************/

    logic [DATAWIDTH-1:0] stage_1_out[DATALENGTH-1:0];
    
    for(genvar i = 0; i < 8; i++) begin:stage_1_block
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (x_i[i]),
            .x2_i           (x_i[i+8]),
            .y1_o           (stage_1_out[i]),
            .y2_o           (stage_1_out[i+8])
        );
    end:stage_1_block

    /*************/
    /** Stage 2 **/
    /*************/
    logic [DATAWIDTH-1:0] stage_2_out[DATALENGTH-1:0];
    
    for(genvar i = 0; i < 4; i++) begin:stage_2_block
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_1_out[i]),
            .x2_i           (stage_1_out[i+4]),
            .y1_o           (stage_2_out[i]),
            .y2_o           (stage_2_out[i+4])
        );
    
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_1_out[i+8]),
            .x2_i           (stage_1_out[i+12]),
            .y1_o           (stage_2_out[i+8]),
            .y2_o           (stage_2_out[i+12])
        );
    end:stage_2_block

    /*************/
    /** Stage 3 **/
    /*************/
    logic [DATAWIDTH-1:0] stage_3_out[DATALENGTH-1:0];
    
    for(genvar i = 0; i < 13; i += 4) begin:stage_3_block
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_out[i]),
            .x2_i           (stage_2_out[i+2]),
            .y1_o           (stage_3_out[i]),
            .y2_o           (stage_3_out[i+2])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_out[i+1]),
            .x2_i           (stage_2_out[i+3]),
            .y1_o           (stage_3_out[i+1]),
            .y2_o           (stage_3_out[i+3])
        );
    end:stage_3_block

    /*************/
    /** Stage 4 **/
    /*************/
    logic [DATAWIDTH-1:0] stage_4_out[DATALENGTH-1:0];
    
    for(genvar i = 0; i < 15; i += 2) begin:stage_4_block
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_4(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_3_out[i]),
            .x2_i           (stage_3_out[i+1]),
            .y1_o           (stage_4_out[i]),
            .y2_o           (stage_4_out[i+1])
        );
    end:stage_4_block

    assign y_o = stage_4_out;

endmodule 
