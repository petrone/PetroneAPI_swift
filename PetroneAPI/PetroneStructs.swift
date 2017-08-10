//
//  PetroneStructs.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 31..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation


public struct PetroneScanData {
    public var name: String?
    public var uuid: String?
    public var rssi: NSNumber = 0
    public var fpv: Bool = false
    
    public init( name: String, uuid: String, rssi: NSNumber ) {
        self.name = name
        self.uuid = uuid
        self.rssi = rssi
    }
}

public struct PetroneStatus {
    public var mode: PetroneMode = PetroneMode.None
    public var modeSystem: PetroneModeSystem = PetroneModeSystem.None
    public var modeFlight: PetroneModeFlight = PetroneModeFlight.None
    public var modeDrive: PetroneModeDrive = PetroneModeDrive.None
    public var sensorOrientation: PetroneSensorOrientation = PetroneSensorOrientation.None
    public var coordinate: PetroneCoordinate = PetroneCoordinate.None
    public var battery: UInt8 = 0
    
    public mutating func parse(_ data:Data) {
        self.mode = PetroneMode(rawValue: data[1])!
        self.modeSystem = PetroneModeSystem(rawValue: data[2])!
        self.modeFlight = PetroneModeFlight(rawValue: data[3])!
        self.modeDrive = PetroneModeDrive(rawValue: data[4])!
        self.sensorOrientation = PetroneSensorOrientation(rawValue: data[5])!
        self.coordinate = PetroneCoordinate(rawValue: data[6])!
        self.battery = data[7]
    }
}

public struct PetroneTrimFlight {
    public var throttle: Int16 = 0
    public var yaw: Int16 = 0
    public var roll: Int16 = 0
    public var pitch: Int16 = 0
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.throttle = Petrone.getInt16(data, start:&index)
        self.yaw = Petrone.getInt16(data, start:&index)
        self.roll = Petrone.getInt16(data, start:&index)
        self.pitch = Petrone.getInt16(data, start:&index)
    }
}

public struct PetroneTrimDrive {
    public var wheel: Int16 = 0
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.wheel = Petrone.getInt16(data, start:&index)
    }
}

public struct PetroneTrim {
    public var flight: PetroneTrimFlight = PetroneTrimFlight()
    public var drive: PetroneTrimDrive = PetroneTrimDrive()
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.flight.throttle =  Petrone.getInt16(data, start:&index)
        self.flight.yaw =  Petrone.getInt16(data, start:&index)
        self.flight.roll =  Petrone.getInt16(data, start:&index)
        self.flight.pitch =  Petrone.getInt16(data, start:&index)
        self.drive.wheel =  Petrone.getInt16(data, start:&index)
    }
}

public struct PetroneAttitude {
    public var roll:Int16 = 0
    public var pitch:Int16 = 0
    public var yaw:Int16 = 0
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.roll = Petrone.getInt16(data, start: &index)
        self.pitch = Petrone.getInt16(data, start: &index)
        self.yaw = Petrone.getInt16(data, start: &index)
    }
}

public struct PetroneGyroBias {
    public var roll:Int16 = 0
    public var pitch:Int16 = 0
    public var yaw:Int16 = 0
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.roll = Petrone.getInt16(data, start: &index)
        self.pitch = Petrone.getInt16(data, start: &index)
        self.yaw = Petrone.getInt16(data, start: &index)
    }
}

public struct PetroneCountFlight {
    public var time:UInt64 = 0
    public var takeOff:UInt16 = 0
    public var landing:UInt16 = 0
    public var accident:UInt16 = 0
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.time = Petrone.getUInt64(data, start: &index)
        self.takeOff = Petrone.getUInt16(data, start: &index)
        self.landing = Petrone.getUInt16(data, start: &index)
        self.accident = Petrone.getUInt16(data, start: &index)
    }
}

public struct PetroneCountDrive {
    public var time:UInt64 = 0
    public var accident:UInt16 = 0
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.time = Petrone.getUInt64(data, start: &index)
        self.accident = Petrone.getUInt16(data, start: &index)
    }
}

