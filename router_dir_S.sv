`timescale 1ns/1fs

import SystemVerilogCSP::*;

module router_dir_S(interface in, interface N, interface E,interface W, interface PE);

parameter FL=2;
parameter BL=1;
parameter WIDTH=35;

logic [WIDTH-1:0]packet_in;
logic [WIDTH-1:0]packet_out;

logic [1:0]src_x;
logic [1:0]new_src_x;
logic [1:0]src_y;
logic [1:0]new_src_y;
logic [1:0]dst_x;
logic [1:0]dst_y;
logic [1:0]sel;

// Routing from South
always begin

	in.Receive(packet_in);
	#FL;
	packet_out=packet_in;
	fork
	src_x=packet_in[WIDTH-1:WIDTH-2];
	src_y=packet_in[WIDTH-3:WIDTH-4];
	dst_x=packet_in[WIDTH-5:WIDTH-6];
	dst_y=packet_in[WIDTH-7:WIDTH-8];
	join
	//go to east
	if(dst_x>src_x)begin
		new_src_x=src_x+2'b01;
		packet_out[WIDTH-1:WIDTH-2]=new_src_x;
		E.Send(packet_out);
		$display("East send from %m");
	end
	//go to west
	if(dst_x<src_x)begin
		new_src_x=src_x-2'b01;
		packet_out[WIDTH-1:WIDTH-2]=new_src_x;
		W.Send(packet_out);
		$display("West send from %m");
	end	
	//if source X=Destination X, we compared Y direction
	//go to North
	else if(dst_x==src_x&dst_y>src_y)begin	
			new_src_y=src_y+2'b01;
			packet_out[WIDTH-3:WIDTH-4]=new_src_y;
			N.Send(packet_out);
			$display("North send from %m");
	end	
	// Source X=Destination X and Source Y= Destination Y, go to PE
	else if(dst_x==src_x&dst_y==src_y)begin
			PE.Send(packet_out);
			$display("PE send from %m");
	end	
	#BL;
end
endmodule	
	