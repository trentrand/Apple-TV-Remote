//
//  ViewController.m
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
#import <CoreFoundation/CFDictionary.h>



@implementation ViewController

@synthesize mServerChannelID;
@synthesize mServerHandle;
@synthesize mIncomingChannelNotification;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self publishService];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)publishService
{
    NSString            *dictionaryPath = nil;
    NSString            *serviceName = nil;
    NSMutableDictionary *sdpEntries = nil;
    
    // Create a string with the new service name.
    serviceName = [NSString stringWithFormat:@" My New Service DEVICENAME"];
    
    // Get the path for the dictionary we wish to publish.
    dictionaryPath = [[NSBundle mainBundle]
                      pathForResource:@"DictionaryName" ofType:@"plist"];
    
    if ( ( dictionaryPath != nil ) && ( serviceName != nil ) )
    {
        // Initialize sdpEntries with the dictionary from the path.
        sdpEntries = [NSMutableDictionary
                      dictionaryWithContentsOfFile:dictionaryPath];
        
        
        if ( sdpEntries != nil )
        {
            IOBluetoothSDPServiceRecordRef  serviceRecordRef;
            
            
            // [sdpEntries setObject:serviceName forKey:@"0100 - ServiceName*"];
            
            // Create a new IOBluetoothSDPServiceRecord that includes both
            // the attributes in the dictionary and the attributes the
            // system assigns. Add this service record to the SDP database.
            if (IOBluetoothAddServiceDict( (CFDictionaryRef) CFBridgingRetain(sdpEntries),
                                          &serviceRecordRef ) == kIOReturnSuccess)
            {
                IOBluetoothSDPServiceRecord *serviceRecord;
                
                serviceRecord = [IOBluetoothSDPServiceRecord
                                 withSDPServiceRecordRef:serviceRecordRef];
                
                // Preserve the RFCOMM channel assigned to this service.
                // A header file contains the following declaration:
                // IOBluetoothRFCOMMChannelID mServerChannelID;
                [serviceRecord getRFCOMMChannelID:&mServerChannelID];
                
                // Preserve the service-record handle assigned to this
                // service.
                // A header file contains the following declaration:
                // IOBluetoothSDPServiceRecordHandle mServerHandle;
                [serviceRecord getServiceRecordHandle:&mServerHandle];
                
                // Register for a notification so we get notified when a client opens
                // the channel assigned to our new service.
                // A header file contains the following declaration:
                // IOBluetoothUserNotification *mIncomingChannelNotification;
                
                mIncomingChannelNotification = [IOBluetoothRFCOMMChannel
                                                registerForChannelOpenNotifications:self
                                                selector:@selector(newRFCOMMChannelOpened:channel:)
                                                withChannelID:mServerChannelID
                                                direction:kIOBluetoothUserNotificationChannelDirectionIncoming];
                
                // Now that we have an IOBluetoothSDPServiceRecord object,
                // we no longer need the IOBluetoothSDPServiceRecordRef.
                IOBluetoothObjectRelease( serviceRecordRef );
                
            }
        }
    }
}




@end
