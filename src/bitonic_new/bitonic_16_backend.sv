// 16-input bitonic sorter's backend which is also 16-input.

module bitonic_16_be import topk_pkg::*;#(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 16
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
    ctrl_t ctrl_stage_1_out[7:0];

    for(genvar i = 0; i < 8; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_16_be_stage_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_i),
            .ctrl_o         (ctrl_stage_1_out[i]),
            .x1_i           (x_i[i]),
            .x2_i           (x_i[15-i]),
            .y1_o           (stage_1_out[i]),
            .y2_o           (stage_1_out[15-i])
        );
    end
    
    /*************/
    /** Stage 2 **/
    /*************/ 
    logic [DATAWIDTH-1:0] stage_2_out[DATALENGTH-1:0];
    ctrl_t ctrl_stage_2_out[3:0];

    for(genvar i = 0; i < 4; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_16_be_stage_2_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_stage_1_out[0]),
            .ctrl_o         (ctrl_stage_2_out[i]),
            .x1_i           (stage_1_out[i]),
            .x2_i           (stage_1_out[i+4]),
            .y1_o           (stage_2_out[i]),
            .y2_o           (stage_2_out[i+4])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_16_be_stage_2_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_stage_1_out[0]),
            .ctrl_o         (/*Unused*/),
            .x1_i           (stage_1_out[i+8]),
            .x2_i           (stage_1_out[i+12]),
            .y1_o           (stage_2_out[i+8]),
            .y2_o           (stage_2_out[i+12])
        );
    end

    /*************/
    /** Stage 3 **/
    /*************/ 
    logic [DATAWIDTH-1:0] stage_3_out[DATALENGTH-1:0];
    ctrl_t ctrl_stage_3_out[3:0];

    for(genvar i = 0; i < 4; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_16_be_stage_3_1(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_stage_2_out[0]),
            .ctrl_o         (ctrl_stage_3_out[i]),
            .x1_i           (stage_2_out[4*i]),
            .x2_i           (stage_2_out[4*i+2]),
            .y1_o           (stage_3_out[4*i]),
            .y2_o           (stage_3_out[4*i+2])
        );
        
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_16_be_stage_3_2(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_stage_2_out[0]),
            .ctrl_o         (/*Unused*/),
            .x1_i           (stage_2_out[4*i+1]),
            .x2_i           (stage_2_out[4*i+3]),
            .y1_o           (stage_3_out[4*i+1]),
            .y2_o           (stage_3_out[4*i+3])
        );
    end

    /*************/
    /** Stage 4 **/
    /*************/ 
    ctrl_t ctrl_stage_4_out[7:0];

    for(genvar i = 0; i < 8; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_16_be_stage_4(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_stage_3_out[0]),
            .ctrl_o         (ctrl_stage_4_out[i]),
            .x1_i           (stage_3_out[2*i]),
            .x2_i           (stage_3_out[2*i+1]),
            .y1_o           (y_o[2*i]),
            .y2_o           (y_o[2*i+1])
        );
    end

    assign ctrl_o = ctrl_stage_4_out[0];

endmodule

