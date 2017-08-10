//
//  PetronePacketRequest.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketRequest : PetronePacket {
    public var dataType:UInt8 = 0
    
    override init() {
        super.init()
        size = 1
    }
    
    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.Request.rawValue)
        sendArray.append(PetroneDataType.State.rawValue)
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.Request.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append(dataType)
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}
