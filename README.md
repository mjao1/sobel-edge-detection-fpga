# sobel-edge-detection-fpga
A convolution-based Sobel edge detection system on a Basys3 Artix-7 FPGA. An input image is converted into a .mem file using a Python script, which is then loaded into BRAM configured as a ROM. The FPGA performs convolution operations using the Sobel operator to detect edges within the image. The processed image is then displayed through a VGA interface. The system allows for real-time adjustment of the edge detection threshold via the onboard switches on the Basys3.
<p align = "center">
  <img src="https://github.com/user-attachments/assets/996b5f9b-7dea-4d06-9649-db518f84a09c">
  <img src="https://github.com/user-attachments/assets/1c3452e2-a304-4947-bcb9-de8992387c69" width="49%"/> <img src="https://github.com/user-attachments/assets/b7435c19-5fe7-4535-8739-6e31ab17da61" width="50%"/> 
</p>
