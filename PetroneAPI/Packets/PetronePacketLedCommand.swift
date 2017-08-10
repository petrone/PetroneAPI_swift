//
//  PetronePacketLedCommand.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketLedCommand : PetronePacket {
    public var lightMode:PetroneLigthMode? = PetroneLigthMode.ArmHold
    public var lightColor:PetroneColors? = PetroneColors.Red
    public var interval:UInt8 = 0
    public var repeatCount:UInt8 = 0
    public var command:PetroneCommand? = PetroneCommand.None
    public var option:UInt8 = 0
    
    override init() {
        super.init()
        size = 6
    }
    
    override func getBluetoothData() -> Data {
        var sendArray = Data()
        sendArray.append(PetroneDataType.LedEventCommand.rawValue)
        sendArray.append((self.lightMode?.rawValue)!)
        sendArray.append((self.lightColor?.rawValue)!)
        sendArray.append(interval)
        sendArray.append(repeatCount)
        sendArray.append((self.command?.rawValue)!)
        sendArray.append(option)
        
        return sendArray
    }
    
    override func getSerialData() -> Data {
        var baseArray = Data()
        baseArray.append(PetroneDataType.LedEventCommand.rawValue)
        baseArray.append(UInt8(size))
        baseArray.append((self.lightMode?.rawValue)!)
        baseArray.append((self.lightColor?.rawValue)!)
        baseArray.append(interval)
        baseArray.append(repeatCount)
        baseArray.append((self.command?.rawValue)!)
        baseArray.append(option)
        
        var sendArray = Data()
        sendArray.append(0x0a)
        sendArray.append(0x55)
        sendArray.append(baseArray)
        sendArray.append(contentsOf: PetroneCRC.getCRC(data: baseArray, dataLength: size+2))
        
        return sendArray
    }
}
