// 4-input bitonic sorter, which can be the frontend of an 8-input bitonic sorter.

module bitonic_4 import topk_pkg::*; #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 4
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  ctrl_t                   ctrl_i,
    output ctrl_t                   ctrl_o,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    //output logic [DATAWIDTH-1:0]    y_o[DATALENGTH-1:0]
    output data_o_t                 y_o
);
    
    /********************/
    /*     Frontend     */
    /********************/ 

    logic [DATAWIDTH-1:0] fe_out[DATALENGTH-1:0];
    ctrl_t ctrl_fe_out[1:0];
    
    for(genvar i = 0; i < 2; i++) begin
        cas #(
            .DATAWIDTH(DATAWIDTH)
        )i_cas_4_fe(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_i),
            .ctrl_o         (ctrl_fe_out[i]),
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
    ctrl_t ctrl_be_stage_1_out;
    ctrl_t ctrl_be_stage_2_out[1:0];

    //Stage 1 
    cas #(
        .DATAWIDTH(DATAWIDTH)
    )i_cas_4_be_stage_1_1(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .ctrl_i         (ctrl_fe_out[0]),
        .ctrl_o         (ctrl_be_stage_1_out),
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
        .ctrl_i         (ctrl_fe_out[0]),
        .ctrl_o         (/*Unused*/),
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
            .ctrl_i         (ctrl_be_stage_1_out),
            .ctrl_o         (ctrl_be_stage_2_out[i]),
            .x1_i           (stage_1_out[2*i]),
            .x2_i           (stage_1_out[2*i+1]),
            .y1_o           (y_o.data_4[0][2*i]),
            .y2_o           (y_o.data_4[0][2*i+1])
        );
    end

    assign ctrl_o = ctrl_be_stage_2_out[0];

endmodule
