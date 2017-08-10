//
//  PetroneEnums.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 31..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

public enum PetroneDataType: UInt8 {
    case    None
    
    case    Ping = 0x01,            ///< Ping connection status ( reserve )
            Ack,                    ///< Data response ack
            Error,                  ///< Connection error
            Request,                ///< Request
            Passcode                ///< new pairing password
    
    case    Control = 0x10,         ///< Control Petrone command
            Command,
            Command2,
            Command3
    
    case    LedMode = 0x20,         ///< LED mode setting
            LedMode2,               ///< LED mode setting ( 2 values )
            LedModeCommand,         ///< LED mode & command
            LedModeCommandIr,       ///< LED mode, command & IR Send
            LedModeColor,           ///< LED mode color RGB setting
            LedModeColor2,          ///< LED mode color RGB setting ( 2 values )
            LedEvent,               ///< LED event
            LedEvent2,              ///< LED event ( 2 values ),
            LedEventCommand,        ///< LED event & command
            LedEventCommandIr,      ///< LED mode, command & IR Send
            LedEventColor,          ///< LED event color RGB
            LedEventColor2,         ///< LED event color RGB ( 2 values )
            LedModeDefaultColor,    ///< LED Default mode color
            LedModeDefaultColor2    ///< LED Default mode color ( 2 values)
    
    case    Address = 0x30,
            State,                  ///< PETRONE status ( Drone mode, coordinate, battery )
            Attitude,               ///< PETRONE attitude(Vector)
            GyroBias,               ///< PETRONE Gyro(Vector)
            TrimAll,                ///< PETRONE trim infomation( Flight, Drive )
            TrimFlight,             ///< PETRONE flight trim information
            TrimDrive,              ///< PETRONE drive trim information
            CountFlight,            ///< PETRONE flight count information
            CountDrive              ///< PETRONE drive count information
    
    case    IrMessage = 0x40        ///< IR Data send/recv
    
    // Sensor data
    case    ImuRawAndAngle = 0x50,  ///< IMU Raw + Angle
            Pressure,               ///< Pressure sensor
            ImageFlow,              ///< ImageFlow
            Button,                 ///< Button Input
            Battery,                ///< Battery sStatus
            Motor,                  ///< Motor staus
            Temperature,            ///< Temperature
            Range,                  ///< Range sensor
    
            EndOfType
}

public enum PetroneCommand : UInt8
{
    case    None = 0
    
    case    ModePetrone = 0x10         ///< PETRONE mode change
    
    case    Coordinate = 0x20,          ///< PETRONE coordinate change
            Trim,                       ///< PETRONE trime change
            FlightEvent,                ///< PETRONE flight event
            DriveEvent,                 ///< PETRONE drive event
            Stop                        ///< PETRONE stop
    
    case    ResetHeading = 0x50,        ///< PETRONe Heading reset
            ClearGyroBiasAndTrim,       ///< Clear Gyro & trim
            ClearTrim                   ///< Clear trim
    
    case    Request = 0x90,             ///< Request data type
    
            EndOfType
}

public enum PetroneFlightEvent : UInt8
{
    case    None = 0,
    
            TakeOff,            ///< TakeOff
    
            FlipFront,          ///< Flip
            FlipRear,           ///< Flip
            FlipLeft,           ///< Flip
            FlipRight,          ///< Flip
    
            Stop,               ///< Stop
            Landing,            ///< Landing
            TurnOver,           ///< TurnOver for reverse
    
            Shot,               ///< IR Shot event
            UnderAttack,        ///< IR Damage event
            Square,
            CircleLeft,
            CircleRight,
            Rotate180,
    
            EndOfType
}

public enum PetroneDriveEvent : UInt8
{
    case    None = 0,
    
            Stop,               ///< Stop
    
            Shot,               ///< IR Shot event
            UnderAttack,        ///< IR Damage event
            Square,
            CircleLeft,
            CircleRight,
            Rotate90Left,
            Rotate90Right,
            Rotate180,
            Rotate3600,
    
            EndOfType
}

public enum PetroneMode : UInt8
{
    case    None = 0
    
    case    Flight = 0x10,      ///< Flight with guard
            FlightNoGuard,      ///< Flight no guard
            FlightFPV           ///< Flight with FPV Kit
    
    case    Drive = 0x20,       ///< Drive
            DriveFPV            ///< Drive with FPV Kit
}

public enum PetroneModeSystem: UInt8
{
    case    None = 0,
    
            Boot,               ///< System Booting
            Wait,               ///< Ready for connection
    
            Ready,              ///< Ready for control
    
            Running,            ///< Running code
    
            Update,             ///< Firmware Updating.
            UpdateComplete,     ///< Firmware update complete
    
            Error,              ///< System error
    
            EndOfType
}

public enum PetroneModeFlight: UInt8
{
    case    None = 0,
    
            Ready,              ///< Ready for flight
    
            TakeOff,            ///< Take off
            Flight,             ///< Flight
            Flip,               ///< Flip
            Stop,               ///< Stop flight
            Landing,            ///< Landing
            Reverse,            ///< Reverse
    
            Accident,           ///< Accident ( Change to ready )
            Error,              ///< System error
    
            EndOfType
}

