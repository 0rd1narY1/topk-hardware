// Basic 2-inputs Compare and Swap Unit

module cas #(
    parameter int DATAWIDTH = 8
)(
    input  logic                    clk_i,
    input  logic                    rstn_i,
    input  logic                    sign_ctrl_i, //0: unsigned, 1: signed
    input  logic [DATAWIDTH-1:0]    x1_i,
    input  logic [DATAWIDTH-1:0]    x2_i,
    output logic [DATAWIDTH-1:0]    y1_o,
    output logic [DATAWIDTH-1:0]    y2_o
);

    logic [DATAWIDTH-1:0] y1_d, y2_d;
    always_comb begin : compare_swap
        y1_d = 0;
        y2_d = 0;
        case (sign_ctrl_i)
            0: begin
                if(x1_i <= x2_i) begin
                    y1_d = x1_i;
                    y2_d = x2_i;
                end else begin
                    y1_d = x2_i;
                    y2_d = x1_i;
                end
            end
            1: begin
                if($signed(x1_i) <= $signed(x2_i)) begin
                    y1_d = x1_i;
                    y2_d = x2_i;
                end else begin
                    y1_d = x2_i;
                    y2_d = x1_i;
                end
            end
            default: begin
                    y1_d = x1_i;
                    y2_d = x2_i;
            end
        endcase
    end:compare_swap

    always_ff @(posedge clk_i, negedge rstn_i) begin 
        if(!rstn_i) begin
            y1_o <= '0;
            y2_o <= '0;
        end else begin
            y1_o <= y1_d;
            y2_o <= y2_d;
        end
    end

endmodule
