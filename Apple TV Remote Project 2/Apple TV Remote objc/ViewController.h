//
//  ViewController.h
//
//  Created by Trent Rand on 1/5/15.
//  Copyright (c) 2015 applies, llc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"
#import <IOBluetooth/IOBluetooth.h>
#import <IOBluetooth/objc/IOBluetoothDevice.h>
#import <IOBluetooth/objc/IOBluetoothRFCOMMChannel.h>
#import <IOBluetoothUI/IOBluetoothUI.h>


@interface ViewController : NSViewController

@property BluetoothSDPServiceRecordHandle mServerHandle;
@property BluetoothRFCOMMChannelID mServerChannelID;
@property IOBluetoothUserNotification* mIncomingChannelNotification;

@end

