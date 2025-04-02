**REORDER RELU TO MAXPOOL**

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

![Image](https://github.com/user-attachments/assets/238bc4fb-e5dd-46d1-99eb-d1d9191eca9d)


**Sample ONNXIR before optimization:**

![Image](https://github.com/user-attachments/assets/1863f85c-f509-483f-8ecc-2781ac0d8caf)


**Sample ONNXIR after optimization:**

![Image](https://github.com/user-attachments/assets/aba508b2-47af-45b1-95b5-75f6e5213159)
