//
//  Petrone.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 20..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation


public class Petrone {
    public static let instance:Petrone = Petrone()
    weak open var delegate: PetroneProtocol?
    
    public var petroneList : [String:PetroneScanData] = [:]
    
    private var prevControlTime: Int64 = 0
    private var controller:PetroneController?
    private var petroneBLE: PetroneBLE?
    
    private static let sendInterval:TimeInterval = 1.0 / 20 // send packet max 20fps
    
    private var timer: Timer? = nil
    private var packetList : Array<PetronePacket> = Array<PetronePacket>()
    
    private struct PetroneControlValue {
        public var throttle: Int8 = 0
        public var throttleTimer: Int = 0
        public var yaw: Int8 = 0
        public var yawTimer: Int = 0
        public var roll: Int8 = 0
        public var rollTimer: Int = 0
        public var pitch: Int8 = 0
        public var pitchTimer: Int = 0
    }
    
    private var controlValue : PetroneControlValue = PetroneControlValue()
    
    public var status:PetroneStatus?                = nil
    public var trim:PetroneTrim?                    = nil
    public var attitude:PetroneAttitude?            = nil
    public var gyro:PetroneGyroBias?                = nil
    public var countOfFlight:PetroneCountFlight?    = nil
    public var countOfDrive:PetroneCountDrive?      = nil
    public var imuRawAndAngle:PetroneImuRawAndAngle? = nil
    public var pressure:PetronePressure?            = nil
    public var imageFlow:PetroneImageFlow?          = nil
    public var motor:PetroneMotor?                  = nil
    public var range:PetroneRange?                  = nil
    
    public var isPairing: Bool = false
    
