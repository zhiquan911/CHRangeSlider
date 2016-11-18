//
//  CHRangeSlider.swift
//  Pods
//
//  Created by 麦志泉 on 2016/11/11.
//
//

import UIKit


// MARK: - 滑杆组件委托协议
public protocol CHRangeSliderDelegate {
    
    
    
    /// 监听控件滑动变化的回调
    ///
    /// - Parameters:
    ///   - slider:
    ///   - value:  滑块的值
    ///   - handler:    滑块对象
    /// - Returns:  返回顶部文本值
    func rangeSlider(slider: CHRangeSlider, stringForValue value: Double, handler: CHSliderHandler) -> String
    
}

//MARK: - 滑杆组件
@IBDesignable
public class CHRangeSlider: UIControl {
    
    //MARK: - 常量变量
    
    /// 固定的文本高度
    let kTextHeight: CGFloat = 14
    
    /// 触摸范围扩展，负数越大，越容易触摸
    let kHandlerTouchAreaExpansion: CGFloat = -15
    
    
    /// 初始点的位置，远离原点
    let kInitPoint = CGPoint(x: -10, y: -10)
    
    //MARK: - 公开变量
    
    /// 最小值
    @IBInspectable public var minValue: Double = 0 {
        didSet {
            self.refreshUI()
            //在调整一下各个滑块的标签位置
            self.handlers.map { handler in
                self.updateHandlerLabelPositions(handler: handler)
            }
        }
    }
    
    
    /// 最大值
    @IBInspectable public var maxValue: Double = 100 {
        didSet {
            self.refreshUI()
            //在调整一下各个滑块的标签位置
            self.handlers.map { handler in
                self.updateHandlerLabelPositions(handler: handler)
            }
        }
    }
    
    
    /// 左边间隔
    @IBInspectable public var paddingLeft: CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    
    /// 右间隔
    @IBInspectable public var paddingRight: CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// 滑杆高度
    @IBInspectable public var sliderHeight: CGFloat = 1 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    
    /// 选择时滑块的放大比例
    @IBInspectable public var selectedHandlerDiameterMultiplier: CGFloat = 1.5
    
    /// 始点图标
    @IBInspectable public var startImage: UIImage?
    
    
    /// 终点图标
    @IBInspectable public var endImage: UIImage?
    
    /// 控制点数组，在滑杆上显示的圆点按钮
    public var handlers: [CHSliderHandler] = [CHSliderHandler]() {
        willSet {
            for handler in self.handlers {
                //移除添加滑块组件
                handler.handlerLayer.removeFromSuperlayer()
                handler.topTextLayer.removeFromSuperlayer()
                handler.bottomTextLayer.removeFromSuperlayer()
            }
        }
        didSet {
            for handler in self.handlers {
                handler.slider = self
            }
            self.rebuildHandlers()
        }
    }
    
    
    /// 委托代理
    public var delegate: CHRangeSliderDelegate?
    
    
    //MARK: - 私有变量
    
    /// 滑杆条
    var sliderLine: CALayer!
    
    //开头的图标
    var startImageView: CALayer?
    
    //结尾的图标
    var endImageView: CALayer?
    
