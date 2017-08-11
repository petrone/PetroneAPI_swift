//
//  PetronePacketChangeTrim.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketChangeTrim : PetronePacket {
    public var flight: PetroneTrimFlight = PetroneTrimFlight()
    public var drive: PetroneTrimDrive = PetroneTrimDrive()
    
    override init() {
        super.init()
        size = 10
    }
    
    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.Control.rawValue)
        sendArray.append(contentsOf: super.int16ToUInt8Array(data: flight.roll))
        sendArray.append(contentsOf: super.int16ToUInt8Array(data: flight.pitch))
        sendArray.append(contentsOf: super.int16ToUInt8Array(data: flight.yaw))
        sendArray.append(contentsOf: super.int16ToUInt8Array(data: flight.throttle))
        sendArray.append(contentsOf: super.int16ToUInt8Array(data: drive.wheel))
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.Control.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append(contentsOf: super.int16ToUInt8Array(data: flight.roll))
        baseArray.append(contentsOf: super.int16ToUInt8Array(data: flight.pitch))
        baseArray.append(contentsOf: super.int16ToUInt8Array(data: flight.yaw))
        baseArray.append(contentsOf: super.int16ToUInt8Array(data: flight.throttle))
        baseArray.append(contentsOf: super.int16ToUInt8Array(data: drive.wheel))
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}
