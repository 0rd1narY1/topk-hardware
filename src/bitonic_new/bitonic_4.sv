// 4-input bitonic sorter, which can be the frontend of an 8-input bitonic sorter.

module bitonic_4 #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 4
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
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_4_fe(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_i),
            .sign_ctrl_o    (sign_ctrl_fe_out[i]),
            .x1_i           (x_i[2*i]),
            .x2_i           (x_i[2*i+1]),
            .y1_o           (fe_out[2*i]),
            .y2_o           (fe_out[2*i+1])
        );
    end
    
    /********************/
    /*     Backend      */
    /********************/ 
    
    logic [DATAWIDTH-1:0] stage_1_out[DATALENGTH-1:0];
    logic sign_ctrl_be_stage_1_out;
    logic [1:0]sign_ctrl_be_stage_2_out;

    //Stage 1 
    cas #(
        .DATAWIDTH(DATAWIDTH)
    )i_cas_4_be_stage_1_1(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_fe_out[0]),
        .sign_ctrl_o    (sign_ctrl_be_stage_1_out),
        .x1_i           (fe_out[0]),
        .x2_i           (fe_out[3]),
        .y1_o           (stage_1_out[0]),
        .y2_o           (stage_1_out[3])
    );

    cas #(
        .DATAWIDTH(DATAWIDTH)
    )i_cas_4_be_stage_1_2(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_fe_out[0]),
        .sign_ctrl_o    (/*Unused*/),
        .x1_i           (fe_out[1]),
        .x2_i           (fe_out[2]),
        .y1_o           (stage_1_out[1]),
        .y2_o           (stage_1_out[2])
    );
    
    //Stage 2 
    for(genvar i = 0; i < 2; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_4_be_stage_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .sign_ctrl_i    (sign_ctrl_be_stage_1_out),
            .sign_ctrl_o    (sign_ctrl_be_stage_2_out[i]),
            .x1_i           (stage_1_out[2*i]),
            .x2_i           (stage_1_out[2*i+1]),
            .y1_o           (y_o[2*i]),
            .y2_o           (y_o[2*i+1])
        );
    end

    assign sign_ctrl_o = sign_ctrl_be_stage_2_out[0];

endmodule
