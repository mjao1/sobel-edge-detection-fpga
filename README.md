# Sobel Edge Detection FPGA
A convolution-based Sobel edge detection system on the Nexys A7 FPGA. An input image is converted into a .mem file using a Python script, which is then loaded into BRAM configured as a ROM. The FPGA performs convolution operations using the Sobel operator to detect edges within the image. The processed image is then displayed through a VGA interface. The system allows for real-time adjustment of the edge detection threshold via the onboard switches.
<p align = "center">
  <img src="https://github.com/user-attachments/assets/996b5f9b-7dea-4d06-9649-db518f84a09c">
  <img src="https://github.com/user-attachments/assets/eb4df749-3f88-41db-a133-1d473dd258ef" width="49%"/> <img src="https://github.com/user-attachments/assets/365c8a94-5303-476b-af10-55445f00e54d" width="50%"/> 
  <img src="https://github.com/user-attachments/assets/eb916cda-808f-4586-93e6-233fbb385ddb" width="49%"/> <img src="https://github.com/user-attachments/assets/35e44b44-8a9d-427d-a948-93c538a196d8" width="50%"/>
  <img src="https://github.com/user-attachments/assets/5d11b978-2d57-4616-afa0-b9657485fbc7" width="49%"/> <img src="https://github.com/user-attachments/assets/a85007ea-1d78-4fa7-bb0d-466dbc1af1d0" width="50%"/>
  
