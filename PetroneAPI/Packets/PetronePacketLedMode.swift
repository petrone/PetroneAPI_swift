//
//  PetronePacketLedMode.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 8..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketLedMode : PetronePacket {
    public var led:PetroneLedModeBase = PetroneLedModeBase()
    
    override init() {
        super.init()
        size = 3
    }
    
    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.LedMode.rawValue)
        sendArray.append(led.mode)
        sendArray.append(led.color)
        sendArray.append(led.interval)
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.LedMode.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append(led.mode)
        baseArray.append(led.color)
        baseArray.append(led.interval)
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}