public enum PetroneModeDrive: UInt8
{
    case    None = 0,
    
            Ready,              ///< Ready for drive
    
            Start,              ///< Start
            Drive,              ///< Drive
            Stop,               ///< Stop driving
    
            Accident,           ///< Accident ( Change to ready )
            Error,              ///< System error
    
            EndOfType
}

public enum PetroneCoordinate: UInt8
{
    case    None = 0,
    
            Absolute,           ///< Absolute axis
            Relative,           ///< Relative axis
            Fixed,              ///< Fixed heading axis
    
            EndOfType
}

public enum PetroneDirection: UInt8
{
    case    None = 0,
    
            Left,
            Front,
            Right,
            Rear,
    
            EndOfType
}

public enum PetroneSensorOrientation: UInt8
{
    case    None = 0,
    
            Normal,         //  Normal
            ReverseStart,   //  Start reverse
            Reversed,       //  Reversed
    
            EndOfType
}

public enum PetroneLigthMode: UInt8
{
    case    None = 0,
    
            WaitingForConnect,  ///< Waiting for connect
            Connected
    
    case    EyeNone = 0x10,
            EyeHold,            ///< Eye light hold
            EyeMix,             ///< Eye light color change
            EyeFlicker,         ///< Eye light flickering
            EyeFlickerDouble,   ///< Eye light flickering 2times
            EyeDimming          ///< Eye light dimming
    
    case    ArmNone = 0x40,
            ArmHold,            ///< 지정한 색상을 계속 켬
            ArmMix,             ///< 순차적으로 LED 색 변경
            ArmFlicker,         ///< 깜빡임
            ArmFlickerDouble,   ///< 깜빡임(두 번 깜빡이고 깜빡인 시간만큼 꺼짐)
            ArmDimming,         ///< 밝기 제어하여 천천히 깜빡임
            ArmFlow,            ///< 앞에서 뒤로 흐름
            ArmFlowReverse      ///< 뒤에서 앞으로 흐름
    
    case    EndOfType

}
public enum PetroneColors: UInt8
{
    case    AliceBlue = 0,
            AntiqueWhite,
            Aqua,
            Aquamarine,
            Azure,
            Beige,
            Bisque,
            Black,
            BlanchedAlmond,
            Blue,
            BlueViolet,     // 10
            Brown,
            BurlyWood,
            CadetBlue,
            Chartreuse,
            Chocolate,
            Coral,
            CornflowerBlue,
            Cornsilk,
            Crimson,
            Cyan,           // 20
            DarkBlue,
            DarkCyan,
            DarkGoldenRod,
            DarkGray,
            DarkGreen,
            DarkKhaki,
            DarkMagenta,
            DarkOliveGreen,
            DarkOrange,
            DarkOrchid,     // 30
            DarkRed,
            DarkSalmon,
            DarkSeaGreen,
            DarkSlateBlue,
            DarkSlateGray,
            DarkTurquoise,
            DarkViolet,
            DeepPink,
            DeepSkyBlue,
            DimGray,        // 40
            DodgerBlue,
            FireBrick,
            FloralWhite,
            ForestGreen,
            Fuchsia,
            Gainsboro,
            GhostWhite,
            Gold,
            GoldenRod,
            Gray,           // 50
            Green,
            GreenYellow,
            HoneyDew,
            HotPink,
            IndianRed,
            Indigo,
            Ivory,
            Khaki,
            Lavender,
            LavenderBlush,  // 60
            LawnGreen,
            LemonChiffon,
            LightBlue,
            LightCoral,
            LightCyan,
            LightGoldenRodYellow,
            LightGray,
            LightGreen,
            LightPink,
            LightSalmon,    // 70
            LightSeaGreen,
            LightSkyBlue,
            LightSlateGray,
            LightSteelBlue,
            LightYellow,
            Lime,
            LimeGreen,
            Linen,
            Magenta,
            Maroon,         // 80
            MediumAquaMarine,
            MediumBlue,
            MediumOrchid,
            MediumPurple,
            MediumSeaGreen,
            MediumSlateBlue,
            MediumSpringGreen,
            MediumTurquoise,
            MediumVioletRed,
            MidnightBlue,   // 90
            MintCream,
            MistyRose,
            Moccasin,
            NavajoWhite,
            Navy,
            OldLace,
            Olive,
            OliveDrab,
            Orange,
            OrangeRed,      // 100
            Orchid,
            PaleGoldenRod,
            PaleGreen,
            PaleTurquoise,
            PaleVioletRed,
            PapayaWhip,
            PeachPuff,
            Peru,
            Pink,
            Plum,           // 110
            PowderBlue,
            Purple,
            RebeccaPurple,
            Red,
            RosyBrown,
            RoyalBlue,
            SaddleBrown,
            Salmon,
            SandyBrown,
            SeaGreen,       // 120
            SeaShell,
            Sienna,
            Silver,
            SkyBlue,
            SlateBlue,
            SlateGray,
            Snow,
            SpringGreen,
            SteelBlue,
            Tan,            // 130
            Teal,
            Thistle,
            Tomato,
            Turquoise,
            Violet,
            Wheat,
            White,
            WhiteSmoke,
            Yellow,
            YellowGreen
}