    func pairing(status:Bool) {
        isPairing = status;
        
        if isPairing {
            controller = petroneBLE
            
            if timer == nil {
                prevControlTime = getCurrentMillis()
                timer = Timer.scheduledTimer(timeInterval: Petrone.sendInterval, target: self, selector:(#selector(onSend)), userInfo: nil, repeats: true)
            }
            
            self.delegate?.petrone(controller!, didConnect: (petroneBLE?.discoveredPeripheral?.name)!)
        } else {
            controller = nil
            
            if timer != nil {
                timer?.invalidate()
            }
        }
    }
    
    public func isReadyForStart() -> Bool {
        if (status?.mode.rawValue)! < PetroneMode.Drive.rawValue {
            if( status?.modeFlight == PetroneModeFlight.Ready ) {
                return true
            } else {
                return false
            }
        } else {
            if( status?.modeDrive == PetroneModeDrive.Ready ) {
                return true
            } else {
                return false
            }
        }
    }
    
    public func onScan() {
        if petroneBLE == nil {
            petroneBLE = PetroneBLE()
        } else if !(petroneBLE?.isScanning())! {
            petroneBLE?.onScan()
        }
    }
    
    public func onStopScan() {
        if petroneBLE != nil {
            petroneBLE?.onStopScan()
            petroneList.removeAll()
        }
    }
    
    public func onConnect(_ target:String) {
        petroneBLE?.onConnect(target)
    }
    
    public func onDisconnect() {
        petroneBLE?.onDisConnect()
    }
    
    public func takeOff() {
        let packet:PetronePacketTakeOff = PetronePacketTakeOff()
        self.sendPacket(packet)
    }
    
    public func landing() {
        let packet:PetronePacketLanding = PetronePacketLanding()
        self.sendPacket(packet)
    }
    
    public func emergencyStop() {
        let packet:PetronePacketEmergencyStop = PetronePacketEmergencyStop()
        self.sendPacket(packet)
    }
    
    public func onSqure() {
        let packet:PetronePacketSquare = PetronePacketSquare()
        self.sendPacket(packet)
    }
    
    public func onRotate180() {
        let packet:PetronePacketRotate180 = PetronePacketRotate180()
        self.sendPacket(packet)
    }
    
    public func onRotate90Left() {
        let packet:PetronePacketRotate90 = PetronePacketRotate90()
        self.sendPacket(packet)
    }
    
    public func onRotate90Right() {
        let packet:PetronePacketRotate90 = PetronePacketRotate90()
        self.sendPacket(packet)
    }
    
    public func throttle(value:Int8, millisecond:Int = 100) {
        controlValue.throttle = value
        controlValue.throttleTimer = millisecond
    }
    
    public func yaw(value:Int8, millisecond:Int = 100) {
        controlValue.yaw = value
        controlValue.yawTimer = millisecond
    }
    
    public func roll(value:Int8, millisecond:Int = 100) {
        controlValue.roll = value
        controlValue.rollTimer = millisecond
    }
    
    public func pitch(value:Int8, millisecond:Int = 100) {
        controlValue.pitch = value
        controlValue.pitchTimer = millisecond
    }
    
    public func control(forward:Int8, leftRight:Int8, millisecond:Int = 100) {
        controlValue.throttle = forward
        controlValue.throttleTimer = millisecond
        controlValue.yaw = 0
        controlValue.yawTimer = 0
        controlValue.roll = leftRight
        controlValue.rollTimer = millisecond
        controlValue.pitch = 0
        controlValue.pitchTimer = 0
    }
    
    
    public func control(throttle:Int8, yaw:Int8, roll:Int8, pitch:Int8, millisecond:Int = 100) {
        controlValue.throttle = throttle
        controlValue.throttleTimer = millisecond
        controlValue.yaw = yaw
        controlValue.yawTimer = millisecond
        controlValue.roll = roll
        controlValue.rollTimer = millisecond
        controlValue.pitch = pitch
        controlValue.pitchTimer = millisecond
    }
    
    public func changeMode(mode:PetroneMode) {
        let packet:PetronePacketModeChange = PetronePacketModeChange()
        packet.mode = mode
        self.sendPacket(packet)
    }
    
    public func changeTrim(throttle:Int16, yaw:Int16, roll:Int16, pitch:Int16, wheel:Int16) {
        let packet:PetronePacketChangeTrim = PetronePacketChangeTrim()
        packet.flight.throttle = throttle
        packet.flight.yaw = yaw
        packet.flight.roll = roll
        packet.flight.pitch = pitch
        packet.drive.wheel = wheel
        
        self.sendPacket(packet)
    }
    
    public func changeTrim(throttle:Int16, yaw:Int16, roll:Int16, pitch:Int16) {
        let packet:PetronePacketChangeTrim = PetronePacketChangeTrim()
        packet.flight.throttle = throttle
        packet.flight.yaw = yaw
        packet.flight.roll = roll
        packet.flight.pitch = pitch
        packet.drive.wheel = (self.trim?.drive.wheel)!
        
        self.sendPacket(packet)
    }
    
    public func changeTrim(wheel:Int16) {
        let packet:PetronePacketChangeTrim = PetronePacketChangeTrim()
        packet.drive.wheel = wheel
        
        packet.flight.throttle = (self.trim?.flight.throttle)!
        packet.flight.yaw = (self.trim?.flight.yaw)!
        packet.flight.roll = (self.trim?.flight.roll)!
        packet.flight.pitch = (self.trim?.flight.pitch)!
        
        self.sendPacket(packet)
    }
    
    public func color(red:UInt8, green:UInt8, blue:UInt8) {
        let packet:PetronePacketLedColor2 = PetronePacketLedColor2()
        packet.led1.mode = PetroneLigthMode.EyeHold.rawValue
        packet.led1.red = red
        packet.led1.green = green
        packet.led1.blue = blue
        packet.led1.interval = 255
        packet.led2.mode = PetroneLigthMode.ArmHold.rawValue
        packet.led2.red = red
        packet.led2.green = green
        packet.led2.blue = blue
        packet.led2.interval = 255
        
        self.sendPacket(packet)
    }
    
    public func color(eyeRed:UInt8, eyeGreen:UInt8, eyeBlue:UInt8, armRed:UInt8, armGreen:UInt8, armBlue:UInt8) {
        let packet:PetronePacketLedColor2 = PetronePacketLedColor2()
        packet.led1.mode = PetroneLigthMode.EyeHold.rawValue
        packet.led1.red = eyeRed
        packet.led1.green = eyeGreen
        packet.led1.blue = eyeBlue
        packet.led1.interval = 255
        packet.led2.mode = PetroneLigthMode.ArmHold.rawValue
        packet.led2.red = armRed
        packet.led2.green = armGreen
        packet.led2.blue = armBlue
        packet.led2.interval = 255
        
        self.sendPacket(packet)
    }
    
    public func colorForEye(red:UInt8, green:UInt8, blue:UInt8) {
        let packet:PetronePacketLedColor = PetronePacketLedColor()
        packet.led.mode = PetroneLigthMode.EyeHold.rawValue
        packet.led.red = red
        packet.led.green = green
        packet.led.blue = blue
        packet.led.interval = 255
        
        self.sendPacket(packet)
    }
    
    public func colorForArm(red:UInt8, green:UInt8, blue:UInt8) {
        let packet:PetronePacketLedColor = PetronePacketLedColor()
        packet.led.mode = PetroneLigthMode.ArmHold.rawValue
        packet.led.red = red
        packet.led.green = green
        packet.led.blue = blue
        packet.led.interval = 255
        
        self.sendPacket(packet)
    }
    
    // Flight mode only
    public func turn() {
        
    }
    
    // Drive mode only
    public func turnLeft() {
        
    }
    
    // Drive mode only
    public func turnRight() {
        
    }
    
    public func requestState() {
        let packet:PetronePacketStatus = PetronePacketStatus()
        self.sendPacket(packet)
    }
    
    public func requestAttitude() {
        let packet:PetronePacketAttitude = PetronePacketAttitude()
        self.sendPacket(packet)
    }
    
    public func requestGyroBias() {
        let packet:PetronePacketGyroBias = PetronePacketGyroBias()
        self.sendPacket(packet)
    }
    
    public func requestTrimAll() {
        let packet:PetronePacketRequestTrimAll = PetronePacketRequestTrimAll()
        self.sendPacket(packet)
    }
    
    public func requestTrimFlight() {
        let packet:PetronePacketRequestTrimFlight = PetronePacketRequestTrimFlight()
        self.sendPacket(packet)
    }
    
    public func requestTrimDrive() {
        let packet:PetronePacketRequestTrimDrive = PetronePacketRequestTrimDrive()
        self.sendPacket(packet)
    }
    
    public func requestCountFlight() {
        let packet:PetronePacketRequestTrimDrive = PetronePacketRequestTrimDrive()
        self.sendPacket(packet)
    }
    
    public func requestCountDrive() {
        let packet:PetronePacketRequestTrimDrive = PetronePacketRequestTrimDrive()
        self.sendPacket(packet)
    }
    
    public func requestImuRawAndAngle() {
        let packet:PetronePacketImuRawAndAngle = PetronePacketImuRawAndAngle()
        self.sendPacket(packet)
    }
    
    public func requestPressure() {
        let packet:PetronePacketPressure = PetronePacketPressure()
        self.sendPacket(packet)
    }
    
    public func requestImageFlow() {
        let packet:PetronePacketImageFlow = PetronePacketImageFlow()
        self.sendPacket(packet)
    }
    
    public func requestBattery() {
        let packet:PetronePacketBattery = PetronePacketBattery()
        self.sendPacket(packet)
    }
    
    public func requestMotor() {
        let packet:PetronePacketMotor = PetronePacketMotor()
        self.sendPacket(packet)
    }
    
    public func requestTemperature() {
        let packet:PetronePacketTemperature = PetronePacketTemperature()
        self.sendPacket(packet)
    }
    
    public func requestRange() {
        let packet:PetronePacketRange = PetronePacketRange()
        self.sendPacket(packet)
    }
    
    public func appearPetrone(name:String, uuid:String, rssi RSSI: NSNumber, isFPV:Bool = false) {
        if petroneList[uuid] != nil {
            var prev = petroneList[uuid]
            prev?.rssi = RSSI
            petroneList.updateValue(prev!, forKey: uuid)
        } else {
            let data: PetroneScanData = PetroneScanData(name:name, uuid:uuid, rssi:RSSI)
            petroneList[uuid] = data
        }
    }
    
    public func updatePetrone(uuid:String, rssi RSSI: NSNumber, isFPV:Bool = false) {
        if petroneList[uuid] != nil {
            var prev = petroneList[uuid]
            prev?.rssi = RSSI
            petroneList.updateValue(prev!, forKey: uuid)
        }
    }
    
    public func sendPacket(_ packet:PetronePacket) {
        packetList.insert(packet, at: packetList.count)
    }
    
    public func recvPacket(data:Data) {
        switch ( data[0] as UInt8 ){
        case PetroneDataType.Ack.rawValue:
            self.delegate?.petrone(controller!, recvFromPetrone: data[5])
        case PetroneDataType.State.rawValue:
            if self.status == nil {
                self.status = PetroneStatus()
            }
            
            self.status?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.status!)
        case PetroneDataType.Attitude.rawValue:
            if self.attitude == nil {
                self.attitude = PetroneAttitude()
            }
            
            self.attitude?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.attitude!)
        case PetroneDataType.GyroBias.rawValue:
            if self.gyro == nil {
                self.gyro = PetroneGyroBias()
            }
            
            self.gyro?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.gyro!)
        case PetroneDataType.TrimAll.rawValue:
            if self.trim == nil {
                self.trim = PetroneTrim()
            }
            
            self.trim?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.trim!)
        case PetroneDataType.TrimFlight.rawValue:
            if self.trim == nil {
                self.trim = PetroneTrim()
            }
            
