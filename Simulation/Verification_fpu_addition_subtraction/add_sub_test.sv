`include "uvm_macros.svh"
import uvm_pkg::*;

class add_sub_test extends uvm_test;

    `uvm_component_utils(add_sub_test)

    function new(string name="",uvm_component parent);
		super.new(name,parent);
		`uvm_info("","This is add_sub_test :: CONSTRUCTOR", UVM_NONE)
	endfunction : new

    function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("","This is add_sub_test :: BUILD_PHASE",UVM_NONE)
		env=environment_adder::type_id::create("env",this);
		seq_adder=my_sequence_adder::type_id::create("seq_adder",this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("","This is add_sub_test :: RUN_PHASE",UVM_NONE)
		phase.raise_objection(this);
		//BEFORE ADDER RESET MUST START.
		seq_adder.start(env.agt_adder.seqr_adder);
		#100;
		phase.drop_objection(this);
	endtask : run_phase

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("","This is add_sub_test :: END_OF_ELABORATION_PHASE",UVM_NONE)
		env.print();
	endfunction : end_of_elaboration_phase

endclass: add_sub_test
