//
//  CHSliderHandler.swift
//  Pods
//
//  Created by 麦志泉 on 2016/11/13.
//
//

import UIKit

//MARK: - 滑块组件
public class CHSliderHandler: NSObject {
    
    //MARK: - 公开成员变量
    
    /// 背景颜色
    public var handlerColor: UIColor = UIColor.clear
    
    /// 边框颜色
    public var borderColor: UIColor = UIColor.clear
    
    /// 控制按钮的图片
    public var handlerImage: UIImage?
    
    
    /// 大小
    public var size: CGFloat = 16 {
        didSet {
            self.handlerLayer.frame = CGRect(origin: CGPoint.zero,
                                             size: CGSize(width: self.size, height: self.size))
        }
    }
    
    
    /// 按钮上方的文字
    public var topText: String = "" {
        didSet {
            self.topTextLayer.string = topText
        }
    }
    
    
    /// 按钮下方的文字
    public var bottomText: String = "" {
        didSet {
            self.bottomTextLayer.string = bottomText
        }
    }
    
    
    /// 是否可以实心穿透
    public var isSolid: Bool = true
    
    
    /// 最大可移动值
    public var maxValue: Double?
    
    
    /// 最小可移动值
    public var minValue: Double?
    
    
    /// 当前值
    public var value: Double = 0 {
        didSet {
            //self.topText = "\(value)"
            self.slider?.updateHandlerPositions(handler: self)

        }
    }
    
    
    /// 文字大小
    public var textSize: CGFloat = 12
    
    
    /// 文本标签与滑块的距离
    public var labelPadding: CGFloat = 8 {
        didSet {
            self.slider?.updateHandlerLabelPositions(handler: self)
        }
    }
    
    /// 高亮颜色
    public var highlightColor: UIColor = UIColor.gray
    
    /// 正常颜色
    public var normalColor: UIColor = UIColor.gray
    
    
    /// 它所属的滑杆
    weak var slider: CHRangeSlider?
    
    /// 上方的文本layer
    var topTextLayer: CATextLayer = CATextLayer()
    
    /// 下方的文本layer
    var bottomTextLayer: CATextLayer = CATextLayer()
    
    /// 控制按钮
    var handlerLayer: CAShapeLayer = CAShapeLayer()
    
    /// 是否滑动中
    var isActiving: Bool = false
    
    
    /// 文本宽度
    var textWidth: CGFloat = 60
    
    
    
    convenience init(handlerColor: UIColor, handlerImage: UIImage? = nil, isSolid: Bool = true) {
        self.init()
        self.handlerColor = handlerColor
        self.handlerImage = handlerImage
        self.isSolid = isSolid
    }

    
}
