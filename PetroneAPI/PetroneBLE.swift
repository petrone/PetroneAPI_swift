//
//  PetroneBLE.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7.
//  Copyright © 2017년 Byrobot. All rights reserved.
//  Petrone Bluetooth LE control module.
//

import Foundation
import CoreBluetooth

class PetroneBLE : PetroneController, CBCentralManagerDelegate, CBPeripheralDelegate{
    var connected: Bool = false;
    
    var centralManager: CBCentralManager?
    var discoveredPeripheral : CBPeripheral?
    var targetCharacter: String? = nil
    var peripherals = Array<CBPeripheral>()
    var character: CBCharacteristic? = nil
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    public override func onConnect(_ target:String) {
        peripherals.forEach({ (existPeripheral) in
            if( (existPeripheral.identifier.uuidString.compare(target).rawValue) == 0 ) {
                centralManager?.connect(existPeripheral, options: nil)
            }
        })
    }
    
    public override func onDisConnect() {
        if( discoveredPeripheral?.state == CBPeripheralState.connected ) {
            centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
        }
    }
    
    // CBCentralManagerDelegate
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case CBManagerState.poweredOff:
            centralManager?.stopScan()
            connected = false
        case CBManagerState.poweredOn:
            // Scan PETRONE service.
            centralManager?.scanForPeripherals(withServices: [CBUUID.init(string:"C320DF00-7891-11E5-8BCF-FEFF819CDC9F")], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
            
        default: break
            
        }
    }
    
    public override func isScanning() -> Bool {
        return (centralManager?.isScanning)!
    }
    
    public override func onScan() {
        centralManager?.scanForPeripherals(withServices: [CBUUID.init(string:"C320DF00-7891-11E5-8BCF-FEFF819CDC9F")], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
    }
    
    public override func onStopScan() {
        centralManager?.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if( peripheral.name != nil && advertisementData[CBAdvertisementDataLocalNameKey] != nil ) {
            if (peripheral.name?.contains("PETRONE"))! {
                var isExist: Bool = false;
                peripherals.forEach({ (existPeripheral) in
                    if( (existPeripheral.identifier.uuidString.compare(peripheral.identifier.uuidString).rawValue) == 0 ) {
                        isExist = true;
                    }
                })
                
                if !isExist {
                    peripheral.delegate = self
                    peripherals.append(peripheral)
                    Petrone.instance.appearPetrone(name:advertisementData[CBAdvertisementDataLocalNameKey] as! String, uuid:peripheral.identifier.uuidString, rssi:RSSI)
                } else {
                    Petrone.instance.updatePetrone(uuid:peripheral.identifier.uuidString, rssi:RSSI)
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        discoveredPeripheral = peripheral
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        centralManager?.stopScan()
        connected = true
        Petrone.instance.pairing(status:connected)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connected = false
        Petrone.instance.pairing(status:connected)
        
        discoveredPeripheral = nil
        targetCharacter = nil
        
        peripherals.removeAll()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected = false
        Petrone.instance.pairing(status:connected)
        
        discoveredPeripheral = nil
        targetCharacter = nil
        
        peripherals.removeAll()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if( error == nil ) {
            peripheral.services?.forEach { cbservice in
                peripheral.discoverCharacteristics(nil, for:cbservice)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if( error == nil ) {
            service.characteristics?.forEach({ (characteristic) in
                if( UInt8(characteristic.properties.rawValue) == (UInt8(CBCharacteristicProperties.writeWithoutResponse.rawValue)|UInt8(CBCharacteristicProperties.write.rawValue))) {
                    peripheral.discoverDescriptors(for: characteristic)
                    character = characteristic;
                }
                
                peripheral.setNotifyValue(true, for: characteristic)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if( error == nil ) {
            Petrone.instance.updatePetrone(uuid:peripheral.identifier.uuidString, rssi:RSSI)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            if characteristic.value != nil {
                Petrone.instance.recvPacket(data: characteristic.value!)
                
                //let responseData = characteristic.value
                //NSLog("%d %d %d %d %d %d %d %d", responseData![0], responseData![1], responseData![2], responseData![3], responseData![4], responseData![5], responseData![6], responseData![7])
            }
        }
    }
    
    override func sendPacket(_ packet:PetronePacket, isResponsible:Bool = false) {
        if character != nil {
            var response : CBCharacteristicWriteType = CBCharacteristicWriteType.withoutResponse
            if( isResponsible ) {
                response = CBCharacteristicWriteType.withResponse
            }
            
            discoveredPeripheral?.writeValue(packet.getBluetoothData(), for: character!, type: response)
        }
    }
    
    
}
