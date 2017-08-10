//
//  PetronePacketResetHeading.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 7..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

class PetronePacketResetHeading : PetronePacketLedCommand {
    override init() {
        super.init()
        lightMode = PetroneLigthMode.ArmFlickerDouble
        lightColor = PetroneColors.Violet
        interval = 200
        repeatCount = 2
        command = PetroneCommand.ResetHeading
    }
}
