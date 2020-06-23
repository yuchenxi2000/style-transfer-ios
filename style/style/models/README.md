# Model Folder

请把风格迁移模型放到该文件夹下。这里是我自己的模型。

如果你想使用自己的模型，可以把它们放在这儿，当然需要改代码。需要修改ViewController.swift下的loadModel函数才能正常编译。

改这个：

``` swift
func loadModel(_ style : Int) -> MLModel
```

（当然，还需修改一些细节，label上的文字，etc）

# Input & output

模型的输入，输出：

input : 1008 * 756 image with 3 channels (RGB)

output : 1008 * 756 image with 3 channels (RGB)

