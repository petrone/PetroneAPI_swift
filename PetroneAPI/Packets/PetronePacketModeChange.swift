//
//  PetronePacketModeChange.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketModeChange : PetronePacketLedCommand {
    public var mode:PetroneMode = PetroneMode.None
    
    override init() {
        super.init()
        lightMode = PetroneLigthMode.ArmFlicker
        interval = 100
        repeatCount = 2
        command = PetroneCommand.ModePetrone
    }
    
    override func getBluetoothData() -> Data {
        if mode.rawValue < PetroneMode.Drive.rawValue {
            lightColor = PetroneColors.Red
        } else {
            lightColor = PetroneColors.Blue
        }
        
        self.option = mode.rawValue
        return super.getBluetoothData()
    }
    
    override func getSerialData() -> Data {
        if mode.rawValue < PetroneMode.Drive.rawValue {
            lightColor = PetroneColors.Red
        } else {
            lightColor = PetroneColors.Blue
        }
        
        self.option = mode.rawValue
        return super.getSerialData()
    }
}

