# CHRangeSlider

[![CI Status](http://img.shields.io/travis/麦志泉/CHRangeSlider.svg?style=flat)](https://travis-ci.org/麦志泉/CHRangeSlider)
[![Version](https://img.shields.io/cocoapods/v/CHRangeSlider.svg?style=flat)](http://cocoapods.org/pods/CHRangeSlider)
[![License](https://img.shields.io/cocoapods/l/CHRangeSlider.svg?style=flat)](http://cocoapods.org/pods/CHRangeSlider)
[![Platform](https://img.shields.io/cocoapods/p/CHRangeSlider.svg?style=flat)](http://cocoapods.org/pods/CHRangeSlider)

>Swift3编写的多点滑杆组件，支持一条滑杆，多个滑块滑动操纵

![demo1.jpg](https://github.com/zhiquan911/CHRangeSlider/blob/master/demo1.png)

## Features

- Swift3.0编写
- 支持在滑杆上无限添加滑块点
- 提供滑块上下文本标签内容修改
- 可通过IB修改滑杆颜色，高度，边距等等
- 可自定滑块颜色，图标，大小，文字格式等等
- 滑动流畅，数值准确

## Example

```swift

@IBOutlet var rangeSlider: CHRangeSlider!

override func viewDidLoad() {
    super.viewDidLoad()
    rangeSlider.minValue = 4500
    rangeSlider.maxValue = 5500

    rangeSlider.delegate = self
    let minSelectItem = CHSliderHandler()
    minSelectItem.bottomText = "委托价"
    minSelectItem.value = 4600
    minSelectItem.handlerColor = UIColor.red

    let midSelectItem = CHSliderHandler()
    midSelectItem.bottomText = "当前价"
    midSelectItem.value = 5000
    midSelectItem.handlerColor = self.rangeSlider.tintColor

    let maxSelectItem = CHSliderHandler()
    maxSelectItem.bottomText = "触发价"
    maxSelectItem.value = 5300
    maxSelectItem.handlerColor = UIColor.white
    maxSelectItem.borderColor = self.rangeSlider.tintColor
    maxSelectItem.isSolid = false
    self.rangeSlider.handlers = [minSelectItem, midSelectItem, maxSelectItem]
}

// MARK: - 实现滑杆委托方法
extension ViewController: CHRangeSliderDelegate {
    
    func rangeSlider(slider: CHRangeSlider, stringForValue value: Double, handler: CHSliderHandler) -> String {
        let text = String(format: "￥%.2f", value)
        if handler === self.minSelectItem {
            self.textFieldOrder.text = String(format: "%.2f", value)
        } else if handler === self.midSelectItem {
            self.textFieldCurrent.text = String(format: "%.2f", value)
        } else if handler === self.maxSelectItem {
            self.textFieldTrigger.text = String(format: "%.2f", value)
        }
        return text
    }
}

```


## Requirements

- iOS 8+
- Xcode 8+
- Swift 3.0+
- iPhone/iPad

## Installation

CHRangeSlider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CHRangeSlider"
```

## Author

Chance, zhiquan911@qq.com

## License

CHRangeSlider is available under the MIT license. See the LICENSE file for more info.
