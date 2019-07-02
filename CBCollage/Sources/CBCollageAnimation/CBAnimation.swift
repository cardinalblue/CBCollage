//
//  CBAnimation.swift
//  CBCollage
//
//  Created by Charles@CardinalBlue on 2019/6/28.
//  Copyright © 2019 Cardinalblue. All rights reserved.
//

import Foundation
import AVFoundation

@objcMembers public class CBAnimation {
    
    public private(set) var property: String
    public private(set) var fromValue: Any
    public private(set) var toValue: Any
    public private(set) var duration: CFTimeInterval
    public private(set) var beginTime: Double
    
    
    public private(set) var timingFunctionControlPoints: (in: CGPoint, out: CGPoint)?
    public private(set) var timingFunctionName: String?
    
    internal init?(jsonObj: [String: Any]) {
        guard let property = jsonObj["property"] as? String,
            let fromValue = jsonObj["fromValue"],
            let toValue = jsonObj["toValue"],
            let duration = jsonObj["duration"] as? CFTimeInterval,
            let beginTime = jsonObj["beginTime"] as? Double,
            let timingFunction = jsonObj["timingFunction"] as? [String: Any] else { return nil }
        
        if let timingFunctionName = timingFunction["name"] as? String {
            self.timingFunctionName = timingFunctionName
        }
        
        if let inTagent = timingFunction["in"] as? [String: CGFloat],
            let outTagent = timingFunction["out"] as? [String: CGFloat],
            let inX = inTagent["x"], let inY = inTagent["y"],
            let outX = outTagent["x"], let outY = outTagent["y"] {
            self.timingFunctionControlPoints = (in: CGPoint(x: inX, y: inY),
                                                out: CGPoint(x: outX, y: outY))
        }
        
        self.property = property
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.beginTime = beginTime
    }
}

public extension CBAnimation {
    
    func caAnimaiton(fps: Float = 30, forExport: Bool) -> CAAnimation {
        let animationGroup = CAAnimationGroup()
        animationGroup.beginTime = (forExport ? AVCoreAnimationBeginTimeAtZero : 0)
        animationGroup.duration = beginTime + duration
        animationGroup.repeatCount = HUGE

        let animation = CABasicAnimation(keyPath: property)
        animation.beginTime = beginTime
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.speed = 30.0 / fps
        animation.isRemovedOnCompletion = !forExport
        if let timingFunctionName = timingFunctionName {
            let caFunctionName = CAMediaTimingFunctionName(rawValue: timingFunctionName) 
            animation.timingFunction = CAMediaTimingFunction(name: caFunctionName)
        } else if let tfcps = timingFunctionControlPoints {
            animation.timingFunction = CAMediaTimingFunction(controlPoints: Float(tfcps.in.x),
                                                             Float(tfcps.in.y),
                                                             Float(tfcps.out.x),
                                                             Float(tfcps.out.y))
        }
        
        animationGroup.animations = [animation]
        return animationGroup
    }
    
}

