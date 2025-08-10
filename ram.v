module ram(
   clk,rst_n,din,rx_valid,dout,tx_valid
);
    parameter MEM_DEPTH = 256;
    parameter ADDR_SIZE = 8;
    input clk,rst_n,rx_valid;
    input [9:0] din;
    output reg tx_valid;
    output reg [ADDR_SIZE-1 : 0] dout;
    
    reg [ADDR_SIZE-1 : 0] mem [MEM_DEPTH-1 : 0];
    reg [ADDR_SIZE-1 : 0]rw_address;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            dout <= 8'd0;
            tx_valid <= 0;
        end
        else begin            
            if (rx_valid) begin
                case (din[9:8])
                    2'b00: begin
                        tx_valid <= 0;
                        rw_address <= din[7:0];
                    end
                    2'b01: begin
                      tx_valid <= 0;
                      mem[rw_address] <= din[7:0];
                    end 
                    2'b10: begin
                      tx_valid <= 0;
                      rw_address <= din[7:0];
                    end 
                    2'b11: begin
                        tx_valid <= 1;
                        dout <= mem[rw_address];
                    end
                endcase
            end
            
        end
    end    
endmodule