    var isActiving: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialiseControl()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialiseControl()
    }
    
    
    /// 初始化控件
    func initialiseControl() {
        
        //1.添加滑杆
        self.sliderLine = CALayer()
        self.sliderLine.backgroundColor = self.tintColor.cgColor
        self.layer.addSublayer(self.sliderLine)
        
        //2.添加首尾的自定义图标
        if let startImage = self.startImage {
            self.startImageView = CALayer()
            self.startImageView!.contents = startImage.cgImage
            
            self.layer.addSublayer(self.startImageView!)
            
            
        }
        
        if let endImage = self.endImage {
            self.endImageView = CALayer()
            self.endImageView!.contents = endImage.cgImage
            
            self.layer.addSublayer(self.endImageView!)
            
            
        }

    }
    
    
    /// 重建handler
    func rebuildHandlers() {
        
        //循环添加控件
        for handler in self.handlers {
            
            //3.在滑杆上创建按钮控件
            let handlerLayer = handler.handlerLayer
            handlerLayer.cornerRadius = handler.size / 2
            
            let initPoint = self.kInitPoint
            if let img = handler.handlerImage {
                handlerLayer.contents = img.cgImage
                handlerLayer.frame = CGRect(origin: initPoint,
                                            size: CGSize(width: img.size.width, height: img.size.width))
         
            } else {
                
                handlerLayer.frame = CGRect(origin: initPoint,
                                            size: CGSize(width: handler.size, height: handler.size))
            }
            
            handlerLayer.backgroundColor = handler.handlerColor.cgColor
            handlerLayer.borderColor = handler.borderColor.cgColor
            handlerLayer.borderWidth = 1
            self.layer.addSublayer(handlerLayer)
            
            let font = UIFont.systemFont(ofSize: handler.textSize)
            let initalTextWidth = handler.bottomText.ch_sizeWithConstrained(font: font).width
            handler.textWidth = initalTextWidth
            
            //4.在滑杆按钮上方创建文字
            let topTextLabel = handler.topTextLayer
            topTextLabel.alignmentMode = kCAAlignmentCenter
            topTextLabel.frame = CGRect(origin: initPoint,
                                        size: CGSize(width: initalTextWidth, height: self.kTextHeight))
            topTextLabel.fontSize = handler.textSize
            topTextLabel.contentsScale = UIScreen.main.scale
            topTextLabel.font = UIFont.systemFont(ofSize: handler.textSize)
            topTextLabel.foregroundColor = handler.normalColor.cgColor
            self.layer.addSublayer(topTextLabel)
            
            //5.在滑杆按钮下方创建文字
            let bottomTextLabel = handler.bottomTextLayer
            bottomTextLabel.alignmentMode = kCAAlignmentCenter
            bottomTextLabel.frame = CGRect(origin: initPoint,
                                           size: CGSize(width: initalTextWidth, height: self.kTextHeight))
            bottomTextLabel.fontSize = handler.textSize
            bottomTextLabel.contentsScale = UIScreen.main.scale
            bottomTextLabel.font = UIFont.systemFont(ofSize: handler.textSize)
            bottomTextLabel.foregroundColor = handler.normalColor.cgColor
            self.layer.addSublayer(bottomTextLabel)
        }
        
        //刷新布局
        self.setNeedsLayout()
    }
    
    
    /// 布局子视图
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        //NSLog("layoutSubviews")
        let currentFrame = self.frame
        let yMiddle = currentFrame.size.height / 2.0
        var lineLeftSide = CGPoint(x: self.paddingLeft, y: yMiddle)
        var lineRightSide = CGPoint(x: currentFrame.size.width - self.paddingRight, y: yMiddle)
        
        //1.添加首尾的自定义图标
        if let startImage = self.startImage {
            
            self.startImageView!.frame = CGRect(origin: lineLeftSide, size: startImage.size)
            
            //调整左边的X位置
            lineLeftSide.x += startImage.size.width
        }
        
        if let endImage = self.endImage {
            
            self.endImageView!.frame = CGRect(origin: lineRightSide, size: endImage.size)
            
            //调整右边的X位置
            lineRightSide.x -= endImage.size.width
            
        }
        
        //2.配置滑杆的尺寸
        self.sliderLine.frame = CGRect(x: lineLeftSide.x, y: lineLeftSide.y, width: lineRightSide.x - lineLeftSide.x, height: self.sliderHeight)
        
        self.sliderLine.cornerRadius = self.sliderHeight / 2.0
        
        //3.刷新UI
        self.refreshUI()
    }
    
}


