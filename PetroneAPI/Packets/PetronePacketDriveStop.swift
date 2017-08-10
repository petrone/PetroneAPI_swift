//
//  PetronePacketDriveStop.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 3..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketDriveStop : PetronePacketLedCommand {
    override init() {
        super.init()
        lightColor = PetroneColors.Red
        command = PetroneCommand.DriveEvent
        option = PetroneDriveEvent.Stop.rawValue
    }
}


