// Sorter's top module, enabling input/output in different data length and groups. 
// A 32-input bitonic sorter which includes 8 4-input, 4 8-input and 2 16-input bitonic sorters is instantiated. 
// Input can have any length <= 20.
// Input data length will be extended to power-of-2 such as 4,8,16,32, and then input the extended lists to 
// the bitonic sorters, and get a sorted output in different cycles according to its length.

module sorter_top import topk_pkg::*; #(
    parameter DATAWIDTH      = 8,
    parameter MAX_DATALENGTH = 32
) (
    input  logic                   clk_i,
    input  logic                   rstn_i,
    input  logic                   sign_ctrl_i,
    input  logic [5:0]             total_length_i,
    input  logic [3:0]             total_group_i, //Parallel input group to be sorted
    input  logic [DATAWIDTH-1:0]   x_i[MAX_DATALENGTH-1:0],
    output sorter_top_io_t         y_o
);

    /*************************/ 
    /* Data Length Extension */ 
    /************************/ 
    
    logic [DATAWIDTH-1:0]data_extended[MAX_DATALENGTH-1:0];
    //length_per_group --> extend --> length_per_group_extend
    logic [5:0]length_per_group, length_per_group_extend; 
    logic [DATAWIDTH-1:0]fill_value_unsigned = {{DATAWIDTH{1'b1}}};
    logic [DATAWIDTH-1:0]fill_value_signed = $signed({1'b0,{(DATAWIDTH-1){1'b1}}});
    

    /*******************/ 
    /* Bitonic Sorters */ 
    /*******************/ 
    ctrl_t ctrl_in, ctrl_out;
    data_o_t sorter_out;

    bitonic_32 #(
        .DATAWIDTH(DATAWIDTH),
        .DATALENGTH(MAX_DATALENGTH)
    )i_bitonic_32(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .ctrl_i         (ctrl_in),
        .ctrl_o         (ctrl_out),
        .x_i            (data_extended),
        .y_o            (sorter_out)
    );

    assign y_o.data = sorter_out;
    assign y_o.channel = ctrl_out.channel;

    /****************/ 
    /* Sorter Logic */ 
    /****************/

    always_comb begin:sorter 
        //default value
        data_extended = '{MAX_DATALENGTH{0}};
        length_per_group = total_length_i / total_group_i;
        length_per_group_extend = 0;
        ctrl_in.sign_ctrl = sign_ctrl_i;
        ctrl_in.channel = '{'h0, 'h0, 'h0, 'h0};

        //Data channel selection 
        if(length_per_group >= 17) begin 
            length_per_group_extend = 32;
            ctrl_in.channel.channel_32 = 1;
        end
        else if(length_per_group >= 9 && length_per_group <= 16) begin 
            length_per_group_extend = 16;
            //1 group if 16 inputs or 2 groups of 16 inputs?
            ctrl_in.channel.channel_16 = (total_group_i == 2)? 2'b11 : 2'b01;
        end 
        else if(length_per_group >= 5 && length_per_group <= 8) begin 
            length_per_group_extend = 8;
            case(total_group_i)
                1:       ctrl_in.channel.channel_8 = 4'b0001;
                2:       ctrl_in.channel.channel_8 = 4'b0011;
                3:       ctrl_in.channel.channel_8 = 4'b0111;
                4:       ctrl_in.channel.channel_8 = 4'b1111;
                default: ctrl_in.channel.channel_8 = 4'b0;
            endcase
        end 
        else if(length_per_group > 0 && length_per_group <= 4) begin 
            length_per_group_extend = 4;
            case(total_group_i)
                1:       ctrl_in.channel.channel_4 = 8'b00000001;
                2:       ctrl_in.channel.channel_4 = 8'b00000011;
                3:       ctrl_in.channel.channel_4 = 8'b00000111;
                4:       ctrl_in.channel.channel_4 = 8'b00001111;
                5:       ctrl_in.channel.channel_4 = 8'b00011111;
                6:       ctrl_in.channel.channel_4 = 8'b00111111;
                7:       ctrl_in.channel.channel_4 = 8'b01111111;
                8:       ctrl_in.channel.channel_4 = 8'b11111111;
                default: ctrl_in.channel.channel_4 = 8'b0;
            endcase
        end

        //Data length extension 
        case(length_per_group_extend)
            4: begin
                for(int group = 0; group < 8; group++) begin 
                    if(group < total_group_i) begin 
                        for(int i = 0; i < 4; i++) begin 
                            if(i < length_per_group)
                                data_extended[i+4*group] = x_i[i+4*group]; //original value
                            else begin
                                data_extended[i+4*group] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
                            end
                        end
                    end
                end
                for(int i = 4*total_group_i; i < MAX_DATALENGTH; i++)
                    data_extended[i] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
            end
            8: begin
                for(int group = 0; group < 4; group++) begin 
                    if(group < total_group_i) begin 
                        for(int i = 0; i < 8; i++) begin 
                            if(i < length_per_group)
                                data_extended[i+8*group] = x_i[i+8*group]; //original value
                            else begin
                                data_extended[i+8*group] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
                            end
                        end
                    end
                end
                for(int i = 8*total_group_i; i < MAX_DATALENGTH; i++)
                    data_extended[i] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
            end
            16: begin
                for(int group = 0; group < 2; group++) begin 
                    if(group < total_group_i) begin 
                        for(int i = 0; i < 16; i++) begin 
                            if(i < length_per_group)
                                data_extended[i+16*group] = x_i[i+16*group]; //original value
                            else begin
                                data_extended[i+16*group] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
                            end
                        end
                    end
                end
                for(int i = 16*total_group_i; i < MAX_DATALENGTH; i++)
                    data_extended[i] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
            end
            32: begin
                for(int i = 0; i < 32; i++) begin 
                    if(i < length_per_group)
                        data_extended[i] = x_i[i]; //original value
                    else begin
                        data_extended[i] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
                    end
                end
            end
            default: begin
                for(int i = 0; i < MAX_DATALENGTH; i++) begin
                    if(i < total_length_i)
                        data_extended[i] = x_i[i]; //original value
                    else begin
                        data_extended[i] = sign_ctrl_i?fill_value_signed:fill_value_unsigned; //extend value
                    end
                end
            end
        endcase
        
    end:sorter

endmodule
