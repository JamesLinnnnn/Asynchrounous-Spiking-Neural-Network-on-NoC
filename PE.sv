`timescale 1ns/1fs

import SystemVerilogCSP::*;

module PE(interface in, interface out);

parameter FL=2;
parameter BL=1;
parameter WIDTH=35;
parameter PE_addr=4'b1011;//Change
parameter sum_thr1=4'b0011;
parameter sum_thr2=4'b0111;
parameter sum_thr3=4'b1011;
parameter delay=2;

logic [WIDTH-1:0]packet_in;
logic [2:0]packet_type;
logic [7:0]filter_value3;
logic [7:0]filter_value2;
logic [7:0]filter_value1;
logic ifmap_mem5,ifmap_mem4,ifmap_mem3,ifmap_mem2,ifmap_mem1;
logic [7:0]psumA;
logic [7:0]psumB;
logic [7:0]psumC;
logic [WIDTH-1:0]packet1;
logic [WIDTH-1:0]packet2;
logic [WIDTH-1:0]packet3;
logic flag1, flag2;
logic [3:0]counter=0;
logic counter_receive=0;
always begin
		$display("Depacket");
		in.Receive(packet_in);
		packet_type=packet_in[WIDTH-9:WIDTH-11];
		if(packet_type==3'b000)begin
		$display("this packet is from filter");
			filter_value3=packet_in[23:16];
			filter_value2=packet_in[15:8];
			filter_value1=packet_in[7:0];
			#FL;	
		end
		if(packet_type==3'b001)begin
		$display("this packet is from Map");
			ifmap_mem5=packet_in[4];
			ifmap_mem4=packet_in[3];
			ifmap_mem3=packet_in[2];
			ifmap_mem2=packet_in[1];
			ifmap_mem1=packet_in[0];
			#FL;	
			counter_receive=counter_receive+1;
			counter=counter+1;
		end
		#delay;
		if(counter_receive==1)begin
			counter_receive=0;
			if(counter<10)begin
			$display("Finish receiving 2 packets");
			$display("Calculate Partial Sum");
				psumA=(ifmap_mem5?filter_value3:0)+(ifmap_mem4?filter_value2:0)+(ifmap_mem3?filter_value1:0);
				packet1={PE_addr,sum_thr1,PE_addr,15'b000000000000000, psumA};
				out.Send(packet1);
				$display("send Packet to S&T1");
				//#delay;
				psumB=(ifmap_mem4?filter_value3:0)+(ifmap_mem3?filter_value2:0)+(ifmap_mem2?filter_value1:0);
				packet2={PE_addr,sum_thr2,PE_addr,15'b000000000000000, psumB};
				out.Send(packet2);
				$display("send Packet to S&T2");
				//#delay;
				psumC=(ifmap_mem3?filter_value3:0)+(ifmap_mem2?filter_value2:0)+(ifmap_mem1?filter_value1:0);
				packet3={PE_addr,sum_thr3,PE_addr,15'b000000000000000, psumC};
				out.Send(packet3);
				$display("send Packet to S&T3");
				#delay;	
			end	
			if(counter==10)begin
				psumA=(ifmap_mem5?filter_value3:0)+(ifmap_mem4?filter_value2:0)+(ifmap_mem3?filter_value1:0);
				packet1={PE_addr,sum_thr1,PE_addr,15'b000000000000000, psumA};
				out.Send(packet1);
				$display("send Packet to S&T1 only one value");
				#delay;
				counter=0;	
			end	
		end			
end
endmodule	