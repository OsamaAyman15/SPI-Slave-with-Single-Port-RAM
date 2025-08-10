module spi(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
    parameter IDLE = 3'b000;
    parameter CHK_CMD = 3'b001;
    parameter WRITE = 3'b010;
    parameter READ_ADD = 3'b011;
    parameter READ_DATA = 3'b100;
    input MOSI,clk,rst_n,SS_n,tx_valid;
    input [7:0] tx_data;
    output reg MISO,rx_valid;
    output reg [9:0] rx_data;
    reg [9:0] parallel;
    reg flag_read;
    reg [3:0] counter;
    reg [3:0]msio_count;
    reg [2:0] cs,ns;
  /////// STATE MEMORY ///////////////////
    always @(posedge clk) begin
        if (!rst_n) begin
            cs <= IDLE;
        end
        else begin
            cs <= ns;
        end
    end
  ////// NEXT STATE LOGIC ////////////////
    always @(cs , SS_n , MOSI) begin
        case (cs)
            IDLE: begin
              if (SS_n) begin
                ns = IDLE;
              end 
              else begin
                ns = CHK_CMD;
              end
            end 
            CHK_CMD: begin
            if (SS_n) begin
                ns = IDLE;
            end 
            else begin
                if (!MOSI) begin
                    ns = WRITE;
                end
                else begin
                    if (!flag_read) begin
                        ns = READ_ADD;
                    end
                    else begin
                        ns = READ_DATA;
                    end
                end
              end
            end
            WRITE: begin
              if (SS_n) begin
                 ns = IDLE;
              end
              else begin
                 ns = WRITE;
              end
            end
            READ_ADD:begin
              if (SS_n) begin
                 ns = IDLE;
              end
              else begin
                 ns = READ_ADD;
              end
            end
            READ_DATA: begin
             if (SS_n) begin
                ns = IDLE;
             end
             else begin
                ns = READ_DATA;
             end
          end
        endcase
    end
//////// OUTPUT LOGIC ///////////////////////
    always @(posedge clk ) begin
       if (!rst_n) begin
        MISO <= 0;
        counter <= 10;
        msio_count <= 8;
        parallel <= 0; 
        flag_read <= 0;
        rx_valid <= 0;
       end
       else begin
        case (cs)
         WRITE: begin
         if (counter > 0) begin
             parallel [counter - 1] <= MOSI;
             counter <= counter - 1; 
         end
         else begin
            rx_data <= parallel;
             rx_valid <= 1;
             counter <= 10;
          end
         end 
         READ_ADD: begin
         if (counter > 0) begin
             parallel [counter - 1] <= MOSI;
             counter <= counter - 1; 
         end
         else begin
            rx_data <= parallel;
             rx_valid <= 1;
             flag_read <= 1;
             counter <= 10;
          end
         end
         READ_DATA: begin
         if (counter > 0) begin
             parallel [counter - 1] <= MOSI;
             counter <= counter - 1; 
         end
         else begin
            rx_data <= parallel;
             rx_valid <= 1;
             flag_read <= 0;
             if (tx_valid) begin
                rx_valid <= 0;
               if (msio_count > 0) begin
                 MISO <= tx_data [msio_count - 1];
                 msio_count <= msio_count - 1; 
               end
               else begin
                msio_count <= 8;
                counter <= 10;
               end
             end
         end
       end
       default : rx_valid <= 0;
     endcase
       end
   end
endmodule
