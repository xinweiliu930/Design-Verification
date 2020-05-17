//EE382M-Verification of Digital Systems
//Lab 4 - Formal Property Verification
//
//
//APB paramters

// APB FSM states
localparam IDLE      = 2'b00;
localparam SETUP     = 2'b01;
localparam ACCESS    = 2'b10;
localparam UNKNOWN   = 2'b11;

// Reset values of the registers
localparam RST_VAL_BYPASS_REG   = 1'b0;
localparam RST_VAL_REQ_REG      = 4'b0000; 
localparam RST_VAL_ARB_TYPE_REG = 3'b100;

// Address values of the registers
localparam ADDR_BYPASS_REG   = 8'h10;
localparam ADDR_REQ_REG      = 8'h14;
localparam ADDR_ARB_TYPE_REG = 8'h1C;

