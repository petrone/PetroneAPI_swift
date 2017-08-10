//
//  PetronePacketLedColor.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 8..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketLedColor : PetronePacket {
    public var led:PetroneLedBase = PetroneLedBase()
    
    override init() {
        super.init()
        size = 5
    }
    
    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.LedModeColor.rawValue)
        sendArray.append(led.mode)
        sendArray.append(led.red)
        sendArray.append(led.green)
        sendArray.append(led.blue)
        sendArray.append(led.interval)
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.LedModeColor.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append(led.mode)
        baseArray.append(led.red)
        baseArray.append(led.green)
        baseArray.append(led.blue)
        baseArray.append(led.interval)
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}
