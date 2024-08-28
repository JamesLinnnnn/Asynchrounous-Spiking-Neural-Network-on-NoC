`timescale 1ns/1fs

import SystemVerilogCSP::*;
//Spike
module ifp_load(interface ts,interface ifm_data,interface ifm_addr, interface load_done, interface packet_ctr, interface out);

parameter FL=2;
parameter BL=1;
parameter mem_delay=2;
parameter mapsize=32;// 32X32 map 
// Address in 4X4 Mesh
parameter ifm_addrr=4'b0000;
parameter PE1_addr=4'b1000;
parameter PE2_addr=4'b1100;
parameter PE3_addr=4'b0001;
parameter PE4_addr=4'b0101;
parameter PE5_addr=4'b1001;
parameter PE6_addr=4'b1101;
parameter PE7_addr=4'b0010;
parameter PE8_addr=4'b0110;
parameter PE9_addr=4'b1010;
parameter PE10_addr=4'b1110;
//Packet Width
parameter WIDTH=35;

//Done signal represents finishing sending all data to map from testbench
logic [1:0]done=0;
// 32*32=1024. It means we have 0 ~1023 to represent value address
logic [9:0]addr;
//Input sipke data
logic data;
// the row and column variables in receiving data loop
logic [9:0]row;
logic [9:0]col;
//Timestep to show whether testbench sends first or second Map
logic [1:0]timestep;
//This counter is used in receiving data block
logic [11:0]counter=0;
//the counter is used in sending data
logic [7:0]count=0;
// Two Input Feature Maps
logic ifm1[mapsize-1:0][mapsize-1:0];
logic ifm2[mapsize-1:0][mapsize-1:0];
// The packet carrying done signal from Sum & Threshold Block
logic [WIDTH-1:0]packet;
// Done Signal in Packet
logic [4:0]ctr;
// Packets sending to PEs 
logic [WIDTH-1:0]packet1;
logic [WIDTH-1:0]packet2;
logic [WIDTH-1:0]packet3;
logic [WIDTH-1:0]packet4;
logic [WIDTH-1:0]packet5;
logic [WIDTH-1:0]packet6;
logic [WIDTH-1:0]packet7;
logic [WIDTH-1:0]packet8;
logic [WIDTH-1:0]packet9;
logic [WIDTH-1:0]packet10;
//Offsets
logic[4:0]col_offset=0;//if the column_offset=27, which means the filter reaches the right border of ifmap
logic [4:0]row_offset=0;//if the row_offset=27, which means the filter reaches the bottom border of ifmap


// Function starts
always begin
if(done==0)begin
	ts.Receive(timestep);
	if(timestep==1)begin
		$display("Loading First Input Feature Map");
	end	
	while(timestep==1)begin
		fork
		ifm_addr.Receive(addr);
		ifm_data.Receive(data);
		join
		row=addr/32;
		col=addr%32;
		ifm1[row][col]=data;
		counter=counter+1;
		if(counter==1024)begin
			$display("Finish loading ifm1");
		    timestep=0;
			counter=0;
			break;
		end
		ts.Receive(timestep);
		#FL;
	end
	#BL;
	//Start to receive IFMap 2	
	ts.Receive(timestep);
	if(timestep==2)begin
		$display("Loading Second Input Feature Map");
	end	
	while(timestep==2)begin
		fork
		ifm_addr.Receive(addr);
		ifm_data.Receive(data);
		join
		row=addr/32;
		col=addr%32;
		ifm2[row][col]=data;
		counter=counter+1;
		if(counter==1024)begin
			$display("Finish loading ifm2");
		    timestep=0;
			counter=0;
			break;
		end
		ts.Receive(timestep);
		#FL;
	end
	load_done.Receive(done);
	timestep=0;
	$display("Finish loading all data to filter and Input Feature Map");
end
if(done==1)begin
	$display("Start Sending data to PEs from Map1");
	// Start Sending data from Input Feature Map to PEs
	for(row_offset=0;row_offset<28;row_offset++)begin
		for(col_offset=0;col_offset<28;col_offset=col_offset+3)begin
			if(col_offset<27)begin
				packet1={ifm_addrr,PE1_addr,3'b001,19'b0000000000000000000,ifm1[row_offset][col_offset],ifm1[row_offset][col_offset+1],ifm1[row_offset][col_offset+2],ifm1[row_offset][col_offset+3],ifm1[row_offset][col_offset+4]};
				out.Send(packet1);
				$display("Send ifmap 5 data to PE1 from Map1");
				#mem_delay;
				packet2={ifm_addrr,PE2_addr,3'b001,19'b0000000000000000000,ifm1[row_offset][col_offset+3],ifm1[row_offset][col_offset+4],ifm1[row_offset][col_offset+5],ifm1[row_offset][col_offset+6],ifm1[row_offset][col_offset+7]};
				out.Send(packet2);
				$display("Send ifmap 5 data to PE2 from Map1");
				#mem_delay;
				packet3={ifm_addrr,PE3_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+1][col_offset],ifm1[row_offset+1][col_offset+1],ifm1[row_offset+1][col_offset+2],ifm1[row_offset+1][col_offset+3],ifm1[row_offset+1][col_offset+4]};
				out.Send(packet3);
				$display("Send ifmap 5 data to PE3 from Map1");
				#mem_delay;
				packet4={ifm_addrr,PE4_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+1][col_offset+3],ifm1[row_offset+1][col_offset+4],ifm1[row_offset+1][col_offset+5],ifm1[row_offset+1][col_offset+6],ifm1[row_offset+1][col_offset+7]};
				out.Send(packet4);
				$display("Send ifmap 5 data to PE4 from Map1");
				#mem_delay;
				packet5={ifm_addrr,PE5_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+2][col_offset],ifm1[row_offset+2][col_offset+1],ifm1[row_offset+2][col_offset+2],ifm1[row_offset+2][col_offset+3],ifm1[row_offset+2][col_offset+4]};
				out.Send(packet5);
				$display("Send ifmap 5 data to PE5 from Map1");
				#mem_delay;
				packet6={ifm_addrr,PE6_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+2][col_offset+3],ifm1[row_offset+2][col_offset+4],ifm1[row_offset+2][col_offset+5],ifm1[row_offset+2][col_offset+6],ifm1[row_offset+2][col_offset+7]};
				out.Send(packet6);
				$display("Send ifmap 5 data to PE6 from Map1");
				#mem_delay;
				packet7={ifm_addrr,PE7_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+3][col_offset],ifm1[row_offset+3][col_offset+1],ifm1[row_offset+3][col_offset+2],ifm1[row_offset+3][col_offset+3],ifm1[row_offset+3][col_offset+4]};
				out.Send(packet7);
				$display("Send ifmap 5 data to PE7 from Map1");
				#mem_delay;
				packet8={ifm_addrr,PE8_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+3][col_offset+3],ifm1[row_offset+3][col_offset+4],ifm1[row_offset+3][col_offset+5],ifm1[row_offset+3][col_offset+6],ifm1[row_offset+3][col_offset+7]};
				out.Send(packet8);
				$display("Send ifmap 5 data to PE8 from Map1");
				#mem_delay;
				packet9={ifm_addrr,PE9_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+4][col_offset],ifm1[row_offset+4][col_offset+1],ifm1[row_offset+4][col_offset+2],ifm1[row_offset+4][col_offset+3],ifm1[row_offset+4][col_offset+4]};
				out.Send(packet9);
				$display("Send ifmap 5 data to PE9 from Map1");
				#mem_delay;
				packet10={ifm_addrr,PE10_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+4][col_offset+3],ifm1[row_offset+4][col_offset+4],ifm1[row_offset+4][col_offset+5],ifm1[row_offset+4][col_offset+6],ifm1[row_offset+4][col_offset+7]};
				out.Send(packet10);
				$display("Send ifmap 5 data to PE10 from Map1");
				#mem_delay;
			end
			if(col_offset==27)begin
				packet1={ifm_addrr,PE1_addr,3'b001,19'b0000000000000000000,ifm1[row_offset][col_offset],ifm1[row_offset][col_offset+1],ifm1[row_offset][col_offset+2],ifm1[row_offset][col_offset+3],ifm1[row_offset][col_offset+4]};
				out.Send(packet1);
				$display("Send ifmap 5 data to PE1 from Map1 when");
				#mem_delay;
				packet2={ifm_addrr,PE2_addr,3'b001,19'b0000000000000000000,ifm1[row_offset][col_offset+3],ifm1[row_offset][col_offset+4],3'b000};
				out.Send(packet2);
				$display("Send ifmap 5 data to PE2 from Map1");
				#mem_delay;
				packet3={ifm_addrr,PE3_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+1][col_offset],ifm1[row_offset+1][col_offset+1],ifm1[row_offset+1][col_offset+2],ifm1[row_offset+1][col_offset+3],ifm1[row_offset+1][col_offset+4]};
				out.Send(packet3);
				$display("Send ifmap 5 data to PE3 from Map1");
				#mem_delay;
				packet4={ifm_addrr,PE4_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+1][col_offset+3],ifm1[row_offset+1][col_offset+4],3'b000};
				out.Send(packet4);
				$display("Send ifmap 5 data to PE4 from Map1");
				#mem_delay;
				packet5={ifm_addrr,PE5_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+2][col_offset],ifm1[row_offset+2][col_offset+1],ifm1[row_offset+2][col_offset+2],ifm1[row_offset+2][col_offset+3],ifm1[row_offset+2][col_offset+4]};
				out.Send(packet5);
				$display("Send ifmap 5 data to PE5 from Map1");
				#mem_delay;
				packet6={ifm_addrr,PE6_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+2][col_offset+3],ifm1[row_offset+2][col_offset+4],3'b000};
				out.Send(packet6);
				$display("Send ifmap 5 data to PE6 from Map1");
				#mem_delay;
				packet7={ifm_addrr,PE7_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+3][col_offset],ifm1[row_offset+3][col_offset+1],ifm1[row_offset+3][col_offset+2],ifm1[row_offset+3][col_offset+3],ifm1[row_offset+3][col_offset+4]};
				out.Send(packet7);
				$display("Send ifmap 5 data to PE7 from Map1");
				#mem_delay;
				packet8={ifm_addrr,PE8_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+3][col_offset+3],ifm1[row_offset+3][col_offset+4],3'b000};
				out.Send(packet8);
				$display("Send ifmap 5 data to PE8 from Map1");
				#mem_delay;
				packet9={ifm_addrr,PE9_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+4][col_offset],ifm1[row_offset+4][col_offset+1],ifm1[row_offset+4][col_offset+2],ifm1[row_offset+4][col_offset+3],ifm1[row_offset+4][col_offset+4]};
				out.Send(packet9);
				$display("Send ifmap 5 data to PE9 from Map1");
				#mem_delay;
				packet10={ifm_addrr,PE10_addr,3'b001,19'b0000000000000000000,ifm1[row_offset+4][col_offset+3],ifm1[row_offset+4][col_offset+4],3'b000};
				out.Send(packet10);
				$display("Send ifmap 5 data to PE10 from Map1");
				#mem_delay;	
			end	
			packet_ctr.Receive(packet);
			wait(27'b000000000000000000000000001==packet[26:0]);
		end	
	end
	$display("####################################################Finishing Sending all Input feature Map1 data");
	packet_ctr.Receive(packet);
	wait(27'b000000000000000000000000001==packet[26:0]);
	$display("REceive final done packet form map1");	
	#mem_delay;
	//Sending packets to PEs from Map 2		
	$display("Start Sending packets to PEs from Map 2");
	for(row_offset=0;row_offset<28;row_offset++)begin
		for(col_offset=0;col_offset<28;col_offset=col_offset+3)begin
			if(col_offset<27)begin
				packet1={ifm_addrr,PE1_addr,3'b001,19'b0000000000000000000,ifm2[row_offset][col_offset],ifm2[row_offset][col_offset+1],ifm2[row_offset][col_offset+2],ifm2[row_offset][col_offset+3],ifm2[row_offset][col_offset+4]};
				out.Send(packet1);
				$display("Send ifmap 5 data to PE1 from Map2");
				#mem_delay;
				packet2={ifm_addrr,PE2_addr,3'b001,19'b0000000000000000000,ifm2[row_offset][col_offset+3],ifm2[row_offset][col_offset+4],ifm2[row_offset][col_offset+5],ifm2[row_offset][col_offset+6],ifm2[row_offset][col_offset+7]};
				out.Send(packet2);
				$display("Send ifmap 5 data to PE2 from Map2");
				#mem_delay;
				packet3={ifm_addrr,PE3_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+1][col_offset],ifm2[row_offset+1][col_offset+1],ifm2[row_offset+1][col_offset+2],ifm2[row_offset+1][col_offset+3],ifm2[row_offset+1][col_offset+4]};
				out.Send(packet3);
				$display("Send ifmap 5 data to PE3 from Map2");
				#mem_delay;
				packet4={ifm_addrr,PE4_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+1][col_offset+3],ifm2[row_offset+1][col_offset+4],ifm2[row_offset+1][col_offset+5],ifm2[row_offset+1][col_offset+6],ifm2[row_offset+1][col_offset+7]};
				out.Send(packet4);
				$display("Send ifmap 5 data to PE4 from Map2");
				#mem_delay;
				packet5={ifm_addrr,PE5_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+2][col_offset],ifm2[row_offset+2][col_offset+1],ifm2[row_offset+2][col_offset+2],ifm2[row_offset+2][col_offset+3],ifm2[row_offset+2][col_offset+4]};
				out.Send(packet5);
				$display("Send ifmap 5 data to PE5 from Map2");
				#mem_delay;
				packet6={ifm_addrr,PE6_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+2][col_offset+3],ifm2[row_offset+2][col_offset+4],ifm2[row_offset+2][col_offset+5],ifm2[row_offset+2][col_offset+6],ifm2[row_offset+2][col_offset+7]};
				out.Send(packet6);
				$display("Send ifmap 5 data to PE6 from Map2");
				#mem_delay;
				packet7={ifm_addrr,PE7_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+3][col_offset],ifm2[row_offset+3][col_offset+1],ifm2[row_offset+3][col_offset+2],ifm2[row_offset+3][col_offset+3],ifm2[row_offset+3][col_offset+4]};
				out.Send(packet7);
				$display("Send ifmap 5 data to PE7 from Map2");
				#mem_delay;
				packet8={ifm_addrr,PE8_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+3][col_offset+3],ifm2[row_offset+3][col_offset+4],ifm2[row_offset+3][col_offset+5],ifm2[row_offset+3][col_offset+6],ifm2[row_offset+3][col_offset+7]};
				out.Send(packet8);
				$display("Send ifmap 5 data to PE8 from Map2");
				#mem_delay;
				packet9={ifm_addrr,PE9_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+4][col_offset],ifm2[row_offset+4][col_offset+1],ifm2[row_offset+4][col_offset+2],ifm2[row_offset+4][col_offset+3],ifm2[row_offset+4][col_offset+4]};
				out.Send(packet9);
				$display("Send ifmap 5 data to PE9 from Map2");
				#mem_delay;
				packet10={ifm_addrr,PE10_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+4][col_offset+3],ifm2[row_offset+4][col_offset+4],ifm2[row_offset+4][col_offset+5],ifm2[row_offset+4][col_offset+6],ifm2[row_offset+4][col_offset+7]};
				out.Send(packet10);
				$display("Send ifmap 5 data to PE10from Map2");
				#mem_delay;				
			end
			if(col_offset==27)begin
				packet1={ifm_addrr,PE1_addr,3'b001,19'b0000000000000000000,ifm2[row_offset][col_offset],ifm2[row_offset][col_offset+1],ifm2[row_offset][col_offset+2],ifm2[row_offset][col_offset+3],ifm2[row_offset][col_offset+4]};
				out.Send(packet1);
				$display("Send ifmap 5 data to PE1 from Map1 when");
				#mem_delay;
				packet2={ifm_addrr,PE2_addr,3'b001,19'b0000000000000000000,ifm2[row_offset][col_offset+3],ifm2[row_offset][col_offset+4],3'b000};
				out.Send(packet2);
				$display("Send ifmap 5 data to PE2 from Map2");
				packet3={ifm_addrr,PE3_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+1][col_offset],ifm2[row_offset+1][col_offset+1],ifm2[row_offset+1][col_offset+2],ifm2[row_offset+1][col_offset+3],ifm2[row_offset+1][col_offset+4]};
				out.Send(packet3);
				$display("Send ifmap 5 data to PE3 from Map2");
				#mem_delay;
				packet4={ifm_addrr,PE4_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+1][col_offset+3],ifm2[row_offset+1][col_offset+4],3'b000};
				out.Send(packet4);
				$display("Send ifmap 5 data to PE4 from Map2");
				#mem_delay;
				packet5={ifm_addrr,PE5_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+2][col_offset],ifm2[row_offset+2][col_offset+1],ifm2[row_offset+2][col_offset+2],ifm2[row_offset+2][col_offset+3],ifm2[row_offset+2][col_offset+4]};
				out.Send(packet5);
				$display("Send ifmap 5 data to PE5 from Map2");
				#mem_delay;
				packet6={ifm_addrr,PE6_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+2][col_offset+3],ifm2[row_offset+2][col_offset+4],3'b000};
				$display("Send ifmap 5 data to PE6 from Map2");
				out.Send(packet6);
				#mem_delay;
				packet7={ifm_addrr,PE7_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+3][col_offset],ifm2[row_offset+3][col_offset+1],ifm2[row_offset+3][col_offset+2],ifm2[row_offset+3][col_offset+3],ifm2[row_offset+3][col_offset+4]};
				out.Send(packet7);
				$display("Send ifmap 5 data to PE7 from Map2");
				#mem_delay;
				packet8={ifm_addrr,PE8_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+3][col_offset+3],ifm2[row_offset+3][col_offset+4],3'b000};
				out.Send(packet8);
				$display("Send ifmap 5 data to PE8 from Map2");
				#mem_delay;
				packet9={ifm_addrr,PE9_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+4][col_offset],ifm2[row_offset+4][col_offset+1],ifm2[row_offset+4][col_offset+2],ifm2[row_offset+4][col_offset+3],ifm2[row_offset+4][col_offset+4]};
				out.Send(packet9);
				$display("Send ifmap 5 data to PE9 from Map2");
				#mem_delay;
				packet10={ifm_addrr,PE10_addr,3'b001,19'b0000000000000000000,ifm2[row_offset+4][col_offset+3],ifm2[row_offset+4][col_offset+4],3'b000};
				out.Send(packet10);
				$display("Send ifmap 5 data to PE10 from Map2");	
				#mem_delay;
			end		
			packet_ctr.Receive(packet);
			wait(27'b000000000000000000000000001==packet[26:0]);
		end	
	end	
	$display("###################################Finish Sending all values from Map2");
end
end
endmodule