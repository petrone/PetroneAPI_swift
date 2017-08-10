//
//  PetronePacketCoordinatesChange.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketCoordinatesChange : PetronePacketLedCommand {
    public var coordinates:PetroneCoordinate = PetroneCoordinate.None
    
    override init() {
        super.init()
        lightMode = PetroneLigthMode.ArmFlicker
        lightColor = PetroneColors.Green
        interval = 100
        repeatCount = 3
        command = PetroneCommand.ModePetrone
    }
    
    override func getBluetoothData() -> Data {
        option = coordinates.rawValue
        return super.getBluetoothData()
    }
    
    override func getSerialData() -> Data {
        option = coordinates.rawValue
        return super.getSerialData()
    }
}

