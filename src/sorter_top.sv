// Sorter's top module, enabling input/output in different data length. 
// A 32-input bitonic sorter which includes 16 4-input, 4 8-input and 2 16-input bitonic sorters is instantiated. Input can have any length <= 20.
// Input data length will be extended to power-of-2 such as 4,8,16,32, and then input the extended list to 
// the bitonic sorters, and get a sorted output in different cycles according to its length.

module sorter_top #(
    parameter DATAWIDTH      = 8,
    parameter MAX_DATALENGTH = 32
) (
    input  logic                   clk_i,
    input  logic                   rstn_i,
    input  logic                   sign_ctrl_i,
    input  logic [5:0]             in_data_length_i,
    input  logic [DATAWIDTH-1:0]   x_i[MAX_DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]   y_o[MAX_DATALENGTH-1:0]
);

    /*************************/ 
    /* Data Length Extension */ 
    /************************/ 
    
    logic [DATAWIDTH-1:0]data_extended[MAX_DATALENGTH-1:0];
    logic [DATAWIDTH-1:0]fill_value_unsigned = {{DATAWIDTH{1'b1}}};
    logic [DATAWIDTH-1:0]fill_value_signed = $signed({1'b0,{(DATAWIDTH-1){1'b1}}});
    
    always_comb begin 
        //default value
        data_extended = '{MAX_DATALENGTH{0}};

        for(int i = 0; i < MAX_DATALENGTH; i++) begin
            if(i < in_data_length_i)
                data_extended[i] = x_i[i]; //original value
            else begin
                data_extended[i] = sign_ctrl_i?fill_value_signed:fill_value_signed; //extend value
            end
        end
    end

    /*******************/ 
    /* Bitonic Sorters */ 
    /*******************/ 

    bitonic_32 #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(MAX_DATALENGTH)
    )i_bitonic_32(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_i),
        .x_i            (data_extended),
        .y_o            (y_o)
    );

endmodule
