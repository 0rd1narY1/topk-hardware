// 8-input bitonic sorter, composed of 2 4-input sorters and an 8-input backend.

module bitonic_8 import sorter_pkg::*; #(
    parameter DATAWIDTH  = 8,
    parameter DATALENGTH = 8
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  ctrl_t                   ctrl_i,
    output ctrl_t                   ctrl_o,
    input  logic [DATAWIDTH-1:0]    x_i[DATALENGTH-1:0],
    output data_o_t                y_o
);

    /********************/
    /*     Frontend     */
    /********************/ 
    data_o_t fe_out[1:0]; //Two 4-input sorters respectively
    logic [DATAWIDTH-1:0]fe_8_out[DATALENGTH-1:0];
    ctrl_t ctrl_fe_out[1:0];
    
    for(genvar i = 0; i < 2; i++) begin
        bitonic_4 #(
            .DATAWIDTH(DATAWIDTH),
            .DATALENGTH(4)
        )i_bitonic_4(
            .clk_i          (clk_i),
            .rstn_i         (rstn_i),
            .ctrl_i         (ctrl_i),
            .ctrl_o         (ctrl_fe_out[i]),
            .x_i            (x_i[4*i+:4]),
            .y_o            (fe_out[i])
        );
        
        //Gather sub-modules'data to the father module's output port.
        assign y_o.data_4[i] = fe_out[i].data_4[0];
    end

    assign fe_8_out = {fe_out[1].data_4[0], fe_out[0].data_4[0]};

    /********************/
    /*     Backend      */
    /********************/ 

    bitonic_8_be #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(DATALENGTH)
    )i_bitonic_8_be(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .ctrl_i         (ctrl_fe_out[0]),
        .ctrl_o         (ctrl_o),
        .x_i            (fe_8_out),
        .y_o            (y_o.data_8[0])
    );

endmodule