            self.trim?.flight.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: (self.trim?.flight)!)
        case PetroneDataType.TrimDrive.rawValue:
            if self.trim == nil {
                self.trim = PetroneTrim()
            }
            
            self.trim?.drive.parse(data)
            self.delegate?.petrone(controller!, recvFromPetrone: (self.trim?.drive)!)
        case PetroneDataType.CountFlight.rawValue:
            if self.countOfFlight == nil {
                self.countOfFlight = PetroneCountFlight()
            }
            
            self.countOfFlight?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.countOfFlight!)
        case PetroneDataType.CountDrive.rawValue:
            if self.countOfDrive == nil {
                self.countOfDrive = PetroneCountDrive()
            }
            
            self.countOfDrive?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.countOfDrive!)
        case PetroneDataType.ImuRawAndAngle.rawValue:
            if self.imuRawAndAngle == nil {
                self.imuRawAndAngle = PetroneImuRawAndAngle()
            }
            
            self.imuRawAndAngle?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.imuRawAndAngle!)
        case PetroneDataType.Pressure.rawValue:
            if self.pressure == nil {
                self.pressure = PetronePressure()
            }
            
            self.pressure?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.pressure!)
        case PetroneDataType.ImageFlow.rawValue:
            if self.imageFlow == nil {
                self.imageFlow = PetroneImageFlow()
            }
            
            self.imageFlow?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.imageFlow!)
        case PetroneDataType.Motor.rawValue:
            if self.motor == nil {
                self.motor = PetroneMotor()
            }
            
            self.motor?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.motor!)
        case PetroneDataType.Range.rawValue:
            if self.range == nil {
                self.range = PetroneRange()
            }
            
            self.range?.parse(data);
            self.delegate?.petrone(controller!, recvFromPetrone: self.range!)
        default:
            NSLog("Uknown Packet recv.")
        }
    }
    
    @objc private func onSend() {
        if petroneBLE != nil && petroneBLE!.connected {
            if status != nil {
                if (status?.modeFlight.rawValue)! > PetroneModeFlight.Ready.rawValue || (status?.mode == PetroneMode.Drive) {
                    let current = getCurrentMillis()
                    if( current - prevControlTime > 99 ) { // send control packet 10 frame per sec.
                        if self.controlValue.throttleTimer > 0 || self.controlValue.yawTimer > 0 || self.controlValue.pitchTimer > 0 || self.controlValue.rollTimer > 0 {
                            let packet =  PetronePacketControl()
                            
                            packet.throttle = self.controlValue.throttle
                            packet.yaw = self.controlValue.yaw
                            packet.pitch = self.controlValue.pitch
                            packet.roll = self.controlValue.roll
                            
                            self.consumeControlTime(UInt16( current - prevControlTime ))
                            self.sendPacket(packet)
                        }
                        
                        prevControlTime = current
                    }
                }
            }
            
            if packetList.count > 0 {
                let packet:PetronePacket = packetList.removeFirst()
                petroneBLE?.sendPacket(packet)
            }
        }
    }
    
    private func consumeControlTime( _ diffTime:UInt16 ) {
        self.controlValue.throttleTimer -= Int(diffTime)
        self.controlValue.yawTimer -= Int(diffTime)
        self.controlValue.pitchTimer -= Int(diffTime)
        self.controlValue.rollTimer -= Int(diffTime)
        
        if self.controlValue.throttleTimer <= 0 {
            self.controlValue.throttle = 0
            self.controlValue.throttleTimer = 0
        }
        if self.controlValue.yawTimer <= 0 {
            self.controlValue.yaw = 0
            self.controlValue.yawTimer = 0
        }
        if self.controlValue.pitchTimer <= 0 {
            self.controlValue.roll = 0
            self.controlValue.pitchTimer = 0
        }
        if self.controlValue.rollTimer <= 0 {
            self.controlValue.roll = 0
            self.controlValue.rollTimer = 0
        }
    }
    
    public class func getUInt64(_ data:Data, start:inout Int) -> UInt64 {
        var ret:UInt64 = 0;
        ret = UInt64(data[start+7]);
        ret = ret << 8 + UInt64(data[start+6]);
        ret = ret << 8 + UInt64(data[start+5]);
        ret = ret << 8 + UInt64(data[start+4]);
        ret = ret << 8 + UInt64(data[start+3]);
        ret = ret << 8 + UInt64(data[start+2]);
        ret = ret << 8 + UInt64(data[start+1]);
        ret = ret << 8 + UInt64(data[start]);
        
        start += 8
        
        return ret
    }
    
    public class func getInt32(_ data:Data, start:inout Int) -> Int32 {
        var ret:Int32 = Int32(data[start+3])
        ret = ret << 8 + Int32(data[start+2]);
        ret = ret << 8 + Int32(data[start+1]);
        ret = ret << 8 + Int32(data[start])
        start += 4
        return ret
    }
    
    public class func getUInt16(_ data:Data, start:inout Int) -> UInt16 {
        var ret:UInt16 = UInt16(data[start+1])
        ret = ret << 8 + UInt16(data[start])
        start += 2
        return ret
    }
    
    public class func getInt16(_ data:Data, start:inout Int) -> Int16 {
        var ret:Int16 = Int16(data[start+1])
        ret = ret << 8 + Int16(data[start])
        start += 2
        return ret
    }
    
    public class func setInt16(_ data:inout Data, value:Int16) {
        data.append(contentsOf: [UInt8(value & 0x00ff), UInt8(value >> 8)])
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

public protocol PetroneNetworkDelegate : NSObjectProtocol {
    func onScanned()
    func onConnected()
    func onRecv(data:Data)
}