// MARK: - 配置滑杆滑块位置
extension CHRangeSlider {
    
    
    /// 刷新UI
    public func refreshUI() {
        for handler in self.handlers {
            self.updateHandlerPositions(handler: handler)
        }
    }
    
    
    /// 更新滑块上方的文本值
    ///
    /// - Parameter handler:
    func updateLabelValue(handler: CHSliderHandler) {
        
        //把滑块数值传给上层代理处理成string格式再显示到滑块上方文本
        let topText = self.delegate?.rangeSlider(slider: self, stringForValue: handler.value, handler: handler) ?? ""
        
        handler.topText = topText
        
        //更新滑块文本的宽度
        let font = UIFont.systemFont(ofSize: handler.textSize)
        let bottomTextWidth = handler.bottomText.ch_sizeWithConstrained(font: font).width
        let topTextWidth = handler.topText.ch_sizeWithConstrained(font: font).width
        
        handler.textWidth = topTextWidth > bottomTextWidth ? topTextWidth : bottomTextWidth
    }
    
    
    /// 更新滑块位置
    /// 因为每次只能移动一个滑块
    /// - Parameter handler: 滑块
    func updateHandlerPositions(handler: CHSliderHandler) {
        
        //检查值是否需要重置
        _ = self.resetValueInRange(handler: handler)
        
        let newX = self.getXPositionAlongLineForValue(value: handler.value)
//        NSLog("\(handler.bottomText) \(newX) == \(handler.handlerLayer.position.x)")
        if newX == handler.handlerLayer.position.x {
            return  //如果滑块x轴没有变化就不执行重置位置
        }
        

        
        //http://www.jianshu.com/p/930cea99023d
        //每一个uiview都默认关联着一个CALayer，我们成这个layer为root layer
        //所有的非root layer都存在默认的隐私动画，隐式动画默认为1/4秒。
        //所以拖动操作改变滑块组件位置的事务时把隐式动画关闭，不然会因为动画导致慢
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        //更新标签值
        self.updateLabelValue(handler: handler)
        
        //获取滑块数值并转为对应的X坐标
        let handlerCenter = CGPoint(x: newX, y: self.sliderLine.frame.midY)
        
        //更新滑块位置
        handler.handlerLayer.position = handlerCenter

        //更新标签位置
        self.updateHandlerLabelPositions(handler: handler)
        CATransaction.commit()

    }
    
    
    /// 更新滑块位置
    func updateHandlerLabelPositions(handler: CHSliderHandler) {

        //获取滑块的中间坐标
        let handlerCenter = CGPoint(x: handler.handlerLayer.frame.midX,
                                    y: handler.handlerLayer.frame.midY)
        
        //更新文本宽度
        handler.topTextLayer.frame = CGRect(x: 0, y: 0,
                                            width: handler.textWidth,
                                            height: self.kTextHeight)
        handler.bottomTextLayer.frame = CGRect(x: 0, y: 0,
                                               width: handler.textWidth,
                                               height: self.kTextHeight)
        
        //新的上方文本位置
        let newTopLabelCenter = CGPoint(x: handlerCenter.x,
                                        y: handler.handlerLayer.frame.midY - handler.size / 2 - handler.topTextLayer.frame.size.height / 2 - handler.labelPadding)
        
        //新的下方文本位置
        let newBottomLabelCenter = CGPoint(x: handlerCenter.x,
                                           y: handler.handlerLayer.frame.midY + handler.size / 2 + handler.bottomTextLayer.frame.size.height / 2 + handler.labelPadding)
        
        handler.topTextLayer.position = newTopLabelCenter
        handler.bottomTextLayer.position = newBottomLabelCenter
        
        //检查滑块是否重叠，调整标签的Y值位置
        self.adjustHandlerLabelYPosition(handler: handler)
        
        
    }
    
    
    /// 检查滑块是否重叠，调整标签Y值位置
    ///
    /// - Parameter handler:
    func adjustHandlerLabelYPosition(handler: CHSliderHandler) {
        
        //新的上方文本位置
        var newTopLabelCenter = handler.topTextLayer.position
        
        //新的下方文本位置
        var newBottomLabelCenter = handler.bottomTextLayer.position
        
        
        //判断该滑块label是否碰到其它滑块的label
        var otherHandlers = self.handlers
        otherHandlers.ch_removeObject(handler)
        var topTextY: CGFloat = newTopLabelCenter.y   //临时记录顶部文本最上的Y
        var bottomTextY: CGFloat = newBottomLabelCenter.y   //临时记录底部文本最下的Y
        for other in otherHandlers {
            
            guard other.handlerLayer.frame.origin != self.kInitPoint else {
                continue    //如果其它滑块位置未初始化过，就不调整
            }
            
            //判断顶部文本是否与其它的相交
            let isTopRectIn = handler.topTextLayer.frame.ch_intersects(rect: other.topTextLayer.frame)
            
            //1.判断X轴是否与其它滑块的label相交
            if isTopRectIn.x {
                //2.如果X轴上相交，记录新的Y值移动至相交对象的上方
                let newY = other.topTextLayer.frame.midY - other.topTextLayer.frame.size.height - handler.labelPadding / 2
                
                //3.如果这个新Y值比最上的还高，则替换最上位置的Y值为此新Y值
                if newY < topTextY {
                    topTextY = newY
                }
                
                //4.如果相交对象与Y轴也相交，则把现对象新Y值更改
                if isTopRectIn.y {
                    newTopLabelCenter.y = topTextY
                }
                
            }
            
            
            //判断底部文本是否与其它的相交
            let isBottomRectIn = handler.bottomTextLayer.frame.ch_intersects(rect: other.bottomTextLayer.frame)
            
            //1.判断X轴是否与其它滑块的label相交
            if isBottomRectIn.x {
                
                //2.如果X轴上相交，记录新的Y值移动至相交对象的下方
                let newY = other.bottomTextLayer.frame.midY + other.bottomTextLayer.frame.size.height + handler.labelPadding / 2
                
                //3.如果这个新Y值比最下的还低，则替换最下位置的Y值为此新Y值
                if newY > bottomTextY {
                    bottomTextY = newY
                }
                
                //4.如果相交对象与Y轴也相交，则把现对象新Y值更改
                if isBottomRectIn.y {
                    newBottomLabelCenter.y = bottomTextY
                }
                
            }
            
            //记录最新的位置
            handler.topTextLayer.position = newTopLabelCenter
            handler.bottomTextLayer.position = newBottomLabelCenter
        }
        
        
        
    }
    
    
    /// 获取滑块值在滑杆的比例值
    ///
    /// - Parameter value: 数值
    func getPercentageAlongLineForValue(value: Double) -> Double {
        if self.minValue == self.maxValue {
            return 0
        }
        
        let maxMinDif = self.maxValue - self.minValue
        
        let valueSubtracted = value - self.minValue
        
        return valueSubtracted / maxMinDif
    }
    
    
    /// 通过数值获取对应滑杆中的X坐标值
    ///
    /// - Parameter value:
    /// - Returns:
    func getXPositionAlongLineForValue(value: Double) -> CGFloat {
        
        let percentage = self.getPercentageAlongLineForValue(value: value)
        
        let maxMinDif = self.sliderLine.frame.maxX - self.sliderLine.frame.minX
        
        let offset = CGFloat(percentage) * maxMinDif

        return self.sliderLine.frame.minX + offset
    }
    
    
    
