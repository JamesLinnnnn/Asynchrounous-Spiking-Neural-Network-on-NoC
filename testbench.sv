/* testbench.sv
   
   SP23 EE-552 Final project 
   
   INSTRUCTIONS:
   1. You can add/modify code to this file, if needed.

*/

`timescale 1ns/1ps

import SystemVerilogCSP::*;

//control testbench
module noc_snn_tb(interface load_start, ifmap_data, ifmap_addr, timestep, filter_data, filter_addr, load_done, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);

// parameters
parameter WIDTH_data = 8;
parameter WIDTH_addr = 12;
parameter WIDTH_out_data = 13;
parameter DEPTH_F= 5;
parameter DEPTH_I =32;
parameter DEPTH_R =28;

logic i1_data, i2_data, dn, st, s_r;
logic [1:0] ts=1, l_index;
logic [WIDTH_data-1:0] f_data;
logic [WIDTH_addr-1:0] i1_addr = 0, i2_addr=0, f_addr=0, out_addr;
logic [WIDTH_out_data-1:0] out_data;

logic [WIDTH_out_data-1:0] comp1[DEPTH_R*DEPTH_R-1:0];
logic [WIDTH_out_data-1:0] comp2[DEPTH_R*DEPTH_R-1:0];

integer error_count, fpt, fpi_f, fpi_i1, fpi_i2, fpi_out1, fpi_out2, fpo, status;
 

// watchdog timer
 initial begin
 #100000000;
 $display("*** Stopped by watchdog timer ***");
 $finish;
 end 
 

// main execution
initial begin
// sending values to M module
   fpi_f = $fopen("filter.txt","r");
   fpi_i1 = $fopen("ifmap1.txt","r");
   fpi_i2 = $fopen("ifmap2.txt", "r");


   fpi_out1 = $fopen("out_spike1.txt","r");
   fpi_out2 = $fopen("out_spike2.txt","r");
   fpo = $fopen("test.dump","w");
   fpt = $fopen("transcript.dump");


   if(!fpi_f || !fpi_i1 || !fpi_i2)
   begin
       $display("A file cannot be opened!");
       $finish;
   end

//sending to the memory filter and feature map
   else begin
	  load_start.Send(1);
	   for(integer i=0; i<(DEPTH_F*DEPTH_F); i++) begin
	    if(!$feof(fpi_f)) begin
	     status = $fscanf(fpi_f,"%d\n", f_data);
	     $display("filter data read:%d", f_data);
	     filter_addr.Send(f_addr);
	     filter_data.Send(f_data); 
	     f_addr++;
	    end end
	   
// sending ifmap 1 (timestep1)

	for(integer i=0; i<DEPTH_I*DEPTH_I; i++) begin
	    if (!$feof(fpi_i1)) begin
	     status = $fscanf(fpi_i1,"%d\n", i1_data);
	     $display("Ifmap1 data read:%d", i1_data);
     		timestep.Send(ts);
	     ifmap_addr.Send(i1_addr);
	     ifmap_data.Send(i1_data);

	     i1_addr++;
	 end end

	ts++;

// sending ifmap 2 (timestep2)

	for(integer i=0; i<DEPTH_I*DEPTH_I; i++) begin
	    if (!$feof(fpi_i2)) begin
	     status = $fscanf(fpi_i2,"%d\n", i2_data);
	     $display("Ifmap2 data read:%d", i2_data);
	     timestep.Send(ts);
	     ifmap_addr.Send(i2_addr);
	     ifmap_data.Send(i2_data);

	     i2_addr++;
	 end end
   end

//Finish sending the matrix values
  load_done.Send(1); 
  $fdisplay(fpt,"%m sent load_done token at %t",$realtime);
  $display("%m sent load_done token at %t",$realtime);


// waiting for the signal indicating the start of receiving outputs
   start_r.Receive(s_r);
   $timeformat(-9, 4, "ns");
   $display("tb: start_r Received at %t", $realtime);
   $fdisplay(fpt,"%m start_r token received at %t",$realtime);


// comparing results
   error_count=0;


  if (s_r ==1) begin

   ts_r.Receive(ts);
   layer_r.Receive(l_index);
   $display("Received timestep %d, layer, %d", ts, l_index);
   
   if (ts ==1 && l_index ==1) begin
	   // load golden result: output_spike 1
   	   for(integer i=0; i<(DEPTH_R*DEPTH_R); i++) begin
	    if(!$feof(fpi_out1)) begin
	     status = $fscanf(fpi_out1,"%d\n", out_data);
	     $display("GodenResult data read (output_spike 1):%d", out_data);
	     comp1[i] = out_data;
	     $fdisplay(fpt,"comp1[%d]= %d",i,out_data); 
	   end end

	   // compare results
	   for (integer i = 0; i<DEPTH_R*DEPTH_R; i++) begin
	       // timestep 1
	       out_spike_addr.Receive(out_addr);
	       out_spike_data.Receive(out_data);
	       
		if (out_data != comp1[out_addr]) begin
       		$fdisplay(fpo,"%d != %d error!",out_data,comp1[i]);
       		$fdisplay(fpt,"%d != %d error!",out_data,comp1[i]);
       		$display("%d != %d error!",out_data,comp1[i]);
   //    		$fdisplay(fpt,"%d == comp[%d] = %d", out_data, i, comp1[i]);
   //    		$fdisplay(fpo," %d == comp[%d] = %d", out_data, i, comp1[i]);
       		error_count++;
   		end else begin
      		$fdisplay(fpt,"%d == comp1[%d] = %d", out_data, i, comp1[i]);
       		$fdisplay(fpo,"%d == comp1[%d] = %d", out_data, i, comp1[i]);
       		$display("Passing comparison! Receive result value : %d at %t",out_data, $realtime);
    		end
	   end
   end

   # 2;
   ts_r.Receive(ts);
   layer_r.Receive(l_index);


   if (ts ==2 && l_index ==1) begin
	   // load golden result: output_spike 2
   	   for(integer i=0; i<(DEPTH_R*DEPTH_R); i++) begin
	    if(!$feof(fpi_out2)) begin
	     status = $fscanf(fpi_out2,"%d\n", out_data);
	     $display("GodenResult data read (output_spike 2):%d", out_data);
	     comp2[i] = out_data;
	     $fdisplay(fpt,"comp2[%d]= %d",i,out_data); 
	   end end

	   // compare results
	   for (integer i = 0; i<DEPTH_R*DEPTH_R; i++) begin
	       // timestep 1
	       out_spike_addr.Receive(out_addr);
	       out_spike_data.Receive(out_data);
	       
		if (out_data != comp2[out_addr]) begin
       		$fdisplay(fpo,"%d != %d error!",out_data,comp2[i]);
       		$fdisplay(fpt,"%d != %d error!",out_data,comp2[i]);
       		$display("%d != %d error!",out_data,comp2[i]);
      // 		$fdisplay(fpt,"%d == comp[%d] = %d", out_data, i, comp2[i]);
      // 		$fdisplay(fpo," %d == comp[%d] = %d", out_data, i, comp2[i]);
       		error_count++;
   		end else begin
      		$fdisplay(fpt,"%d == comp2[%d] = %d", out_data, i, comp2[i]);
       		$fdisplay(fpo,"%d == comp2[%d] = %d", out_data, i, comp2[i]);
       		$display("Passing comparison! Receive result value : %d at %t",out_data, $realtime);
    		end
	   end
   end

end

   done_r.Receive(dn);
   if (dn==1) begin
	  $fdisplay(fpo,"total errors = %d",error_count);
	  $fdisplay(fpt,"total errors = %d",error_count);
	  $display("total errors = %d",error_count); 
	 
	  $display("%m Results compared, ending simulation at %t",$realtime);
	  $fdisplay(fpt,"%m Results compared, ending simulation at %t",$realtime);
	  $fdisplay(fpo,"%m Results compared, ending simulation at %t",$realtime);
	  $fclose(fpt);
	  $fclose(fpo);
	  $finish;
	end

end
endmodule







//testbench instantiation
module testbench;
 Channel #(.hsProtocol(P4PhaseBD), .WIDTH(18)) intf  [12:0] (); 


// TODO you can add parameters if needed
 
 
// control testbench
// TODO you can add more interfaces if needed
noc_snn_tb tb( .ifmap_data(intf[0]), .ifmap_addr(intf[1]), .timestep(intf[2]), .filter_data(intf[3]), .filter_addr(intf[4]), 
.load_done(intf[5]), .ts_r(intf[6]), .layer_r(intf[7]), .done_r(intf[8]), .out_spike_addr(intf[9]), .out_spike_data(intf[10]), .load_start(intf[11]), .start_r(intf[12]));

//memory module
// TODO you can add more interfaces if needed (DO NOT remove interfaces)
noc_snn dut(.ifmap_data(intf[0]), .ifmap_addr(intf[1]), .timestep(intf[2]), .filter_data(intf[3]), .filter_addr(intf[4]), 
.load_done(intf[5]), .ts_r(intf[6]), .layer_r(intf[7]), .done_r(intf[8]), .out_spike_addr(intf[9]), .out_spike_data(intf[10]), .load_start(intf[11]), .start_r(intf[12])); 


// TODO instantiate other modules here ...


endmodule
 

