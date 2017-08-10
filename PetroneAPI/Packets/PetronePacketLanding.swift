//
//  PetronePacketLanding.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 3..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketLanding : PetronePacketLedCommand {
    override init() {
        super.init()
        lightColor = PetroneColors.Red
        command = PetroneCommand.FlightEvent
        option = PetroneFlightEvent.Landing.rawValue
    }
}


