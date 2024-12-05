// 8-input bitonic sorter's backend which is also 8-input.

module bitonic_8_be #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 8
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  logic                    sign_ctrl_i,
    output logic                    sign_ctrl_o,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]    y_o[DATALENGTH-1:0]
);
    
    
    /*************/
    /** Stage 1 **/
    /*************/ 
    logic [DATAWIDTH-1:0] stage_1_out[DATALENGTH-1:0];
    logic [3:0]sign_ctrl_stage_1_out;

    for(genvar i = 0; i < 4; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_8_be_stage_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .sign_ctrl_o    (sign_ctrl_stage_1_out[i]),
            .x1_i           (x_i[i]),
            .x2_i           (x_i[7-i]),
            .y1_o           (stage_1_out[i]),
            .y2_o           (stage_1_out[7-i])
        );
    end
    
    /*************/
    /** Stage 2 **/
    /*************/ 
    logic [DATAWIDTH-1:0] stage_2_out[DATALENGTH-1:0];
    logic [1:0]sign_ctrl_stage_2_out;
    
    for(genvar i = 0; i < 2; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_8_be_stage_2_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_stage_1_out[0]),
            .sign_ctrl_o    (sign_ctrl_stage_2_out[i]),
            .x1_i           (stage_1_out[i]),
            .x2_i           (stage_1_out[i+2]),
            .y1_o           (stage_2_out[i]),
            .y2_o           (stage_2_out[i+2])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_8_be_stage_2_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_stage_1_out[0]),
            .sign_ctrl_o    (/*Unused*/),
            .x1_i           (stage_1_out[i+4]),
            .x2_i           (stage_1_out[i+6]),
            .y1_o           (stage_2_out[i+4]),
            .y2_o           (stage_2_out[i+6])
        );
    end

    /*************/
    /** Stage 3 **/
    /*************/ 
    logic [3:0]sign_ctrl_stage_3_out;

    for(genvar i = 0; i < 4; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_8_be_stage_3(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_stage_2_out[0]),
            .sign_ctrl_o    (sign_ctrl_stage_3_out[i]),
            .x1_i           (stage_2_out[2*i]),
            .x2_i           (stage_2_out[2*i+1]),
            .y1_o           (y_o[2*i]),
            .y2_o           (y_o[2*i+1])
        );
    end

    assign sign_ctrl_o = sign_ctrl_stage_3_out[0];

endmodule
