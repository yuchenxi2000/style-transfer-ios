# style-transfer-ios

style transfer ios app，构建自己的风格迁移app。

# 如何在 iOS 上使用 pytorch 模型

## 1. 训练 model & pth 转 onnx

使用 pytorch 官方给出的 fast neural style 例子

https://github.com/pytorch/examples/tree/master/fast_neural_style

原代码被修改过，为了产生 input, output 都是 image 的 mlmodel。

### usage

如何运行生成 .onnx 格式的 model：

```shell
python3 neural_style.py eval --content-image $CONTENT_IMAGE --output-image $OUTPUT_IMAGE --model $MODEL_PATH --cuda 0
```

为了得到onnx模型必须输入一张图片，什么类型都可以。最终模型的输入图片尺寸就是原先输入图片的尺寸。

$CONTENT_IMAGE : 输入图片的路径

$OUTPUT_IMAGE : 输出图片的路径

$MODEL_PATH : 训练好的模型的路径

## 2. onnx 转 mlmodel

onnx 格式转 mlmodel。

```shell
example$ python3 onnx-to-mlmodel.py
```

记得在代码里改文件路径 >_<

## 3. 最终结果

/style/style/models : 已经转好格式的 model

> input & output size

> input : 1008 * 756 image with 3 channels (RGB)

> output : 1008 * 756 image with 3 channels (RGB)

## 4. 构建UI，把model集成到app里

style 是一个示例 App，自带了一些模型。

# Licence

MIT License

