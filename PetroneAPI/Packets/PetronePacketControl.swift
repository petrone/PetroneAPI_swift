//
//  PetronePacketControl.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 3..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketControl : PetronePacket {
    public var throttle:Int8 = 0
    public var yaw:Int8 = 0
    public var pitch:Int8 = 0
    public var roll:Int8 = 0
    
    override init() {
        super.init()
        size = 4
    }

    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.Control.rawValue)
        sendArray.append(UInt8(bitPattern: roll))
        sendArray.append(UInt8(bitPattern: pitch))
        sendArray.append(UInt8(bitPattern: yaw))
        sendArray.append(UInt8(bitPattern: throttle))
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.Control.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append(UInt8(bitPattern: roll))
        baseArray.append(UInt8(bitPattern: pitch))
        baseArray.append(UInt8(bitPattern: yaw))
        baseArray.append(UInt8(bitPattern: throttle))
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}
