//
//  CHRangeSliderExtension.swift
//  Pods
//
//  Created by 麦志泉 on 2016/11/15.
//
//

import UIKit

// MARK: - 扩展CGRect功能
extension CGRect {
    
    /// 判断两个矩形是否相关
    ///
    /// - Parameters:
    ///   - rect: 与之判断的矩形
    /// - Returns: x轴相关？，y轴相交？
    func ch_intersects(rect: CGRect) -> (x: Bool, y: Bool) {
        var xIn = false
        var yIn = false
        if self.maxX > rect.minX && self.maxX <= rect.maxX {
            xIn = true
        } else if self.minX >= rect.minX && self.minX < rect.maxX {
            xIn = true
        } else if self.minX < rect.minX && self.maxX > rect.maxX {
            xIn = true
        } else {
            xIn = false
        }
        
        if self.maxY > rect.minY && self.maxY <= rect.maxY {
            yIn = true
        } else if self.minY >= rect.minY && self.minY < rect.maxY {
            yIn = true
        } else if self.minY < rect.minY && self.maxY > rect.maxY {
            yIn = true
        } else {
            yIn = false
        }
        
        return (xIn, yIn)
    }
    
}


// MARK: - 扩展Point
extension CGPoint {
    
    
    /// 获取两点之间的距离
    ///
    /// - Parameter point:
    /// - Returns:
    func distanceBetweenPoint(point: CGPoint) -> CGFloat {
        let xDist = self.x - point.x
        let yDist = self.y - point.y
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
}


// MARK: - 扩展数组功能
extension Array where Element: Equatable {
    
    mutating func ch_removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func ch_removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.ch_removeObject(object)
        }
    }
}


// MARK: - 扩展CALayer功能
extension CALayer {
    
    //把选中的layer前置顶部
    func ch_bringSublayerToFront(layer: CALayer ) {
        let superlayer = layer.superlayer
        layer.removeFromSuperlayer()
        superlayer?.insertSublayer(layer, at: UInt32(superlayer?.sublayers?.count ?? 0))
    }
    
    
    /// 把选中的layer后置底部
    func ch_sendSublayerToBack(layer: CALayer ) {
        let superlayer = layer.superlayer
        layer.removeFromSuperlayer()
        superlayer?.insertSublayer(layer, at: 0)
    }
    
}

//String类扩展
public extension String {
    
    /**
     计算文字的宽度
     
     - parameter width:
     - parameter font:
     
     - returns:
     */
    public func ch_sizeWithConstrained(font: UIFont) -> CGSize {
        let newStr = NSString(string: self)
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSAttributedStringKey.font: font]
        let stringRect = newStr.boundingRect(with: constraintRect, options: option, attributes: attributes, context: nil)
        
        return stringRect.size
    }
    
}
