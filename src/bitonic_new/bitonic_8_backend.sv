// 8-input bitonic sorter's backend which is also 8-input.

module bitonic_8_be import topk_pkg::*; #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 8
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  ctrl_t                   ctrl_i,
    output ctrl_t                   ctrl_o,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]    y_o[DATALENGTH-1:0]
);
    
    
    /*************/
    /** Stage 1 **/
    /*************/ 
    logic [DATAWIDTH-1:0] stage_1_out[DATALENGTH-1:0];
    ctrl_t ctrl_stage_1_out[3:0];

    for(genvar i = 0; i < 4; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_8_be_stage_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_i),
            .ctrl_o         (ctrl_stage_1_out[i]),
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
    ctrl_t ctrl_stage_2_out[1:0];
    
    for(genvar i = 0; i < 2; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_8_be_stage_2_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_stage_1_out[0]),
            .ctrl_o         (ctrl_stage_2_out[i]),
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
            .ctrl_i         (ctrl_stage_1_out[0]),
            .ctrl_o         (/*Unused*/),
            .x1_i           (stage_1_out[i+4]),
            .x2_i           (stage_1_out[i+6]),
            .y1_o           (stage_2_out[i+4]),
            .y2_o           (stage_2_out[i+6])
        );
    end

    /*************/
    /** Stage 3 **/
    /*************/ 
    ctrl_t ctrl_stage_3_out[3:0];

    for(genvar i = 0; i < 4; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_8_be_stage_3(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_stage_2_out[0]),
            .ctrl_o         (ctrl_stage_3_out[i]),
            .x1_i           (stage_2_out[2*i]),
            .x2_i           (stage_2_out[2*i+1]),
            .y1_o           (y_o[2*i]),
            .y2_o           (y_o[2*i+1])
        );
    end

    assign ctrl_o = ctrl_stage_3_out[0];

endmodule