public struct PetroneImuRawAndAngle {
    public var  accX:Int16 = 0
    public var  accY:Int16 = 0
    public var  accZ:Int16 = 0
    public var  gyroRoll:Int16 = 0
    public var  gyroPitch:Int16 = 0
    public var  gyroYaw:Int16 = 0
    public var  angleRoll:Int16 = 0
    public var  anglePitch:Int16 = 0
    public var  angleYaw:Int16 = 0
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.accX = Petrone.getInt16(data, start: &index)
        self.accY = Petrone.getInt16(data, start: &index)
        self.accZ = Petrone.getInt16(data, start: &index)
        self.gyroRoll = Petrone.getInt16(data, start: &index)
        self.gyroPitch = Petrone.getInt16(data, start: &index)
        self.gyroYaw = Petrone.getInt16(data, start: &index)
        self.angleRoll = Petrone.getInt16(data, start: &index)
        self.anglePitch = Petrone.getInt16(data, start: &index)
        self.angleYaw = Petrone.getInt16(data, start: &index)
    }
}

public struct PetronePressure {
    public var  d1:Int32 = 0
    public var  d2:Int32 = 0
    public var  temperature:Int32 = 0
    public var  pressure:Int32 = 0
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.d1 = Petrone.getInt32(data, start: &index)
        self.d2 = Petrone.getInt32(data, start: &index)
        self.temperature = Petrone.getInt32(data, start: &index)
        self.pressure = Petrone.getInt32(data, start: &index)
    }
}

public struct PetroneImageFlow {
    public var  fVelocitySumX:Int32 = 0
    public var  fVelocitySumY:Int32 = 0
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.fVelocitySumX = Petrone.getInt32(data, start: &index)
        self.fVelocitySumY = Petrone.getInt32(data, start: &index)
    }
}

public struct PetroneBattery {
    public var percent:UInt8 = 0
    public mutating func parse(_ data:Data) {
        self.percent = data[1]
    }
}

public struct PetroneMotorBase {
    public var  forward:Int16 = 0
    public var  reverse:Int16 = 0
    public mutating func parse(_ data:Data, start:inout Int) {
        self.forward = Petrone.getInt16(data, start: &start)
        self.reverse = Petrone.getInt16(data, start: &start)
    }
}

public struct PetroneMotor {
    public var motor:[PetroneMotorBase] = [PetroneMotorBase(), PetroneMotorBase(), PetroneMotorBase(), PetroneMotorBase()]
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        motor[0].parse(data, start: &index)
        motor[1].parse(data, start: &index)
        motor[2].parse(data, start: &index)
        motor[3].parse(data, start: &index)
    }
}

public struct PetroneTemperature {
    public var  temperature:Int32 = 0
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.temperature = Petrone.getInt32(data, start: &index)
    }
}

public struct PetroneRange {
    public var  left:UInt16 = 0
    public var  front:UInt16 = 0
    public var  right:UInt16 = 0
    public var  rear:UInt16 = 0
    public var  top:UInt16 = 0
    public var  bottom:UInt16 = 0
    
    public mutating func parse(_ data:Data) {
        var index:Int = 1
        self.left = Petrone.getUInt16(data, start: &index)
        self.front = Petrone.getUInt16(data, start: &index)
        self.right = Petrone.getUInt16(data, start: &index)
        self.rear = Petrone.getUInt16(data, start: &index)
        self.top = Petrone.getUInt16(data, start: &index)
        self.bottom = Petrone.getUInt16(data, start: &index)
    }
}

public struct PetroneLedModeBase {
    public var mode:UInt8 = PetroneLigthMode.None.rawValue
    public var color:UInt8 = 0
    public var interval:UInt8 = 0
}

public struct PetroneLedBase {
    public var mode:UInt8 = PetroneLigthMode.None.rawValue
    public var red:UInt8 = 0
    public var green:UInt8 = 0
    public var blue:UInt8 = 0
    public var interval:UInt8 = 0
}

