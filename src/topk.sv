// Top-k module. It has almost the same input interfaces as sorter_top except
// 'k' ports. It selects k values from the sorted lists according to the input 'k', 
// and output them.
// TODO: 顺序输入但结果可能顺序混乱，要将排序结果和输入顺序对应起来。可以采用
// id编号，把id也送进流水线传播。
module topk import topk_pkg::*; #(
    parameter DATAWIDTH      = 8,
    parameter MAX_DATALENGTH = 32
)(
    input  logic                   clk_i,
    input  logic                   rstn_i,
    input  logic                   sign_ctrl_i,
    input  logic [5:0]             k_i,
    input  logic [5:0]             total_length_i,
    input  logic [3:0]             total_group_i, //Parallel input group to be sorted
    input  logic [DATAWIDTH-1:0]   x_i[MAX_DATALENGTH-1:0],
    output logic [DATAWIDTH-1:0]   y_o[3:0][MAX_DATALENGTH-1:0]
);

    /*****************/ 
    /*  Sorter Top  */ 
    /****************/ 

    sorter_top_io_t sorted_data;
    
    sorter_top i_sorter_top(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .sign_ctrl_i    (sign_ctrl_i),
        .total_length_i (total_length_i),
        .total_group_i  (total_group_i),
        .x_i            (x_i),
        .y_o            (sorted_data)
    );

    /***********/ 
    /*  Top-K  */ 
    /***********/

    always_comb begin:topk 
        
        // Channel_4 top k
        case(sorted_data.channel.channel_4)
            8'b00000001:
            8'b00000011:
            8'b00000111:
            8'b00001111:
            8'b00011111:
            8'b00111111:
            8'b01111111:
            8'b11111111:
            default:
        endcase
       
        // Channel_8 top k 
        case()
            4'b0001:
            4'b0011:
            4'b0111:
            4'b1111:
            default:
        endcase

        // Channel_16 top k
        case(sorted_data.channel.channel_16)
            2'b01: begin
                for(int i = 0; i < MAX_DATALENGTH-1; i++) begin
                    if(i < 16 && i < k_i)
                        y_o[1][i] = sorted_data.data_16[0][i];
                    else 
                        y_o[1][i] = 'h0;
                end
            end
            2'b11: begin
                for(int i = 0; i < MAX_DATALENGTH-1; i++) begin
                    if(i < 16 && i < k_i) begin 
                        y_o[1][i]    = sorted_data.data_16[0][i];
                        y_o[1][i+16] = sorted_data.data_16[1][i];
                    end else begin 
                        y_o[1][i]    = 'h0;
                        y_o[1][i+16] = 'h0;
                    end
                end
            end
            default: begin
                y_o[1] = '{MAX_DATALENGTH{0}};
            end
        endcase
       
        // Channel_32 top k
        if(sorted_data.channel.channel_32) begin
            for(int i = 0; i < MAX_DATALENGTH-1; i++) begin
                if(i < k_i)
                    y_o[0][i] = sorted_data.data_32[0][i];
                else 
                    y_o[0][i] = 'h0;
            end
        end
        else begin
            y_o[0] = '{MAX_DATALENGTH{0}};
        end

    end:topk



endmodule
