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
    
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var label: UILabel!
    @IBOutlet var textFieldOrder: UITextField!
    @IBOutlet var textFieldCurrent: UITextField!
    @IBOutlet var textFieldTrigger: UITextField!
    
    @IBOutlet var rangeSlider: CHRangeSlider!
    var minSelectItem: CHSliderHandler!
    var midSelectItem: CHSliderHandler!
    var maxSelectItem: CHSliderHandler!
    
    let currentValue: Double = 5000

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rangeSlider.minValue = currentValue * (100 - self.stepper.value) / 100
        self.rangeSlider.maxValue = currentValue * (100 + self.stepper.value) / 100
        
        self.rangeSlider.delegate = self
        minSelectItem = CHSliderHandler()
        minSelectItem.bottomText = "委托价"
        minSelectItem.value = 4700
        minSelectItem.handlerColor = UIColor.red
        
        midSelectItem = CHSliderHandler()
        midSelectItem.bottomText = "当前价"
        midSelectItem.value = 5000
        midSelectItem.handlerColor = self.rangeSlider.tintColor
        
        maxSelectItem = CHSliderHandler()
        maxSelectItem.bottomText = "触发价"
        maxSelectItem.value = 5300
        maxSelectItem.handlerColor = UIColor.white
        maxSelectItem.borderColor = self.rangeSlider.tintColor
        self.rangeSlider.handlers = [minSelectItem, midSelectItem, maxSelectItem]
        
    }

    @IBAction func stepperValueChanged(sender: UIStepper) {
        let min = currentValue * (100 - self.stepper.value) / 100
        let max = currentValue * (100 + self.stepper.value) / 100
        self.label.text = "\(sender.value)%"

        self.rangeSlider.minValue = min
        self.rangeSlider.maxValue = max
    }


    //隐藏键盘
    @objc func closeKeyBoard() {
        let window = UIApplication.shared.keyWindow
        window?.endEditing(false)
    }
    
}


// MARK: - 实现滑杆委托方法
extension ViewController: CHRangeSliderDelegate {
    
    func rangeSlider(slider: CHRangeSlider, stringForValue value: Double, handler: CHSliderHandler) -> String {
        let text = String(format: "￥%.2f", value)
        if handler === self.minSelectItem
            && self.minSelectItem.isActiving {
            self.textFieldOrder.text = String(format: "%.2f", value)
        } else if handler === self.midSelectItem
            && self.midSelectItem.isActiving {
            self.textFieldCurrent.text = String(format: "%.2f", value)
        } else if handler === self.maxSelectItem
            && self.maxSelectItem.isActiving {
            self.textFieldTrigger.text = String(format: "%.2f", value)
        }
        return text
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = self.getInputAccessoryView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === self.textFieldOrder {
            self.minSelectItem.value = Double(textField.text ?? "0")!
        } else if textField === self.textFieldCurrent {
            self.midSelectItem.value = Double(textField.text ?? "0")!
        } else if textField === self.textFieldTrigger {
            self.maxSelectItem.value = Double(textField.text ?? "0")!
        }
    }
    
    
    func getInputAccessoryView() -> UIView {
        let toolbar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.bounds.size.width, height: 44)))
        let right = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.done,
            target: self,
            action: #selector(self.closeKeyBoard))
        
        toolbar.items = [right]
        
        return toolbar
    }
}

