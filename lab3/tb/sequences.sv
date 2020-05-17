`include "uvm_macros.svh"
package sequences;

    import uvm_pkg::*;

    class alu_transaction_in extends uvm_sequence_item;
         // TODO: Register the  alu_transaction_in object. Hint: Look at other classes to find out what is missing.

        `uvm_object_utils(alu_transaction_in);

        rand logic [31:0] A;
        rand logic [31:0] B;
        rand logic [4:0] opcode;
        rand logic rst;
        rand logic CIN;

        //TODO: Add constraints here
        /*constraint cin_constraint
          {
            if ((rst == 0) && ((opcode == 5'b10000) || (opcode == 5'b10100)))
                
                     CIN == 1;
                 
           }
        constraint reset_sig
          {
               rst == 1'b1;
          }
       constraint logic_opcode
          {
             rst == 1'b0;
             opcode == 5'b00000 || opcode == 5'b00011 || opcode == 5'b00101 || opcode == 5'b00111;
          }
       constraint compare_opcode 
          {
             rst == 0;
             opcode == 5'b01001 || opcode == 5'b01010 || opcode == 5'b01011 || opcode == 5'b01100 || opcode == 5'b01110 || opcode == 5'b01111;
          }*/
        /* constraint arithmetic_opcode
          {
             rst == 0;
             opcode == 5'b10000 || opcode == 5'b10001 || opcode == 5'b10100 || opcode == 5'b10101 || opcode == 5'b10110 || opcode == 5'b10111;
          }	
        constraint shift_opcode
          {
             rst == 0;
             opcode == 5'b11000 || opcode == 5'b11001 || opcode == 5'b11010 || opcode == 5'b11011 || opcode == 5'b11100 || opcode == 5'b11101;
          }*/
         constraint no_opcode
          {
             rst == 0;
             opcode == 5'b00001 || opcode == 5'b00010 || opcode == 5'b00100 || opcode == 5'b00110 || opcode == 5'b01000 || opcode == 5'b01101 || opcode == 5'b10010 || opcode == 5'b10011 || opcode == 5'b11110 || opcode == 5'b11111; 
          }
        function new(string name = "");
            super.new(name);
        endfunction: new

        function string convert2string;
            convert2string={$sformatf("Operand A = %h, Operand B = %h, Opcode = %b, CIN = %b",A,B,opcode,CIN)};
        endfunction: convert2string

    endclass: alu_transaction_in


    class alu_transaction_out extends uvm_sequence_item;
        // TODO: Register the  alu_transaction_out object. Hint: Look at other classes to find out what is missing.
        `uvm_object_utils(alu_transaction_out);
        
        logic [31:0] OUT;
        logic COUT;
        logic VOUT;

        function new(string name = "");
            super.new(name);
        endfunction: new;
        
        function string convert2string;
            convert2string={$sformatf("OUT = %h, COUT = %b, VOUT = %b",OUT,COUT,VOUT)};
        endfunction: convert2string

    endclass: alu_transaction_out

    class simple_seq extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize());
            finish_item(tx);
        endtask: body
    endclass: simple_seq
/*  sequences what I added*/
     class simple_seq1 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq1)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'h00000000;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq1

     class simple_seq2 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq2)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'h80000000;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq2

     class simple_seq3 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq3)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'h7FFFFFFF;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq3

     class simple_seq4 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq4)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'hAAAAAAAA;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq4

     class simple_seq5 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq5)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'h55555555;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq5

     class simple_seq6 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq6)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'h5A5A5A5A;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq6

     class simple_seq7 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq7)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'h0A050A05;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq7

     class simple_seq8 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq8)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.A == 32'hFFFFFFFF;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq8

     class simple_seq9 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq9)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.B == 32'hAAAAAAAA;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq9

     class simple_seq10 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq10)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.B == 32'h7FFFFFFF;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq10

     class simple_seq11 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq11)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.B == 32'hFFFFFFFF;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq11

     class simple_seq12 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq12)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.B == 32'h050A050A;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq12

     class simple_seq13 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq13)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.B == 32'h80000000;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq13

     class simple_seq14 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq14)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.B == 32'h00000001;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq14

     class simple_seq15 extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(simple_seq15)

        function new(string name = "");
            super.new(name);
        endfunction: new

        task body;
            alu_transaction_in tx;
            tx=alu_transaction_in::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize() with {tx.B == 32'h00000000;tx.A == 32'h00000000;});
            finish_item(tx);
        endtask: body
    endclass: simple_seq15





/*  sequences what I added*/
    class seq_of_commands extends uvm_sequence #(alu_transaction_in);
        `uvm_object_utils(seq_of_commands)
        `uvm_declare_p_sequencer(uvm_sequencer#(alu_transaction_in))

        function new (string name = "");
            super.new(name);
        endfunction: new

        task body;
            repeat(100)
            begin
                simple_seq seq;
                simple_seq1 seq1;
                simple_seq2 seq2;
                simple_seq3 seq3;
                simple_seq4 seq4;
                simple_seq5 seq5;
                simple_seq6 seq6;
                simple_seq7 seq7;
                simple_seq8 seq8;
                simple_seq9 seq9;
                simple_seq10 seq10;
                simple_seq11 seq11;
                simple_seq12 seq12;
                simple_seq13 seq13;
                simple_seq14 seq14;
                simple_seq15 seq15;
                seq = simple_seq::type_id::create("seq");
                seq1 = simple_seq1::type_id::create("seq1");
                seq2 = simple_seq2::type_id::create("seq2");
                seq3 = simple_seq3::type_id::create("seq3");
                seq4 = simple_seq4::type_id::create("seq4");
                seq5 = simple_seq5::type_id::create("seq5");
                seq6 = simple_seq6::type_id::create("seq6");
                seq7 = simple_seq7::type_id::create("seq7");
                seq8 = simple_seq8::type_id::create("seq8");
                seq9 = simple_seq9::type_id::create("seq9");
                seq10 = simple_seq10::type_id::create("seq10");
                seq11 = simple_seq11::type_id::create("seq11");
                seq12 = simple_seq12::type_id::create("seq12");
                seq13 = simple_seq13::type_id::create("seq13");
                seq14 = simple_seq14::type_id::create("seq14");
                seq15 = simple_seq15::type_id::create("seq15");
                assert( seq.randomize() );
                assert( seq1.randomize() );
                assert( seq2.randomize() );
                assert( seq3.randomize() );
                assert( seq4.randomize() );
                assert( seq5.randomize() );
                assert( seq6.randomize() );
                assert( seq7.randomize() );
                assert( seq8.randomize() );
                assert( seq9.randomize() );
                assert( seq10.randomize() );
                assert( seq11.randomize() );
                assert( seq12.randomize() );
                assert( seq13.randomize() );
                assert( seq14.randomize() );
                assert( seq15.randomize() );
                seq.start(p_sequencer);
                seq1.start(p_sequencer);
                seq2.start(p_sequencer);
                seq3.start(p_sequencer);
                seq4.start(p_sequencer);
                seq5.start(p_sequencer);
                seq6.start(p_sequencer);
                seq7.start(p_sequencer);
                seq8.start(p_sequencer);
                seq9.start(p_sequencer);
                seq10.start(p_sequencer);
                seq11.start(p_sequencer);
                seq12.start(p_sequencer);
                seq13.start(p_sequencer);
                seq14.start(p_sequencer);
                seq15.start(p_sequencer);
               
                
                
                
            end
           
                
            
        endtask: body

    endclass: seq_of_commands

endpackage: sequences
