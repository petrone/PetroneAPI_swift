//
//  PetronePacketSquare.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 9..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketSquare : PetronePacketLedCommand {
    override init() {
        super.init()
        lightMode = PetroneLigthMode.ArmHold
    }
    
    override func getBluetoothData() -> Data {
        if (Petrone.instance.status?.mode.rawValue)! < PetroneMode.Drive.rawValue {
            lightColor = PetroneColors.Red
            command = PetroneCommand.FlightEvent
            option = PetroneFlightEvent.Square.rawValue
        } else {
            lightColor = PetroneColors.Blue
            command = PetroneCommand.DriveEvent
            option = PetroneDriveEvent.Square.rawValue
        }
        return super.getBluetoothData()
    }
    
    override func getSerialData() -> Data {
        lightColor = PetroneColors.Red
        if (Petrone.instance.status?.mode.rawValue)! < PetroneMode.Drive.rawValue {
            command = PetroneCommand.FlightEvent
            option = PetroneFlightEvent.Square.rawValue
        } else {
            lightColor = PetroneColors.Blue
            command = PetroneCommand.DriveEvent
            option = PetroneDriveEvent.Square.rawValue
        }
        return super.getSerialData()
    }
}
