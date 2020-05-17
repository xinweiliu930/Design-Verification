`include "uvm_macros.svh"
package coverage;
import sequences::*;
import uvm_pkg::*;

class alu_subscriber_in extends uvm_subscriber #(alu_transaction_in);
    `uvm_component_utils(alu_subscriber_in)

    //Declare Variables
    logic [31:0] A;
    logic [31:0] B;
    logic [4:0] opcode;
    logic cin;

    //TODO: Add covergroups for the inputs
    covergroup inputs;
        
        input_A:coverpoint A 
          {
              bins samA1 = {32'hFFFFFFFF};
              bins samA2 = {32'h00000000};
              bins samA3 = {32'h80000000};
              bins samA4 = {32'h7FFFFFFF};
              bins samA5 = {32'hAAAAAAAA};
              bins samA6 = {32'h55555555};
              bins samA7 = {32'h5A5A5A5A};
              bins samA8 = {32'h0A050A05};
           }
        input_B:coverpoint B 
          {
              bins samB1 = {32'hAAAAAAAA};
              bins samB2 = {32'h7FFFFFFF};
              bins samB3 = {32'hFFFFFFFF};
              bins samB4 = {32'h050A050A};
              bins samB5 = {32'h80000000};
              bins samB6 = {32'h00000001};
              bins samB7 = {32'h00000000};
           }
        cinput: coverpoint cin
          {
              bins one = {1'b1};
              bins zero = {1'b0};
          }
        input_opcode: coverpoint opcode
          {
              bins op_1ogic = { 5'b00000, 5'b00011, 5'b00101, 5'b00111};
              bins op_compare = { 5'b01001, 5'b01010, 5'b01011, 5'b01100, 5'b01110, 5'b01111};
              bins op_arithmetic = { 5'b10000, 5'b10001, 5'b10100, 5'b10101, 5'b10110, 5'b10111};
              bins op_shift = { 5'b11000, 5'b11001, 5'b11010, 5'b11011, 5'b11100, 5'b11101};
           }

         xl1:cross input_A, input_opcode;
         xl2:cross input_B, input_opcode;
         xl3:cross input_A, input_B, input_opcode, cinput;



    endgroup: inputs
    

    function new(string name, uvm_component parent);
        super.new(name,parent);
        /* TODO: Uncomment
        */inputs=new;
        
    endfunction: new

    function void write(alu_transaction_in t);
        A={t.A};
        B={t.B};
        opcode={t.opcode};
        cin={t.CIN};
        /* TODO: Uncomment
        */ inputs.sample();
        
    endfunction: write

endclass: alu_subscriber_in

class alu_subscriber_out extends uvm_subscriber #(alu_transaction_out);
    `uvm_component_utils(alu_subscriber_out)

    logic [31:0] out;
    logic cout;
    logic vout;

    //TODO: Add covergroups for the outputs
    /**/
    covergroup outputs;
        coutput: coverpoint cout;
        voutput: coverpoint vout;
        out_C: coverpoint out;
    endgroup: outputs
    

function new(string name, uvm_component parent);
    super.new(name,parent);
    /* TODO: Uncomment
    */ outputs=new;
    
endfunction: new

function void write(alu_transaction_out t);
    out={t.OUT};
    cout={t.COUT};
    vout={t.VOUT};
    //TODO: Uncomment
    outputs.sample();
    
endfunction: write
endclass: alu_subscriber_out

endpackage: coverage