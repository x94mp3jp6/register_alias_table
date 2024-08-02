`timescale 1ns/1ns

module tb_rob ();

reg         i_clk;
reg         i_rstn;

reg         i_dq_valid;
reg [1:0]   i_rob_addr;
reg [1:0]   i_rob_dst_addr;

reg         i_rs_req;
reg [1:0]   i_rs_addr;

wire            o_rs_tag_valid;
wire    [1:0]   o_rs_tag;
wire            o_rs_val_valid;
wire    [15:0]  o_rs_val;

wire        ooo;

rat dut (
    .i_clk          (i_clk ), 
    .i_rstn         (i_rstn ), 
    .i_rob_valid    (i_rob_valid),
    .i_rob_addr     (i_rob_addr),
    .i_rob_dst_addr (i_rob_dst_addr),

    .i_rs_req       (i_rs_req),
    .i_rs_addr      (i_rs_addr),

    .o_rs_tag_valid (o_rs_tag_valid),
    .o_rs_tag       (o_rs_tag),
    .o_rs_val_valid (o_rs_val_valid),
    .o_rs_val       (o_rs_val)
);

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0);
    #500 $finish;
end

integer i;

initial begin
    for(i = 0; i < 4; i = i + 1) begin
        $dumpvars(0,dut.physical_reg_file_valid[i]);
        $dumpvars(0,dut.physical_reg_file[i]);
    end
end

always #5 i_clk = ~i_clk;

initial begin
    #0 
    i_clk  = 0;
    i_rstn = 1;
    i_rob_valid = 0;
    i_rob_addr = 0;
    i_rob_dst_addr = 0;
    #55
    i_rstn = 0;
    #50
    i_rstn = 1;
    #30
    rob_wr(3,0);
    #20
    rob_wr(1,0);
    #20
    rob_wr(2,3);
    #100
    rs_req(0);
    #20
    rs_req(1);
end

//==========================================================================
//==    task: rob_wr
//==    description: rob_addr means rob0、rob1、rob2、rob3
//==                 rob_dst_addr means r0、r1、r2、r3
//==                 This task is used to represent when instruction is 
//==                 issued to Reorder-buffer then ROB would write some
//==                 information(rob_dst_addr) to RAT.
//==========================================================================
task rob_wr;
    input   [1:0] rob_addr;
    input   [1:0] rob_dst_addr;
   
    begin
        @(posedge i_clk)
        i_rob_valid     <= 1;
        i_rob_addr      <= rob_addr;
        i_rob_dst_addr  <= rob_dst_addr;

        @(posedge i_clk)
        i_rob_valid     <= 0;
    end
endtask

//==========================================================================
//==    task: rs_req
//==    description: Signal rs_req means Reservation Station wants to get some
//==                 information from RAT.
//==========================================================================
task rs_req;
    input   [1:0] rs_addr;
   
    begin
        @(posedge i_clk)
        i_rs_req    <= 1;
        i_rs_addr   <= rs_addr;

        @(posedge i_clk)
        i_rs_req     <= 0;
    end
endtask

endmodule
