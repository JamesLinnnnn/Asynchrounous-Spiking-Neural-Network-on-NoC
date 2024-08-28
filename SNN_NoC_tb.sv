`timescale 1ns/1fs

import SystemVerilogCSP::*;

module SNN_NoC_tb;


Channel #(.WIDTH(2),.hsProtocol(P4PhaseBD)) ts_r(),timestep(),layer_r();
Channel #(.WIDTH(12),.hsProtocol(P4PhaseBD)) out_spike_addr(),ifmap_addr(),filter_addr();
Channel #(.WIDTH(13),.hsProtocol(P4PhaseBD)) out_spike_data(),filter_data();
Channel #(.WIDTH(1),.hsProtocol(P4PhaseBD)) ifmap_data(),done_r(),load_start(),start_r(),load_done();

noc_snn_tb test(load_start, ifmap_data, ifmap_addr, timestep, filter_data, filter_addr, load_done, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);
SNN_NoC SNN(load_start, ifmap_data, ifmap_addr, timestep, filter_data, filter_addr, load_done, start_r, ts_r, layer_r, out_spike_addr, out_spike_data, done_r);


initial begin
#1000;
end

endmodule
