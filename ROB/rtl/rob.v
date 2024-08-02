`timescale 1ns/1ns
module rob 
(
    input           i_clk,
    input           i_rstn,

    input           i_dq_valid,
    input   [1:0]   i_dq_typ,
    input   [1:0]   i_dq_dst,

    output          o_dq_busy
);

reg     [1:0]   rob_typ     [0:3];
reg     [1:0]   rob_dst     [0:3];
reg             rob_done    [0:3];
reg     [1:0]   rob_current;


wire wr_en;

assign wr_en        = i_dq_valid & ~o_dq_busy;
assign o_dq_busy    = ~rob_done[rob_current];

genvar i;

generate
    for(i = 0; i < 4; i = i + 1)begin
        // rob[i].typ、rob[i].dst
        always @( posedge i_clk or negedge i_rstn ) begin
            if (!i_rstn) begin
                rob_typ[i] <= 'h0;
                rob_dst[i] <= 'h0;
            end 
            else if(wr_en & i_dq_dst == i) begin
                rob_typ[i] <= i_dq_typ;
                rob_dst[i] <= i_dq_dst;
            end 
            else begin
                rob_typ[i] <= rob_typ[i];
                rob_dst[i] <= rob_dst[i];
            end
        end
    end
endgenerate

generate
    for(i = 0; i < 4; i = i + 1)begin
        // rob[i].done
        always @( posedge i_clk or negedge i_rstn ) begin
            if (!i_rstn) begin
                rob_done[i] <= 'b1;
            end 
            else if(wr_en & rob_current == i) begin
                rob_done[i] <= 'b0;
            end 
            else begin
                rob_done[i] <= rob_done[i];
            end
        end
    end
endgenerate

// rob.current
always @( posedge i_clk or negedge i_rstn ) begin
    if (!i_rstn) begin
        rob_current <= 0;
    end 
    else if (wr_en)begin
        rob_current <= rob_current + 1;
    end
    else begin
        rob_current <= rob_current;
    end
end

endmodule