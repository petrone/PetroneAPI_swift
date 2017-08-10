//
//  PetroneController.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 21..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

public class PetroneController : NSObject {
    public func sendPacket(_ packet:PetronePacket, isResponsible:Bool = false) {}
    public func isScanning() -> Bool            { return true }
    public func onScan()                        {}
    public func onStopScan()                    {}
    public func onConnect(_ target:String)      {}
    public func onDisConnect()                  {}
}
