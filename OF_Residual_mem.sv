`timescale 1ns/100ps
import SystemVerilogCSP::*;

module OF_Residual_mem (interface in, out, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);

parameter WIDTH = 35;
parameter FL = 2;
parameter BL = 1;
parameter ofm_addr = 4'b1111;//need two?
parameter sum1_addr = 4'b0011;
parameter sum2_addr = 4'b0111;
parameter sum3_addr = 4'b1011;
parameter ifmap_addr=4'b0000;

logic [WIDTH-1:0]packet_out;
logic [WIDTH-1:0]packet_in;
logic [WIDTH-1:0]packet_done;
logic [WIDTH-1:0]packet_send1,packet_send2,packet_send3;
logic spike1,spike2,spike3;
logic [783:0]ofm_mem1;
logic [783:0]ofm_mem2;
logic [7:0]res_mem1 [0:783];
logic [7:0]res_mem2 [0:783];
logic [7:0] res1,res2,res3;
logic [7:0] sum1_value, sum2_value, sum3_value;
logic [1:0]timestep=1;
logic [9:0]addr1=0,addr2=0,addr_req=0;
logic [4:0]counter_28=0;
logic [1:0]counter_receive=0;
logic [2:0]store_spike;
logic [7:0]store_res[2:0];
logic send_signal=0;
logic [1:0] ts=0;
logic [11:0] spike_addr1=0,spike_addr2=0;
logic [12:0] spike_data1,spike_data2; 
logic done=1,start=1,layer=1;

initial begin
	timestep=1;
end	
integer i,j;
always begin
	if(timestep==1)begin
	in.Receive(packet_in);
		if(counter_28!=28)begin
			if (sum1_addr==packet_in[WIDTH-9:WIDTH-12]) begin
				sum1_value =packet_in[7:0];
				spike1=packet_in[WIDTH-13];
				#FL;
				counter_receive=counter_receive+1;
				counter_28=counter_28+1;
	
			end

			if (sum2_addr==packet_in[WIDTH-9:WIDTH-12]) begin
				sum2_value =packet_in[7:0];
				spike2=packet_in[WIDTH-13];
				#FL;
				counter_receive=counter_receive+1;
				counter_28=counter_28+1;
		
			end

			if (sum3_addr==packet_in[WIDTH-9:WIDTH-12]) begin
				sum3_value =packet_in[7:0];
				spike3=packet_in[WIDTH-13];
				#FL;
				counter_receive=counter_receive+1;
				counter_28=counter_28+1;
	
		
			end	
			if(counter_receive==3)begin
				res_mem1 [addr1+2]=sum3_value;
				ofm_mem1[addr1+2] = spike3;
				res_mem1 [addr1+1]=sum2_value;
				ofm_mem1[addr1+1] = spike2;
				res_mem1 [addr1]=sum1_value;
				ofm_mem1[addr1] = spike1;
	
				$display("Finish Loading Map1 Result in %m");
				$display("Start to Send done PAcket");
				packet_done={ofm_addr,ifmap_addr,27'b000000000000000000000000001};
				out.Send(packet_done);
				$display("Send done packet");
				#1;
				addr1=addr1+3;
				counter_receive=0;
			end		
		end	
		if(counter_28==28)begin
			if (sum1_addr==packet_in[WIDTH-9:WIDTH-12]) begin
					res_mem1 [addr1]=sum1_value;
					ofm_mem1[addr1] = spike1;
					#FL;
					counter_receive=0;
					addr1=addr1+1;
					counter_28=0;
				packet_done={ofm_addr,ifmap_addr,27'b000000000000000000000000001};
				out.Send(packet_done);
				#2;
			end
		end	
		if(addr1==784)begin
					$display("FInal done packet in ts=1");
					$display("################################# Finish Loading Timestep=1 in %m");
					packet_done={ofm_addr,ifmap_addr,27'b000000000000000000000000001};
					out.Send(packet_done);
					//Send first 3 residual values in residual memory of timestep1 to sum1, sum2,sum3
					res1[7:0]=res_mem1[0];
					res2[7:0]=res_mem1[1];
					res3[7:0]=res_mem1[2];
					packet_send1={ofm_addr,sum1_addr,ofm_addr,15'b000000000000000,res1};//4+4+4+15+8=35
					out.Send(packet_send1);
					#BL;
					packet_send2={ofm_addr,sum2_addr,ofm_addr,15'b000000000000000,res2};
					out.Send(packet_send2);
					#BL;
					packet_send3={ofm_addr,sum3_addr,ofm_addr,15'b000000000000000,res3};
					out.Send(packet_send3);
					#BL;
					counter_28=0;
					counter_receive=0;
					timestep=2;
		end	
	end
	if(timestep==2)begin
		in.Receive(packet_in);
		if(counter_28!=28)begin
			if (sum1_addr==packet_in[WIDTH-9:WIDTH-12]) begin
				sum1_value =packet_in[7:0];
				spike1=packet_in[WIDTH-13];
				#FL;
				
				counter_receive=counter_receive+1;
				counter_28=counter_28+1;
	
			end

			if (sum2_addr==packet_in[WIDTH-9:WIDTH-12]) begin
				sum2_value =packet_in[7:0];
				spike2=packet_in[WIDTH-13];
				#FL;
				counter_receive=counter_receive+1;
				counter_28=counter_28+1;
		
			end

			if (sum3_addr==packet_in[WIDTH-9:WIDTH-12]) begin
				sum3_value =packet_in[7:0];
				spike3=packet_in[WIDTH-13];
				counter_receive=counter_receive+1;
				counter_28=counter_28+1;
			end	
			if(counter_receive==3)begin
					res_mem2 [addr2+2]=sum3_value;
					ofm_mem2[addr2+2] = spike3;
					res_mem2 [addr2+1]=sum2_value;
					ofm_mem2[addr2+1] = spike2;
					res_mem2 [addr2]=sum1_value;
					ofm_mem2[addr2] = spike1;
					addr2=addr2+3;
				if(counter_28!=27)begin
					res1=res_mem1[addr2];
					packet_send1={ofm_addr,sum1_addr,ofm_addr,15'b000000000000000,res1};//4+4+4+15+8=35
					out.Send(packet_send1);
					#BL;
					res2[7:0]=res_mem1[addr2+1];
					packet_send2={ofm_addr,sum2_addr,ofm_addr,15'b000000000000000,res2};
					out.Send(packet_send2);
					#BL;
					res3[7:0]=res_mem1[addr2+2];
					packet_send3={ofm_addr,sum3_addr,ofm_addr,15'b000000000000000,res3};
					out.Send(packet_send3);
					counter_receive=0;
					packet_done={ofm_addr,ifmap_addr,27'b000000000000000000000000001};
					out.Send(packet_done);
				end
				if(counter_28==27)begin
					res1=res_mem1[addr2];
					packet_send1={ofm_addr,sum1_addr,ofm_addr,15'b000000000000000,res1};//4+4+4+15+8=35
					out.Send(packet_send1);
					#BL;
					counter_receive=0;
					packet_done={ofm_addr,ifmap_addr,27'b000000000000000000000000001};
					out.Send(packet_done);
				end
			end
				#FL;
		end	
		if(counter_28==28)begin
			if (sum1_addr==packet_in[WIDTH-9:WIDTH-12]) begin
					res_mem2 [addr2]=sum1_value;
					ofm_mem2[addr2] = spike1;
					#FL;
					addr2=addr2+1;
					res1[7:0]=res_mem1[addr2];
					packet_send1={ofm_addr,sum1_addr,ofm_addr,15'b000000000000000,res1};//4+4+4+15+8=35
					out.Send(packet_send1);
					#BL;
					res2[7:0]=res_mem1[addr2+1];
					packet_send2={ofm_addr,sum2_addr,ofm_addr,15'b000000000000000,res2};
					out.Send(packet_send2);
					#BL;
					res3[7:0]=res_mem1[addr2+2];
					packet_send3={ofm_addr,sum3_addr,ofm_addr,15'b000000000000000,res3};
					out.Send(packet_send3);
				
					counter_28=0;
					counter_receive=0;
					packet_done={ofm_addr,ifmap_addr,27'b000000000000000000000000001};
					out.Send(packet_done);
			end
		end
			if(addr2==784)begin
				timestep=3;
				ts=1;
				break;
			end
	end	
end
	

	
//finish store all spike value
always begin
wait(ts==1);
$display("Start Send Start_Read signal");
start_r.Send(start);
$display("finish Sending Start_Read signal");

ts_r.Send(ts);
layer_r.Send(layer);
for(i=0;i<784;i++)begin
		out_spike_addr.Send(spike_addr1);
		out_spike_data.Send(ofm_mem1[spike_addr1]);
		spike_addr1++;		
end
#2;
ts=2;
ts_r.Send(ts);
layer_r.Send(layer);

for(j=0;j<784;j++)begin	
		out_spike_addr.Send(spike_addr2);
		out_spike_data.Send(ofm_mem2[spike_addr2]);
		spike_addr2++;	
end	
done_r.Send(done);


end
endmodule
