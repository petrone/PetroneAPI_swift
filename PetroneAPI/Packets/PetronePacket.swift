//
//  PetronePacket.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 25..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

public class PetronePacket : NSObject {
    var size : Int = 0
    public override init() {
        super.init()
    }
    
    public func getBluetoothData() -> Data {
        return Data()
    }
    
    public func getSerialData() -> Data {
        return Data()
    }
    
    public func getUInt8Array(data:Int16) -> [UInt8] {
        return [UInt8(data & 0xff), UInt8(data >> 8)]
    }
    
    public func getUInt8Array(data:UInt16) -> [UInt8] {
        return [UInt8(data & 0x00ff), UInt8(data >> 8)]
    }
    
    public class func getUInt8Array(data:Int32) -> [UInt8] {
        return [UInt8(data & 0xff), UInt8((data >> 8) & 0xff), UInt8((data >> 16) & 0xff), UInt8((data >> 24) * 0xff)]
    }
    
    public class func getUInt8Array(data:UInt32) -> [UInt8] {
        return [UInt8(data & 0xff), UInt8((data >> 8) & 0xff), UInt8((data >> 16) & 0xff), UInt8((data >> 24) * 0xff)]
    }
    
    public func getUInt8Array(data:Int64) -> [UInt8] {
        return [UInt8(data & 0xff), UInt8((data >> 8) & 0xff), UInt8((data >> 16) & 0xff), UInt8((data >> 24) * 0xff),
               UInt8((data >> 32) & 0xff), UInt8((data >> 40) & 0xff), UInt8((data >> 48) * 0xff), UInt8((data >> 52) * 0xff)]
    }
    
    public func getUInt8Array(data:UInt64) -> [UInt8] {
        return [UInt8(data & 0xff), UInt8((data >> 8) & 0xff), UInt8((data >> 16) & 0xff), UInt8((data >> 24) * 0xff),
                UInt8((data >> 32) & 0xff), UInt8((data >> 40) & 0xff), UInt8((data >> 48) * 0xff), UInt8((data >> 52) * 0xff)]
    }
}
