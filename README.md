# FPGsnAke
A snake game for the ATLYS FPGA

This project is based on the hdmi drivers provided by Xilinx for the ATLYS board.
The top_level.v file connects all the building blocks. There a little alternations i have done in that file to include
my extra buttons and the snake module. See comments inside the file for the exact location.

My additions on this are the files: 
debounce.v Which is a unit the waits for the input to stabilise for a number of cycles before it outputs it's value.
make_roms.py Which is a python program that takes as input an image and produces a verilog rom file out of it.
snake.v Which includes all the logic for the snake game.

Description of the snake.v file.

It takes as inputs:
The pixel clock for the given resolution (here we work at vga resolution so we have a 25MHz clock)
Two registers that indicate which pixel is going to get drawn on the screen.
Five button inputs (right, left, down, up, center) to move the snake. (The center button is unused for now)

It gives as outputs:
Three 8bit values for the color to draw on each given pixel.

On each cycle:
We count the number of cycles that have passed so we can perform actions every one second (25 million cycles for a 25MHz clock).
We check the button inputs so as to change the direction of the snake.
We check if for the given (x, y) pixel there is a brick wall, or a part of the snake, or an apple to draw, otherwise we draw a black pixel.

Every second:
We move the snake based on the direction it has.
We check if it ate an apple to increase the score and it's size.
We check if there was collision with the brick wall to make the snake cycle around the map.

More comments inside the files I have noted above explain extra info.
