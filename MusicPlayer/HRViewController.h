//
//  HRViewController.h
//  Music Player
//
//  Created by Francisco Ramirez on 11/1/14.
//  Copyright (c) 2014 UACA. All rights reserved.
//

#import <UIKit/UIKit.h>


NSString *HeartRateNumber;


@interface WFViewController : UIViewController



@property (weak, nonatomic) IBOutlet UISwitch *antPlusSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bluetoothSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *suuntoSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *wildcardSwitch;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property (weak, nonatomic) IBOutlet UILabel *hrLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;

- (IBAction)connectButtonTouched:(id)sender;


@end