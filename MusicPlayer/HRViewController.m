//
//  HRViewController.m
//  Music Player
//
//  Created by Francisco Ramirez on 11/1/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

#import "HRViewController.h"
#import <WFConnector/WFConnector.h>





@interface UIViewController () <WFHardwareConnectorDelegate,NSURLConnectionDelegate>


@property (nonatomic, retain) WFSensorConnection* sensorConnection;

@end

@implementation WFViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //Setup the hardware connecctor.
    WFHardwareConnector* hardwareConnector = [WFHardwareConnector sharedConnector];
    hardwareConnector.delegate = self;
    [hardwareConnector setSampleTimerDataCheck:FALSE];
    [hardwareConnector setSampleRate:1.0];
    
    //Need to enable the BT
    [hardwareConnector enableBTLE:YES];
    
    NSLog(@"API VERSION:  %@", hardwareConnector.apiVersion);
    NSLog(@"Has BTLE: %@", hardwareConnector.hasBTLESupport ? @"YES" : @"NO");
    
    [self updateConnectButton];
    [self updateData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark - UI

- (void) updateConnectButton
{
    // get the current connection status.
    WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
    if ( self.sensorConnection != nil )
    {
        connState = self.sensorConnection.connectionStatus;
    }
    
    // set the button state based on the connection state.
    switch (connState)
    {
        case WF_SENSOR_CONNECTION_STATUS_IDLE:
            [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
            [self.connectButton setTitle:@"Connecting.." forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
            [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
            [self.connectButton setTitle:@"Disconnecting.." forState:UIControlStateNormal];
            break;
        case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
            [self.connectButton setTitle:@"Interrupted!" forState:UIControlStateNormal];
            break;
    }
    
}

//--------------------------------------------------------------------------------

- (void) updateData
{
    bool isValid = NO;
    
    if([self.sensorConnection isKindOfClass:[WFHeartrateConnection class]])
    {
        WFHeartrateConnection* hrConnection = (WFHeartrateConnection*)self.sensorConnection;
        
        if(hrConnection.connectionStatus == WF_SENSOR_CONNECTION_STATUS_CONNECTED)
        {
            isValid=YES;
            self.serialLabel.text = hrConnection.deviceIDString;
            self.hrLabel.text = [[hrConnection getHeartrateData] formattedHeartrate:NO];
            HeartRateNumber = self.hrLabel.text;
        }
    }
    
    if(!isValid)
    {
        self.serialLabel.text = @"--";
        self.hrLabel.text = @"--";
    }
}

//--------------------------------------------------------------------------------

- (IBAction)connectButtonTouched:(id)sender
{
    [self toggleConnection];
}

#pragma mark -
#pragma mark - Connection Management

//--------------------------------------------------------------------------------
- (void) toggleConnection
{
    //--------------------------------------------------------------------
    // Sensor Type
    WFSensorType_t sensorType = WF_SENSORTYPE_HEARTRATE;
    
    //--------------------------------------------------------------------
    // Network Type
    WFNetworkType_t networkType = WF_NETWORKTYPE_UNSPECIFIED;
    
    if(self.antPlusSwitch.on) networkType |= WF_NETWORKTYPE_ANTPLUS;
    if(self.bluetoothSwitch.on) networkType |= WF_NETWORKTYPE_BTLE;
    if(self.suuntoSwitch.on) networkType |= WF_NETWORKTYPE_SUUNTO;
    
    //OR simply
    //networkType = WF_NETWORKTYPE_ANY;
    
    //--------------------------------------------------------------------
    // Wildcard
    
    bool isWildcard = self.wildcardSwitch.on;
    
    //--------------------------------------------------------------------
    // Current Connection Status
    WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
    WFHardwareConnector* hardwareConnector = [WFHardwareConnector sharedConnector];
    
    if ( self.sensorConnection != nil )
    {
        connState = self.sensorConnection.connectionStatus;
    }
    
    //--------------------------------------------------------------------
    // Toggle Connection
    switch (connState)
    {
        case WF_SENSOR_CONNECTION_STATUS_IDLE:
        {
            // create the connection params.
            WFConnectionParams* params = nil;
            
            if ( isWildcard )
            {
                // if wildcard search is specified, create empty connection params.
                params = [[WFConnectionParams alloc] init];
                params.sensorType = sensorType;
                params.networkType = networkType;
            }
            else
            {
                //
                // otherwise, get the params from the stored settings.
                params = [hardwareConnector.settings connectionParamsForSensorType:sensorType];
            }
            
            if ( params != nil)
            {
                NSError* error = nil;
                
                // if the connection request is a wildcard, you could use proximity search
                if ( isWildcard )
                {
                    WFProximityRange_t range = WF_PROXIMITY_RANGE_DISABLED;
                    self.sensorConnection = [hardwareConnector requestSensorConnection:params withProximity:range error:&error];
                    
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@\n\n\n\n%@",self.sensorConnection, error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else
                {
                    // otherwise, use normal connection request.
                    self.sensorConnection = [hardwareConnector requestSensorConnection:params];
                }
                
                if(error!=nil)
                {
                    NSLog(@"ERROR: %@", error);
                }
                
                // set delegate to receive connection status changes.
                self.sensorConnection.delegate = self;
            }
            break;
        }
            
        case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
        case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
            // disconnect the sensor.
            NSLog(@"Disconnecting sensor connection");
            [self.sensorConnection disconnect];
            break;
            
        case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
        case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
            // do nothing.
            break;
    }
    
    [self updateConnectButton];
}


#pragma mark WFHardwareConnectorDelegate Implementation

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(_WFHardwareConnector*)hwConnector stateChanged:(WFHardwareConnectorState_t)currentState
{
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(_WFHardwareConnector*)hwConnector connectedSensor:(WFSensorConnection*)connectionInfo
{
    NSString* logMsg = [NSString stringWithFormat:@"Sensor Connected: %@ on Network: %@",
                        [self nameFromSensorType:connectionInfo.sensorType],
                        [self nameFromNetworkType:connectionInfo.networkType]];
    
    NSLog(@"%@", logMsg);
    
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(_WFHardwareConnector*)hwConnector disconnectedSensor:(WFSensorConnection*)connectionInfo
{
    NSString* logMsg = [NSString stringWithFormat:@"Sensor Disconnected: %@ on Network: %@",
                        [self nameFromSensorType:connectionInfo.sensorType],
                        [self nameFromNetworkType:connectionInfo.networkType]];
    
    NSLog(@"%@", logMsg);
}

//--------------------------------------------------------------------------------
- (void)hardwareConnector:(_WFHardwareConnector*)hwConnector searchTimeout:(WFSensorConnection*)connectionInfo
{
    NSString* logMsg = [NSString stringWithFormat:@"Search Timeout: %@",
                        [self nameFromSensorType:connectionInfo.sensorType]];
    
    NSLog(@"%@", logMsg);
}

//--------------------------------------------------------------------------------
- (void)hardwareConnectorHasData
{
    [self updateData];
}

#pragma mark -
#pragma mark WFSensorConnectionDelegate Implementation

//--------------------------------------------------------------------------------
- (void)connection:(WFSensorConnection*)connectionInfo stateChanged:(WFSensorConnectionStatus_t)connState
{
    // check for a valid connection.
    if (connectionInfo.isValid)
    {
        // update the stored connection settings.
        [[WFHardwareConnector sharedConnector].settings saveConnectionInfo:connectionInfo];
        
        // update the display.
        [self updateData];
    }
    
    // check for disconnected sensor.
    else if ( connState == WF_SENSOR_CONNECTION_STATUS_IDLE )
    {
        // reset the display.
    }
    
    [self updateConnectButton];
}


#pragma mark - Helpful Methods

- (NSString*) nameFromSensorType:(WFSensorType_t)sensorType
{
    NSString* retVal;
    
    switch (sensorType)
    {
        case WF_SENSORTYPE_HEARTRATE:
            retVal = @"Heartrate";
            break;
        case WF_SENSORTYPE_BIKE_POWER:
            retVal = @"Power";
            break;
        case WF_SENSORTYPE_BIKE_SPEED_CADENCE:
            retVal = @"Speed & Cadence";
            break;
        default:
            retVal = @"Unknown";
            break;
    }
    
    return	retVal;
}

- (NSString*) nameFromNetworkType:(WFNetworkType_t)networkType
{
    NSString* retVal;
    
    switch (networkType)
    {
        case WF_NETWORKTYPE_BTLE:
            retVal = @"BTLE";
            break;
        case WF_NETWORKTYPE_ANTPLUS:
            retVal = @"ANT+";
            break;
        case WF_NETWORKTYPE_SUUNTO:
            retVal = @"Suunto";
            break;
        default:
            retVal = @"Unknown";
            break;
    }
    
    return	retVal;
}


@end