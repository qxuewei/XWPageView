//
//  UIColor_Extension.swift
//  XWPageViewDemo
//
//  Created by 邱学伟 on 2016/12/9.
//  Copyright © 2016年 邱学伟. All rights reserved.
//  swift3 颜色工具类

import UIKit

extension UIColor {
    //MARK: - 传入R G B A(可选) 返回对应颜色
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1.0) {
        self.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: A)
    }
    
    //MARK: - 传入16进制代码 返回对应颜色
    convenience init?(hex : String, alpha : CGFloat = 1.0) {
        guard hex.characters.count >= 6 else {
            return nil
        }
        // 0xffffff
        var tempHex = hex.uppercased()
        
        //判断开头 0x/#/#
        if tempHex.hasPrefix("0X") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        //分别取出 RGB
        var range : NSRange = NSRange(location : 0, length : 2)
        let R_HEX = (tempHex as NSString).substring(with: range)
        range.location += 2
        let G_HEX = (tempHex as NSString).substring(with: range)
        range.location += 2
        let B_HEX = (tempHex as NSString).substring(with: range)
        
        var R : UInt32 = 0, G : UInt32 = 0, B : UInt32 = 0
        Scanner(string: R_HEX).scanHexInt32(&R)
        Scanner(string: G_HEX).scanHexInt32(&G)
        Scanner(string: B_HEX).scanHexInt32(&B)
        
        self.init(R : CGFloat(R), G : CGFloat(G), B : CGFloat(B))
    }
    
    //MARK: - 随机颜色
    class func getRandomColor() -> UIColor {
        return UIColor(R: CGFloat(arc4random_uniform(256)), G: CGFloat(arc4random_uniform(256)), B: CGFloat(arc4random_uniform(256)))
    }
    
}
