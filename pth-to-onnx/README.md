# Description

pytorch官方给出的fast neural style 例子

https://github.com/pytorch/examples/tree/master/fast_neural_style

原代码被修改过，为了产生input, output都是image的mlmodel。

B站教程里无法生成图片的issue已经修复。

<https://www.bilibili.com/video/av52804993>



# Usage

如何运行生成.onnx合适的model：

```shell
example$ python3 neural_style.py eval  --content-image $CONTENT_IMAGE --output-image $OUTPUT_IMAGE --model $MODEL_PATH --cuda 0

```

为了得到onnx模型必须输入一张图片，什么类型都可以。最终模型的输入图片尺寸就是原先输入图片的尺寸。

$CONTENT_IMAGE : 输入图片的路径

$OUTPUT_IMAGE : 输出图片的路径

$MODEL_PATH : 训练好的模型的路径



# Licence

发布在<https://github.com/pytorch/examples/tree/master/fast_neural_style>上的代码的licence：

BSD 3-Clause License

Copyright (c) 2017, All rights reserved. 



该代码的license：

MIT License
