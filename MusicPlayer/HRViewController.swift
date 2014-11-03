//
//  HRViewController.swift
//  Music Player
//
//  Created by Francisco Ramirez on 11/2/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

import Foundation
import UIKit



class HRViewController: UIViewController, WFHardwareConnectorDelegate, NSURLConnectionDataDelegate {
    
//    var sensorConnection = WFSensorConnection?() // WTF
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var hrLabel: UILabel!
    
    @IBOutlet weak var blutoothSwitch: UISwitch!
    @IBOutlet weak var antPlusSwitch: UISwitch!
    @IBOutlet weak var suuntoSwitch: UISwitch!
    
    @IBOutlet weak var wildcardSwitch: UISwitch!
    
    @IBOutlet weak var serialLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the hardware connector
        var hardwareConnector = WFHardwareConnector.sharedConnector()
        hardwareConnector.delegate = self
        hardwareConnector.setSampleTimerDataCheck(false)
        hardwareConnector.sampleRate = 1.0 // might be fucked
        
        // Need to enable the BT
        hardwareConnector.enableBTLE(true)
        
        println("API VERSION: \(hardwareConnector.apiVersion)")
        
        if hardwareConnector == true {
            println("Has BTLE: YES")
        } else if hardwareConnector == false {
            println("Has BTLE: NO")
        } else {
            println("error with bool")
        }
        
//        self.updateConnectButton
    }
        
        
/****************************************************************
*********************** UI **************************************
*****************************************************************/
        
        
        func updateConnectButton () {
            // get the current connection status
            var connState:WFSensorConnectionStatus_t? = WF_SENSOR_CONNECTION_STATUS_IDLE
            if self.sensorConnection != nil {
                connState = self.sensorConnection!.connectionStatus()
            }
            
            var sensorConnection: WFSensorConnection?
            connState = ConnectionStatus.Idle
            connState = sensorConnection!.connectionStatus()
            switch connState {
            case ConnectionStatus.Idle:
                println("sahg;")
            case ConnectionStatus.Connecting:
                println("afdkl")
            case ConnectionStatus.Connected:
                println("afdkl")
            case ConnectionStatus.Disconnecting:
                println("afdkl")
            case ConnectionStatus.Interrupted:
                println("afdkl")
            default:
                println("error")
            }
        }
        
/****************************************************************/



        func updateData () {
            
            var isValid = false
            
//            if(self.sensorConnection.isKindOfClass.WFHeartrateConnection.self != nil)) {
            
            var hrConnection = WFHeartrateConnection()
            hrConnection = self.sensorConnection as WFHeartrateConnection
//            if hrConnection.connectionStatus == WF_SENSOR_CONNECTION_STATUS_CONNECTED {
            
            isValid = true
            self.serialLabel.text = hrConnection.deviceIDString
            self.hrLabel.text = hrConnection.getHeartrateData().formattedHeartrate(false)
            HeartRateNumber = self.hrLabel.text
            
            if isValid != false {
                self.serialLabel.text = "--"
                self.hrLabel.text = "--"
            }
            
        }
    
/****************************************************************/


    @IBAction func connectButtonTouched (sender: AnyObject) {
        
//        self.toggleConnection // UNCOMMENT
        
    }
    
    
    func toggleConnection () {
        
        //--------------------------------------------------------
        // Sensor Type
        var sensorType = WF_SENSORTYPE_HEARTRATE
        
        //--------------------------------------------------------
        // Network Type
        var networkType = WF_NETWORKTYPE_UNSPECIFIED
        
//        is(self.antPlusSwitch.on) networkType
        networkType = WF_NETWORKTYPE_ANY
        
        var isWildCard = self.wildcardSwitch?.on
        
        //-------------------------------------------------------
        // Current Connection Status
        var connState = WF_SENSOR_CONNECTION_STATUS_IDLE
        var harddwareConnector = WFHardwareConnector.sharedConnector()
        
        if self.sensorConnection != nil {
            connState = self.sensorConnection!.connectionStatus()
        }
        //-------------------------------------------------------
        // Toggle Connection
        switch connState {
        case ConnectionStatus.Idle:
            // create the connection params.
            var params:WFConnectionParams? = nil;
            if isWildCard != nil {
                // if wildcard search is specified, create empty connection params.
                params = WFConnectionParams()
                params.sensorType = sensorType;
                params.networkType = networkType;
            } else {
                //
                // otherwise, get the params from the stored settings.
                params = harddwareConnector.settings.connectionParamsForSensorType(sensorType)
            }
            
            if params != nil {
                var error:NSError = nil
                
                // if the connection request is a wildcard, you could use the prozimity search
                if isWildCard != nil {
                    var range = WF_PROXIMITY_RANGE_DISABLED
                    self.sensorConnection = harddwareConnector.requestSensorConnection(params, withProximity: range, error: &error)
                    
                    var alert: UIAlertController = UIAlertController(title: "Alert", message: "Something fucked up", preferredStyle: UIAlertControllerStyle.Alert) // incorrect syntax
                    
                } else {
                    // otherwise, use normal connection request.
                    self.sensorConnection = harddwareConnector.requestSensorConnection(params)
                }
                if error != nil {
                    println("Error \(error)")
                }
                
                // set delegate to recieve connection status changes.
                self.sensorConnection.delegate = self;
            }
            
            
            
        case ConnectionStatus.Connecting, ConnectionStatus.Connected:
            // disconnect the sensor.
            println("Disconnecting the sensor connection")
            self.sensorConnection.disconnect()
        case ConnectionStatus.Disconnecting, ConnectionStatus.Interrupted:
            println("disconnecting  or Interrupted case called")
            // do nothing
        default:
            println("error with big Switch")
        
       
        
        }
        self.updateConnectButton()
    }
////----------------------------------------------------------------
//    func hardwareConnector(hwConnector: _WFHardwareConnector, currentState: stateChanged.WFSensorConnection_t) {
//        
//    }
////----------------------------------------------------------------
//    func hardwareConnector(hwConnector: _WFHardwareConnector, connectionInfo: WFSensorConnection) {
//        var logMsg = "Sensor Connected: \(self.nameFromSensorType:connectionInfo.sensorType) on Network: %@"
//    }
////----------------------------------------------------------------
//    
//    
////----------------------------------------------------------------
//    
//    
////----------------------------------------------------------------
//    
//    
////----------------------------------------------------------------
//        
//        
    
        
    
    
    
    
    
    
}