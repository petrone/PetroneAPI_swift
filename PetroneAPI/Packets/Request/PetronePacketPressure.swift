//
//  PetronePacketPressure.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 8..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketPressure : PetronePacketRequest {
    override init() {
        super.init()
        dataType = PetroneDataType.Pressure.rawValue
    }
}
