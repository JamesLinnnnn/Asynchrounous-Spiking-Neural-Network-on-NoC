`timescale 1ns/1fs

import SystemVerilogCSP::*;

module SNN_NoC(interface load_start, ifmap_data, ifmap_addr, timestep, filter_data, filter_addr, load_done, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);

parameter ifm_addrr=4'b0000;
parameter filter_addrr=4'b0100;
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
parameter sum_thr1=4'b0011;
parameter sum_thr2=4'b0111;
parameter sum_thr3=4'b1011;
parameter ofm_addr = 4'b1111;

Channel #(.WIDTH(35),.hsProtocol(P4PhaseBD)) filter_in(), filter_out(), ifmap_in(),ifmap_out(),PE1_in(), PE1_out(),PE2_in(), PE2_out(),PE3_in(), PE3_out(),PE4_in(), PE4_out(),PE5_in(), PE5_out(),PE6_in(), PE6_out(),PE7_in(), PE7_out(),PE8_in(), PE8_out(),PE9_in(), PE9_out(),PE10_in(), PE10_out(),sum1_in(),sum1_out(),sum2_in(),sum2_out(),sum3_in(),sum3_out(),ofm_in(),ofm_out();

// 4X4 Mesh Routers
two_d_mesh mesh(filter_in, filter_out, ifmap_in,ifmap_out,PE1_in, PE1_out,PE2_in, PE2_out,PE3_in, PE3_out,PE4_in, PE4_out,PE5_in, PE5_out,PE6_in, PE6_out,PE7_in, PE7_out,PE8_in, PE8_out,PE9_in, PE9_out,PE10_in, PE10_out,sum1_in,sum1_out,sum2_in,sum2_out,sum3_in,sum3_out,ofm_in,ofm_out);

//Filter
filter_load filter(load_start,filter_data,filter_addr, filter_in,filter_out);

//Input Feature Map
ifp_load ifm(timestep,ifmap_data,ifmap_addr, load_done, ifmap_in, ifmap_out);

//Processing Elements
PE #(.PE_addr(PE1_addr))  PE1(PE1_in, PE1_out);
PE #(.PE_addr(PE2_addr))  PE2(PE2_in, PE2_out);
PE #(.PE_addr(PE3_addr))  PE3(PE3_in, PE3_out);
PE #(.PE_addr(PE4_addr))  PE4(PE4_in, PE4_out);
PE #(.PE_addr(PE5_addr))  PE5(PE5_in, PE5_out);
PE #(.PE_addr(PE6_addr))  PE6(PE6_in, PE6_out);
PE #(.PE_addr(PE7_addr))  PE7(PE7_in, PE7_out);
PE #(.PE_addr(PE8_addr))  PE8(PE8_in, PE8_out);
PE #(.PE_addr(PE9_addr))  PE9(PE9_in, PE9_out);
PE #(.PE_addr(PE10_addr)) PE10(PE10_in, PE10_out);

// Sum & Threshold Blocks
Sum_Threshold1 	 #(.sum_addr(sum_thr1)) sum1(sum1_in, sum1_out);
Sum_Threshold2_3 #(.sum_addr(sum_thr2)) sum2(sum2_in, sum2_out);
Sum_Threshold2_3 #(.sum_addr(sum_thr3)) sum3(sum3_in, sum3_out);

//Output Feature Map + Residual Memory
 OF_Residual_mem ofm(ofm_in,ofm_out, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);
 
 
 endmodule