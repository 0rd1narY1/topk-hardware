//Sorter's package, including all the value types used in the design.

package sorter_pkg;

    //Parameters 
    localparam int unsigned DATAWIDTH = 8;
    localparam int unsigned MAX_DATALENGTH = 32;
    //How many sorters are there?
    //Every sub-sorters should have a output port to implement parallel.
    localparam int unsigned NUM_4_SORTER  = MAX_DATALENGTH / 4;
    localparam int unsigned NUM_8_SORTER  = MAX_DATALENGTH / 8;
    localparam int unsigned NUM_16_SORTER = MAX_DATALENGTH / 16;
    localparam int unsigned NUM_32_SORTER = MAX_DATALENGTH / 32;

    // Data input interface 
    typedef struct{
        //Is signed/unsigned?
        logic sign_ctrl;
        //Indicate which channel is valid data channel. 
        //0: all the channels are invalid; 1: data_4; 2: data_8;
        //3: data_16; 4: data_32.
        logic [2:0]channel;
    }ctrl_t;
    
    // Data output interface 
    typedef struct{
        logic [DATAWIDTH-1:0]data_4[3:0];
        logic [DATAWIDTH-1:0]data_8[7:0];
        logic [DATAWIDTH-1:0]data_16[15:0];
        logic [DATAWIDTH-1:0]data_32[31:0];
    }data_o_t;

    //Sorter top module I/O, including data_valid channel.
    typedef struct{
        data_o_t data;
        //Indicate which channel is valid data channel. 
        //0: all the channels are invalid; 1: data_4; 2: data_8;
        //3: data_16; 4: data_32.
        logic [2:0]channel;  
    }sorter_top_io_t;

endpackage
