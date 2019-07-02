//
//  CBCollageAnimaitonModel.swift
//  CBCollage
//
//  Created by Charles@CardinalBlue on 2019/6/27.
//  Copyright © 2019 Cardinalblue. All rights reserved.
//

import Foundation

@objcMembers public class CBCollageAnimaitonModel {
    
    private(set) public var fps: Float
    
    private(set) public var duration: Float
    
    private(set) public var layers: [String: [CBAnimation]]
                                     // targetID
    private(set) public var masks: [String: [CBMask]]
    
    public init?(jsonObj: [String: Any]) {
        guard let info = jsonObj["info"] as? [String: Float],
            let layersData = jsonObj["layers"] as? [[String: Any]] else { return nil }
        
        self.layers = [:]
        self.masks = [:]
        self.fps = info["fps"] ?? 0
        self.duration = info["duration"] ?? 0
        
        //              maskID
        var maskMap: [String: CBMask] = [:]
        if let masksData = jsonObj["masks"] as? [[String: Any]] {
            for maskData in masksData {
                guard let mask = CBMask(obj: maskData) else { return nil }
                maskMap[mask.identifier] = mask
            }
        }
        
        for layerData in layersData {
            guard let target = layerData["target"] as? String,
                let animationsData = layerData["items"] as? [[String: Any]] else {
                    return nil
            }
            if let masksData = layerData["masks"] as? [String] {
                masks[target] = masksData.compactMap({ (maskId) -> CBMask? in
                    if let mask = maskMap[maskId] {
                        return mask
                    }
                    return nil
                })
            }
            var animations: [CBAnimation] = []
            for animationData in animationsData {
                if let animation = CBAnimation(jsonObj: animationData) {
                    animations.append(animation)
                }
            }
            layers[target] = animations
        }
    }
    
}
