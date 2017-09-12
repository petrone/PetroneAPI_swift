//
//  PetroneWIFI.swift
//  PetroneAPI
//
//  Created by Byrobot on 2017. 9. 11..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class PetroneWIFI : PetroneController, StreamDelegate {
    private var inputStream:InputStream!
    private var outputStream:OutputStream!
    private var timer: Timer? = nil
    
    override init() {
        super.init()
    }
    
    public override func sendPacket(_ packet:PetronePacket, isResponsible:Bool = false) {
        if !(self.connected) {
            return
        } else {
            if self.outputStream != nil {
                packet.getSerialData().withUnsafeBytes({ (bytes:UnsafePointer<UInt8>) -> Void in
                    self.outputStream.write(bytes, maxLength: packet.size + 6)
                })
                
            }
        }
    }
    public override func isScanning() -> Bool            {
        if timer != nil {
            return true
        }
        return false
    }
    public override func onScan()                        {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval:  3.0, target: self, selector:(#selector(onCheckFPV)), userInfo: nil, repeats: true)
    }
    public override func onStopScan()                    {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    public override func onConnect(_ target:String)      {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        var readStream:Unmanaged<CFReadStream>?
        var writeStream:Unmanaged<CFWriteStream>?
        
        // Open stream to PETRONE FPV control server. ( Default IP/Port - 192.168.10.1 : 23000 )
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "192.168.100.1" as CFString, 23000,
                                           &readStream,
                                           &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
    }
    
    public override func onDisConnect()                  {
        self.outputStream.close()
        self.inputStream.close()
        self.connected = false
    }
    
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            NSLog("\(aStream.description) - \(aStream.streamStatus.rawValue)")
        case Stream.Event.hasBytesAvailable:
            if aStream == self.inputStream { // recv from PETRONe
                var buffer = Array<UInt8>(repeating: 0, count: 1024)
                
                while self.inputStream.hasBytesAvailable {
                    let length = self.inputStream.read(&buffer, maxLength: 1024)
                    if length > 0 {
                        var recvbuffer = Array(buffer[4 ..< Int(buffer[3]+4)]) //Array<UInt8>(repeating: 0, count: Int(buffer[3]))
                        recvbuffer.insert(buffer[2], at: 0)
                        Petrone.instance.recvPacket(data: Data(recvbuffer))
                    }
                }
                
            }
        case Stream.Event.hasSpaceAvailable:
            if !connected {
                connected = true;
                Petrone.instance.pairing(status:connected)
            }
        case Stream.Event.errorOccurred, Stream.Event.endEncountered:
            if( aStream.streamStatus != Stream.Status.notOpen && aStream.streamStatus != Stream.Status.closed  ) {
                self.outputStream.close()
                self.inputStream.close()
                outputStream.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
                inputStream.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
                
                connected = false;
                Petrone.instance.pairing(status:connected, reason:" WIFI disconnect : \(eventCode)")
            }
        default:
            NSLog("Unknown event")
        }
    }
    
    @objc private func onCheckFPV() {
        if isWifiEnabled() {
            let url:URL = URL(string: "http://192.168.100.1")!
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    NSLog("Check error")
                    return
                }
                
                Petrone.instance.appearPetrone(name:"FPV Kit", uuid:"FPV", rssi:0)
            })
            
            task.resume()
        }
    }
    
    func isWifiEnabled() -> Bool {
        var hasWiFiNetwork: Bool = false
        let interfaces: NSArray = CFBridgingRetain(CNCopySupportedInterfaces()) as! NSArray
        
        for interface  in interfaces {
            let networkInfo: [AnyHashable: Any]? = CFBridgingRetain(CNCopyCurrentNetworkInfo(((interface) as! CFString))) as? [AnyHashable : Any]
            if (networkInfo != nil) {
                hasWiFiNetwork = true
                break
            }
        }
        
        return hasWiFiNetwork;
    }
}
