//
//  PetroneProtocols.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 26..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import Foundation

/*!
 *  @protocol PetroneProtocol
 *
 *  @discussion Delegate for Petrone.
 *
 */
public protocol PetroneProtocol : NSObjectProtocol {
    /*!
     *  @method connectionComplete:
     *
     *  @param petroneController    The send petroneController
     *  @param response             Response PetroneDataType
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType Ack response.
     */
    func petrone(_ petroneController:PetroneController, didConnect complete:String )
    /*!
     *  @method recvFromPetroneResponse:
     *
     *  @param petroneController    The send petroneController
     *  @param response             Response PetroneDataType
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType Ack response.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone response:UInt8 )
    /*!
     *  @method recvFromPetroneStatus:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType status.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone status:PetroneStatus )
    /*!
     *  @method recvFromPetroneTrim:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType TrimFlight & TrimDrive Information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone trim:PetroneTrim )
    /*!
     *  @method recvFromPetroneTrimFlight:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType TrimFlight information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone trimFlight:PetroneTrimFlight )
    /*!
     *  @method recvFromPetroneTrimDrive:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType TrimDrive information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone trimDrive:PetroneTrimDrive )
    /*!
     *  @method recvFromPetroneAttitude:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType Attitude information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone attitude:PetroneAttitude )
    /*!
     *  @method recvFromPetroneGyroBias:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType GyroBias information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone gyroBias:PetroneGyroBias )
    /*!
     *  @method recvFromPetroneFlightCount:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType CountFlight information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone flightCount:PetroneCountFlight )
    /*!
     *  @method recvFromPetroneDriveCount:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType CountDrive information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone driveCount:PetroneCountDrive )
    /*!
     *  @method recvFromPetroneImuRawAndAngle:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType ImuRawAndAngle information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone motor:PetroneImuRawAndAngle )
    /*!
     *  @method recvFromPetronePressure:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType Pressure information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone motor:PetronePressure )
    /*!
     *  @method recvFromPetroneImageFlow:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType Motor information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone motor:PetroneImageFlow )
    /*!
     *  @method recvFromPetroneMotor:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType Motor information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone motor:PetroneMotor )
    /*!
     *  @method recvFromPetroneTemperature:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType TEmperature information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone temperature:PetroneTemperature )
    /*!
     *  @method recvFromPetroneRange:
     *
     *  @param petroneController    The send petroneController
     *
     *  @discussion            This method is invoked when the @recv of PetroneDataType Range information.
     */
    func petrone(_ petroneController:PetroneController, recvFromPetrone range:PetroneRange )
}