    /// 获取活动中的滑块
    ///
    /// - Returns:
    func getActivingHandler() -> CHSliderHandler? {
        
        var aHandler: CHSliderHandler?
        for handler in self.handlers {
            if handler.isActiving {
                aHandler = handler
            }
        }
        
        return aHandler
        
    }
    
    
    /// 选中滑块产生动画过渡
    ///
    /// - Parameters:
    ///   - handler: 滑块
    ///   - selected: 是否选中
    func animateHandler(handler: CHSliderHandler, selected: Bool) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        if selected {
                            //放大动画
                            handler.handlerLayer.transform = CATransform3DMakeScale(
                                self.selectedHandlerDiameterMultiplier,
                                self.selectedHandlerDiameterMultiplier, 1)
                            
                        } else {
                            //恢复正常比例
                            handler.handlerLayer.transform = CATransform3DIdentity
                        
                        }
                        
                        //偏移标签位置
                        self.updateHandlerLabelPositions(handler: handler)
                        
                        
        }, completion: nil)
    }
    
    
    /// 检查滑块值是否超过范围需要充值
    ///
    /// - Parameter handler:
    /// - Returns: 
    func resetValueInRange(handler: CHSliderHandler) -> Bool {
        var flag = false
        if handler.value < self.minValue {
            handler.value = self.minValue
            flag = true
        }
        
        if handler.value > self.maxValue {
            handler.value = self.maxValue
            flag = true
        }
        
        return flag
    }
}


