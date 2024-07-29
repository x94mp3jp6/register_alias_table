`timescale 1ns/1ns
module rat 
(
    input           i_clk,
    input           i_rstn,

    input           i_rob_valid,
    input   [1:0]   i_rob_addr,
    input   [1:0]   i_rob_dst_addr,

    input           i_rs_req,
    input   [1:0]   i_rs_addr,

    output          o_rs_tag_valid,
    output  [1:0]   o_rs_tag,
    output          o_rs_val_valid,
    output  [15:0]  o_rs_val
);
reg             physical_reg_file_valid [0:3]; // 4個physical reg file的valid bit
reg     [1:0]   physical_reg_file       [0:3]; // 4個2bit的physical reg file，目前是4個arf跟4個prf，所以是2bit
reg     [15:0]  architecture_reg_file   [0:3]; // 4個16bit的architecture reg file，因為是放value，所以有16bit

genvar i;

generate
    for(i = 0; i < 4; i = i + 1)begin
        // prf[i].rob
        always @( posedge i_clk or negedge i_rstn ) begin
            if (!i_rstn) begin
                physical_reg_file[i] <= 'h0;
            end 
            else if(i_rob_valid & i_rob_dst_addr == i) begin
                physical_reg_file[i] <= i_rob_addr;
            end 
            else begin
                physical_reg_file[i] <= physical_reg_file[i];
            end
        end

        // prf[i].valid. After instruction retired, valid would change like 1 -> 0.
        always @( posedge i_clk or negedge i_rstn ) begin
            if (!i_rstn) begin
                physical_reg_file_valid[i] <= 'b0;
            end 
            else if(i_rob_valid & i_rob_dst_addr == i) begin
                physical_reg_file_valid[i] <= 'b1;
            end 
            else begin
                physical_reg_file_valid[i] <= physical_reg_file_valid[i];
            end
        end
    end
endgenerate

assign o_rs_tag_valid = i_rs_req & physical_reg_file_valid[i_rs_addr] == 1;
assign o_rs_tag = physical_reg_file[i_rs_addr];
assign o_rs_val_valid = i_rs_req & physical_reg_file_valid[i_rs_addr] == 0;
assign o_rs_val = architecture_reg_file[i_rs_addr];

// arf[i].rob
always @( posedge i_clk or negedge i_rstn ) begin
    if (!i_rstn) begin
        architecture_reg_file[0] <= 'h5;
        architecture_reg_file[1] <= 'h3;
        architecture_reg_file[2] <= 'h6;
        architecture_reg_file[3] <= 'h9;
    end 
    else begin
        architecture_reg_file[0] <= architecture_reg_file[0];
    end
end

endmodule