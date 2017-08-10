//
//  PetronePacketAttitude.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketAttitude : PetronePacketRequest {
    override init() {
        super.init()
        dataType = PetroneDataType.Attitude.rawValue
    }
}
