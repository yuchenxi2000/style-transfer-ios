# style-transfer-ios

style transfer ios app，构建自己的风格迁移app。

pth转onnx、onnx转mlmodel的代码以及已经转换好的model已经发布，

iOS app的源码在2019.6.10以后发布在这个repository。

视频教程：https://www.bilibili.com/video/av52804993

## 1. 训练model & pth转onnx

使用pytorch官方给出的fast neural style 例子

https://github.com/pytorch/examples/tree/master/fast_neural_style

原代码被修改过，为了产生input, output都是image的mlmodel。

B站教程里无法生成图片的issue已经修复。

### usage

如何运行生成.onnx合适的model：

```shell
example$ python3 neural_style.py eval  --content-image $CONTENT_IMAGE --output-image $OUTPUT_IMAGE --model $MODEL_PATH --cuda 0

```

为了得到onnx模型必须输入一张图片，什么类型都可以。最终模型的输入图片尺寸就是原先输入图片的尺寸。

$CONTENT_IMAGE : 输入图片的路径

$OUTPUT_IMAGE : 输出图片的路径

$MODEL_PATH : 训练好的模型的路径

## 2. onnx 转mlmodel

onnx格式转mlmodel。

```shell
example$ python3 onnx-to-mlmodel.py
```

记得在代码里改文件路径 >_<

## 3. 最终结果

/models : 已经转好格式的model

不想做直接下载吧

感觉自己萌萌哒 : )

### input & output size

input : 1008 * 756 image with 3 channels (RGB)

output : 1008 * 756 image with 3 channels (RGB)

## 4. 构建UI，把model集成到app里

下载style/下的全部内容。把models/下的模型拖到style/style/models/下面（或者加入自己的模型）。

Xcode里编译运行不解释。

# Licence

发布在<https://github.com/pytorch/examples/tree/master/fast_neural_style>上的代码的licence：

BSD 3-Clause License

Copyright (c) 2017, All rights reserved. 



该代码的license：

MIT License