// MARK: - 重载触摸滑动轨迹的方法
extension CHRangeSlider {
    
    
    /// 检查触摸的滑块是否触摸中
    ///
    /// - Returns: 是否触摸， 触摸最临近的滑块
    func getHandler(by gesturePressLocation: CGPoint) -> CHSliderHandler? {
        
        var touchHandler: CHSliderHandler?
        
        //初始最小距离为整个组件宽度，这样才能让下面第一个点就记录最小值
        var minDistance: CGFloat = self.bounds.width
        for handler in self.handlers {
            let touchArea = handler.handlerLayer.frame.insetBy(
                dx: self.kHandlerTouchAreaExpansion,
                dy: self.kHandlerTouchAreaExpansion)
            if touchArea.contains(gesturePressLocation) {
                //计算点的距离
                let distance = handler.handlerLayer.position.distanceBetweenPoint(point: gesturePressLocation)
                if distance < minDistance {
                    //记录最小距离的那个
                    minDistance = distance
                    touchHandler = handler
                }
            }
        }
        
        return touchHandler //如果没找到返回的nil
    }
    
    
    /// 开始滑动
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        /// 把触摸点转换为坐标
        let gesturePressLocation = touch.location(in: self)
//        NSLog("gesturePressLocation = \(gesturePressLocation)")
        guard let handler = self.getHandler(by: gesturePressLocation) else {
            return false    //没找到就不处理滑动了
        }
        
        handler.isActiving = true
        self.isActiving = true
        
        //把当前选中的滑块前置到顶部
        self.layer.ch_bringSublayerToFront(layer: handler.handlerLayer)

        //执行开始滑动动画
        self.animateHandler(handler: handler, selected: true)
        
        return true
        
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        let prelocation = touch.previousLocation(in: self)
        let offSet = location.x - prelocation.x
        
        guard let handler = self.getActivingHandler() else {
            return false
        }
        
        //滑块X位置 + 滑动偏移量 = 滑块新的中心位置
        let newX = handler.handlerLayer.frame.midX + offSet
        //计算触摸点在滑杆的距离比例, (newX - 开始X) / 滑杆宽度
        let percentage = (newX - self.sliderLine.frame.minX) / self.sliderLine.frame.width
        
        //转为具体数值
        var selectedValue = Double(percentage) * (self.maxValue - self.minValue) + self.minValue
        
        //判断是否超过范围
        if selectedValue >= handler.maxValue ?? self.maxValue {
            selectedValue = handler.maxValue ?? self.maxValue
        }
        
        if selectedValue < handler.minValue ?? self.minValue {
            selectedValue = handler.minValue ?? self.minValue
        }
        handler.value = selectedValue
        
        return true
        
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        guard let handler = self.getActivingHandler() else {
            return
        }
        
        handler.isActiving = false
        self.isActiving = false
        //执行结束滑动动画
        self.animateHandler(handler: handler, selected: false)
        
        //在调整一下各个滑块的标签位置
        self.handlers.map { handler in
            self.updateHandlerLabelPositions(handler: handler)
        }
    }
}


// MARK: - 为IB界面配置模拟数据
extension CHRangeSlider {
    
    
    /// 模拟数据调试
    public override func prepareForInterfaceBuilder() {
        let minSelectItem = CHSliderHandler()
        minSelectItem.bottomText = "委托价"
        minSelectItem.value = 10
        minSelectItem.handlerColor = self.tintColor
        let maxSelectItem = CHSliderHandler()
        maxSelectItem.bottomText = "触发价"
        maxSelectItem.value = 80
        maxSelectItem.handlerColor = UIColor.white
        maxSelectItem.borderColor = self.tintColor
        self.handlers = [minSelectItem, maxSelectItem]
    }
}
