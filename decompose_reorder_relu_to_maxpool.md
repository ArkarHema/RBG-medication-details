***REORDER RELU TO MAXPOOL***

**Definition:**

The ReorderReLUToMaxPool pass is an optimization technique designed to improve memory efficiency and reduce redundant computations by reordering the ReLU and MaxPool layers in an ONNX model. 


In this pass: 

- This transformation is safe because MaxPool inherently filters out negative values (similar to ReLU), ensuring that the output semantics remain unchanged. 

- By switching their order, the ReLU operation is applied only to the reduced feature map produced by MaxPool, reducing the total number of element-wise computations. 

Assume the input to the original ReLU and MaxPool layers has the following dimensions: 

- Input shape: (N, C, H, W) 
  
- MaxPool kernel size: (kH, kW) 
  
- Stride: (sH, sW) 


**Original Flow (ReLU → MaxPool)** 

- ReLU processes N × C × H × W elements. 

- MaxPool processes the same number of elements in the input but only outputs a reduced tensor. 


**Optimized Flow (MaxPool → ReLU)**

- MaxPool first reduces the spatial dimensions. 

- Resulting output shape: 

![Image](https://github.com/user-attachments/assets/cb6415cc-c33d-4bdb-8fb8-4557d56a18e5)

- ReLU is then applied to this reduced feature map. 


**Computational Savings:** 

![Image](https://github.com/user-attachments/assets/23a9dca0-651d-4647-ab4f-d90230d46e90)

For input shape (1, 64, 224, 224) with kernel size (2, 2) and stride (2, 2): 

- Original ReLU computes: **3,211,264 elements** 

-  ReLU computes: **802,816 elements**


**SAMPLE ONNX FLOW:**

![relu_maxpool_before onnx](https://github.com/user-attachments/assets/bca07e3a-9460-41e0-9e8f-b3dd2da07b52)


**Sample ONNXIR before optimization:**

![relu_maxpool_before1 onnx mlir](https://github.com/user-attachments/assets/595706d3-44c7-475e-a1af-28703bc18fbe)


**Sample ONNXIR after optimization:**

![relu_maxpool_1 onnx11 mlir](https://github.com/user-attachments/assets/f8d8134b-b3c5-4d22-9daf-4fd879116e50)

