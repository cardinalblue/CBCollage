//
//  CBMask.swift
//  CBCollage
//
//  Created by Charles@CardinalBlue on 2019/7/1.
//  Copyright © 2019 Cardinalblue. All rights reserved.
//

@objcMembers public class CBMask {
    
    private(set) public var identifier: String
    
    private(set) public var inverted: Bool
    
    private(set) public var isClose: Bool
    
    private(set) public var opacity: CGFloat
    
    private(set) public var vertices: [CGPoint]
    
    init?(obj: [String: Any]) {
        
        guard let identifier = obj["id"] as? String,
            let inverted = obj["inverted"] as? Bool,
            let isClose = obj["isClose"] as? Bool,
            let opacity = obj["opacity"] as? CGFloat,
            let verticesData = obj["vertices"] as? [[String: CGFloat]] else { return nil }
        
        self.identifier = identifier
        self.inverted = inverted
        self.isClose = isClose
        self.opacity = opacity
        self.vertices = verticesData.compactMap { vertexData -> CGPoint? in
            guard let x = vertexData["x"], let y = vertexData["y"] else {
                return nil
            }
            return CGPoint(x: x, y: y)
        }
    }
    

}
