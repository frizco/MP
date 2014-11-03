//
//  _WFSensorConnection+WFSensorConnectionCategory.h
//  Music Player
//
//  Created by Francisco Ramirez on 11/2/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

#import <WFConnector/WFConnector.h>
#import <Foundation/Foundation.h>

@interface _WFSensorConnection (WFSensorConnectionCategory)



typedef NS_ENUM(NSUInteger, ConnectionStatus) {
    ConnectionStatusIdle,
    ConnectionStatusConnecting,
    ConnectionStatusConnected,
    ConnectionStatusInterrupted,
    ConnectionStatusDisconnecting
};

- (ConnectionStatus) connectionStatus;

@end
