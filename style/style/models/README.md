# Notice

请把风格迁移模型放到该文件夹下。

* 如果你使用该仓库下的模型（在models/下），直接把它们拖到该文件夹下。

* 如果使用自己的模型。可能需要改代码。需要修改ViewController.swift下的loadModel函数才能正常编译。

原型

``` swift
func loadModel(_ style : Int) -> MLModel
```

当然，还需修改一些细节（label上的文字，etc）自己看吧。

