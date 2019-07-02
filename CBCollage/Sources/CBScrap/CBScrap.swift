//
//  CBScrap.swift
//  CBCollage
//
//  Created by Charles@CardinalBlue on 2019/6/27.
//  Copyright © 2019 Cardinalblue. All rights reserved.
//

import Foundation

extension CGRect {
    
    init?(fromCBString: String) {
        return nil
    }
    
}

extension String {
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
    
}

public class CBScrap {
    
    private(set) public var scrapType: CBScrapType
    
    private(set) public var createdAt: Date
    
    private(set) public var modifiedAt: Date
    
    private(set) public var zIndex: Int
    
    private(set) public var frame: CGRect
    
    private(set) public var transform: (angle: Double, scale: Double)?
    
    private(set) public var slotNumber: Int?
    
    internal init?(obj: [String: Any]) {
        guard let scrapTypeString = obj["scrap_type"] as? String,
            let scrapType = CBScrapType(rawValue: scrapTypeString),
            let createdAtTimeStamp = obj["created_at"] as? String,
            let createdAt = createdAtTimeStamp.date,
            let modifiedAtTimeStrmp = obj["modified_at"] as? String,
            let modifiedAt = modifiedAtTimeStrmp.date,
            let zIndex = obj["z_index"] as? Int,
            let frameString = obj["frame"] as? String,
            let frame = CGRect(fromCBString: frameString) else { return nil }
        
        self.scrapType = scrapType
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.frame = frame
        self.zIndex = zIndex
    }
    
}
