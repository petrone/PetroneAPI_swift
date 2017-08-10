//
//  JoypadProtocol.swift
//  Petrone
//
//  Created by Byrobot on 2017. 8. 9..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation
import UIKit

/*!
 *  @protocol JoypadProtocol
 *
 *  @discussion Delegate for Petrone.
 *
 */
public protocol JoypadProtocol : NSObjectProtocol {
    func control(_ joypad:Joypad, update position:CGPoint)
}
