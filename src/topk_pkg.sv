//Sorter's package, including all the value types used in the design.

package topk_pkg;

    //Parameters 
    localparam int unsigned DATAWIDTH = 8;
    localparam int unsigned MAX_DATALENGTH = 32;
    //How many sorters are there?
    //Every sub-sorters should have a output port to implement parallel.
    localparam int unsigned NUM_4_SORTER  = MAX_DATALENGTH / 4;
    localparam int unsigned NUM_8_SORTER  = MAX_DATALENGTH / 8;
    localparam int unsigned NUM_16_SORTER = MAX_DATALENGTH / 16;
    localparam int unsigned NUM_32_SORTER = MAX_DATALENGTH / 32;

    // Channel selection signal
    typedef struct{
        //Each channel has its own selection signal
        logic [7:0]channel_4;
        logic [3:0]channel_8;
        logic [1:0]channel_16;
        logic      channel_32;
    }channel_t;

    // Control signal interface 
    typedef struct{
        //Is signed/unsigned?
        logic sign_ctrl;
        channel_t channel;
    }ctrl_t;
    
    // Data output interface 
    typedef struct{
        logic [DATAWIDTH-1:0]data_4[NUM_4_SORTER-1:0][3:0];
        logic [DATAWIDTH-1:0]data_8[NUM_8_SORTER-1:0][7:0];
        logic [DATAWIDTH-1:0]data_16[NUM_16_SORTER-1:0][15:0];
        logic [DATAWIDTH-1:0]data_32[NUM_32_SORTER-1:0][31:0];
    }data_o_t;

    //Sorter top module I/O, including data_valid channel.
    typedef struct{
        data_o_t data;
        channel_t channel;  
    }sorter_top_io_t;

endpackage
