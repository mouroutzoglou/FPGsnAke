from PIL import Image
from math import log2, ceil
title = "brick_wall.png"
dimensions = (32, 32)
im = Image.open(title, "r")
d = im.resize(dimensions)
pix_val = list(d.getdata())

output = """module """ + title.split(".")[0] + "_rom" + """(
        input wire clk,
        input wire [""" + str(ceil(log2(d.width)) - 1) + """:0] x,
        input wire [""" + str(ceil(log2(d.height)) - 1) + """:0] y,
        output reg [23:0] data
	);
	
	reg [""" + str(ceil(log2(d.width)) - 1) + """:0] x_reg;
	reg [""" + str(ceil(log2(d.height)) - 1) + """:0] y_reg;

	always @(posedge clk) begin
		x_reg <= x;
		y_reg <= y;
	end

	always @ * begin
	case ({y_reg, x_reg})\n"""

for i in range(d.height):
        for j in range(d.width):
                data = pix_val[i*d.width + j]
                #print(data)
                if i<d.height or j < d.width:
                        output += "                " + str(ceil(log2(d.width*d.height))) + "'b"+(format(i, '#0' + str(ceil(log2(d.height)) + 2) + 'b'))[2:]+(format(j, '#0' + str(ceil(log2(d.width)) + 2) + 'b'))[2:]+": data = 24'b" + (format(data[0], '#010b'))[2:] + (format(data[1], '#010b'))[2:] + (format(data[2], '#010b'))[2:]+";\n"
                else:
                        output += "                default: data = 24'b" + (format(data[0], '#010b'))[2:] + (format(data[1], '#010b'))[2:] + (format(data[2], '#010b'))[2:]+';'

output += """        endcase
        end
endmodule"""


f = open(title.split(".")[0] + "_rom.v", "w")
f.write(output)
f.close()
