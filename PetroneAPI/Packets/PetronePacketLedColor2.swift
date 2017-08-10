//
//  PetronePacketLedColor2.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 8..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketLedColor2 : PetronePacket {
    public var led1:PetroneLedBase = PetroneLedBase()
    public var led2:PetroneLedBase = PetroneLedBase()
    
    override init() {
        super.init()
        size = 10
    }
    
    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.LedModeColor2.rawValue)
        sendArray.append(led1.mode)
        sendArray.append(led1.red)
        sendArray.append(led1.green)
        sendArray.append(led1.blue)
        sendArray.append(led1.interval)
        sendArray.append(led2.mode)
        sendArray.append(led2.red)
        sendArray.append(led2.green)
        sendArray.append(led2.blue)
        sendArray.append(led2.interval)
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.LedModeColor2.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append(led1.mode)
        baseArray.append(led1.red)
        baseArray.append(led1.green)
        baseArray.append(led1.blue)
        baseArray.append(led1.interval)
        baseArray.append(led2.mode)
        baseArray.append(led2.red)
        baseArray.append(led2.green)
        baseArray.append(led2.blue)
        baseArray.append(led2.interval)
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}
