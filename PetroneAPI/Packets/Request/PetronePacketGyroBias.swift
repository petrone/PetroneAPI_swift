//
//  PetronePacketGyroBias.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketGyroBias : PetronePacketRequest {
    override init() {
        super.init()
        dataType = PetroneDataType.GyroBias.rawValue
    }
}
