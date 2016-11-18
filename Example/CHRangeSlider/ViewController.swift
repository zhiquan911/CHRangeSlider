//
//  ViewController.swift
//  CHRangeSlider
//
//  Created by 麦志泉 on 11/11/2016.
//  Copyright (c) 2016 麦志泉. All rights reserved.
//

import UIKit
import CHRangeSlider

class ViewController: UIViewController {
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


// MARK: - 实现滑杆委托方法
extension ViewController: CHRangeSliderDelegate {
    
    func rangeSlider(slider: CHRangeSlider, stringForValue value: Double, handler: CHSliderHandler) -> String {
        let text = String(format: "￥%.2f", value)
        return text
    }
}

