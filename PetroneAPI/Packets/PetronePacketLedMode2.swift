//
//  PetronePacketLedMode2.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 8..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketLedMode2 : PetronePacket {
    public var led1:PetroneLedModeBase = PetroneLedModeBase()
    public var led2:PetroneLedModeBase = PetroneLedModeBase()
    
    override init() {
        super.init()
        size = 6
    }
    
    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.LedMode.rawValue)
        sendArray.append(led1.mode)
        sendArray.append(led1.color)
        sendArray.append(led1.interval)
        sendArray.append(led2.mode)
        sendArray.append(led2.color)
        sendArray.append(led2.interval)
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.LedMode.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append(led1.mode)
        baseArray.append(led1.color)
        baseArray.append(led1.interval)
        baseArray.append(led2.mode)
        baseArray.append(led2.color)
        baseArray.append(led2.interval)
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}

