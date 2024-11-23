# sobel-edge-detection-fpga
A convolution-based Sobel edge detection system on a Basys3 Artix-7 FPGA. An input image is converted into a .mem file using a Python script, which is then loaded onto the Basys3 FPGA. The FPGA performs convolution operations using the Sobel operator to detect edges within the image. The processed image is then displayed through a VGA interface. The system allows for real-time adjustment of the edge detection threshold via the Basys3's onboard switches.
<p align = "center">
  <img src="https://github.com/user-attachments/assets/996b5f9b-7dea-4d06-9649-db518f84a09c">
</p>
