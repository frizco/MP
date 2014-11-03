//
//  _WFSensorConnection+WFSensorConnectionCategory.m
//  Music Player
//
//  Created by Francisco Ramirez on 11/2/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

#import "_WFSensorConnection+WFSensorConnectionCategory.h"

@implementation _WFSensorConnection (WFSensorConnectionCategory)

- (ConnectionStatus) connectionStatus {
    if ( [self connectionStatus] == WF_SENSOR_CONNECTION_STATUS_IDLE) {
        return ConnectionStatusIdle;
    } else if ( [self connectionStatus] == WF_SENSOR_CONNECTION_STATUS_CONNECTING) {
        return ConnectionStatusConnecting;
    } else if ( [self connectionStatus] == WF_SENSOR_CONNECTION_STATUS_CONNECTED) {
        return ConnectionStatusConnected;
    } else if ( [self connectionStatus] == WF_SENSOR_CONNECTION_STATUS_DISCONNECTING) {
        return ConnectionStatusDisconnecting;
    } else if ( [self connectionStatus] == WF_SENSOR_CONNECTION_STATUS_INTERRUPTED) {
        return ConnectionStatusInterrupted;
    }
    return 0;
}


@end
