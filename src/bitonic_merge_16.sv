//Convert arbitrary list to a bitonic list. Match with the bitonic sorter.
module bitonic_merge_16 #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 16
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  logic                    sign_ctrl_i,
    input  logic [DATAWIDTH-1:0]    origin_i[DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]    convert_o[DATALENGTH-1:0]
);

    /*************/
    /** Stage 1 **/
    /*************/ 
    logic [DATAWIDTH-1:0] stage_1_out[DATALENGTH-1:0];

    for(genvar i = 0; i <13; i += 4) begin:stage_1_block
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_1_up_down(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (origin_i[i]),
            .x2_i           (origin_i[i+1]),
            .y1_o           (stage_1_out[i]),
            .y2_o           (stage_1_out[i+1])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_1_down_up(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (origin_i[i+3]),
            .x2_i           (origin_i[i+2]),
            .y1_o           (stage_1_out[i+3]),
            .y2_o           (stage_1_out[i+2])
        );
    end:stage_1_block

    /*************/
    /** Stage 2 **/
    /*************/
    logic [DATAWIDTH-1:0] stage_2_out[DATALENGTH-1:0];
    logic [DATAWIDTH-1:0] stage_2_intermediate_out[DATALENGTH-1:0];

    for(genvar i = 0; i < 2; i++) begin:stage_2_block
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_up_down_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_1_out[8*i]),
            .x2_i           (stage_1_out[8*i+2]),
            .y1_o           (stage_2_intermediate_out[8*i]),
            .y2_o           (stage_2_intermediate_out[8*i+2])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_up_down_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_1_out[8*i+1]),
            .x2_i           (stage_1_out[8*i+3]),
            .y1_o           (stage_2_intermediate_out[8*i+1]),
            .y2_o           (stage_2_intermediate_out[8*i+3])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_up_down_3(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_intermediate_out[8*i]),
            .x2_i           (stage_2_intermediate_out[8*i+1]),
            .y1_o           (stage_2_out[8*i]),
            .y2_o           (stage_2_out[8*i+1])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_up_down_4(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_intermediate_out[8*i+2]),
            .x2_i           (stage_2_intermediate_out[8*i+3]),
            .y1_o           (stage_2_out[8*i+2]),
            .y2_o           (stage_2_out[8*i+3])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_down_up_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_1_out[8*i+7]),
            .x2_i           (stage_1_out[8*i+5]),
            .y1_o           (stage_2_intermediate_out[8*i+7]),
            .y2_o           (stage_2_intermediate_out[8*i+5])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_down_up_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_1_out[8*i+6]),
            .x2_i           (stage_1_out[8*i+4]),
            .y1_o           (stage_2_intermediate_out[8*i+6]),
            .y2_o           (stage_2_intermediate_out[8*i+4])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_down_up_3(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_intermediate_out[8*i+5]),
            .x2_i           (stage_2_intermediate_out[8*i+4]),
            .y1_o           (stage_2_out[8*i+5]),
            .y2_o           (stage_2_out[8*i+4])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_2_down_up_4(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_intermediate_out[8*i+7]),
            .x2_i           (stage_2_intermediate_out[8*i+6]),
            .y1_o           (stage_2_out[8*i+7]),
            .y2_o           (stage_2_out[8*i+6])
        );
    end:stage_2_block

    /*************/
    /** Stage 3 **/
    /*************/
    logic [DATAWIDTH-1:0] stage_3_out[DATALENGTH-1:0];
    logic [DATAWIDTH-1:0] stage_3_intermediate_1_out[DATALENGTH-1:0];
    logic [DATAWIDTH-1:0] stage_3_intermediate_2_out[DATALENGTH-1:0];

    for(genvar i = 0; i < 4; i++) begin:stage_3_block_1
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_up_down_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_out[i]),
            .x2_i           (stage_2_out[i+4]),
            .y1_o           (stage_3_intermediate_1_out[i]),
            .y2_o           (stage_3_intermediate_1_out[i+4])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_down_up_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_2_out[i+12]),
            .x2_i           (stage_2_out[i+8]),
            .y1_o           (stage_3_intermediate_1_out[i+12]),
            .y2_o           (stage_3_intermediate_1_out[i+8])
        );
    end:stage_3_block_1

    for(genvar i = 0; i < 5; i += 4) begin:stage_3_block_2
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_up_down_2_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_3_intermediate_1_out[i]),
            .x2_i           (stage_3_intermediate_1_out[i+2]),
            .y1_o           (stage_3_intermediate_2_out[i]),
            .y2_o           (stage_3_intermediate_2_out[i+2])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_up_down_2_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_3_intermediate_1_out[i+1]),
            .x2_i           (stage_3_intermediate_1_out[i+3]),
            .y1_o           (stage_3_intermediate_2_out[i+1]),
            .y2_o           (stage_3_intermediate_2_out[i+3])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_down_up_2_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_3_intermediate_1_out[i+10]),
            .x2_i           (stage_3_intermediate_1_out[i+8]),
            .y1_o           (stage_3_intermediate_2_out[i+10]),
            .y2_o           (stage_3_intermediate_2_out[i+8])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_down_up_2_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_3_intermediate_1_out[i+11]),
            .x2_i           (stage_3_intermediate_1_out[i+9]),
            .y1_o           (stage_3_intermediate_2_out[i+11]),
            .y2_o           (stage_3_intermediate_2_out[i+9])
        );
    end:stage_3_block_2

    for(genvar i = 0; i < 8; i += 2) begin:stage_3_block_3
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_up_down_3(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_3_intermediate_2_out[i]),
            .x2_i           (stage_3_intermediate_2_out[i+1]),
            .y1_o           (stage_3_out[i]),
            .y2_o           (stage_3_out[i+1])
        );

        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_stage_3_down_up_3(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .x1_i           (stage_3_intermediate_2_out[i+9]),
            .x2_i           (stage_3_intermediate_2_out[i+8]),
            .y1_o           (stage_3_out[i+9]),
            .y2_o           (stage_3_out[i+8])
        );
    end:stage_3_block_3

    assign convert_o = stage_3_out;

endmodule
