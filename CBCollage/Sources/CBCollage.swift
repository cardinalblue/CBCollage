//
//  CBCollage.swift
//  CBCollage
//
//  Created by Charles@CardinalBlue on 2019/6/24.
//  Copyright © 2019 Cardinalblue. All rights reserved.
//

import Foundation

public class CBCollage {
    
    var version: String
    
    var device: CBCollageDevice?

    var caption: String?
    
    private(set) var scraps: [CBScrap]
    
    private(set) public var animationModel : CBCollageAnimaitonModel
    
    public init?(obj: [String: Any]) {
        guard let version = obj["version"] as? String,
            let scrapsData = obj["scraps"] as? [[String: Any]],
            let animationData = obj["animation"] as? [String: Any],
            let animationModel = CBCollageAnimaitonModel(jsonObj: animationData) else { return nil }
        self.version = version
        self.caption = obj["caption"] as? String
        self.scraps = []
        self.animationModel = animationModel
    }
    
}
