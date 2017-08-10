//
//  PetronePacketStatus.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 26..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketStatus : PetronePacketRequest {
    override init() {
        super.init()
        dataType = PetroneDataType.State.rawValue
    }
}
