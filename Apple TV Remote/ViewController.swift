//
//  ViewController.swift
//
//  Created by Trent Rand on 12/30/14.
//  Copyright (c) 2014 applies, llc. All rights reserved.
//

import Cocoa
import IOBluetooth

class ViewController: NSViewController {
    
    var sdpEntries: NSMutableDictionary?
    var serviceName: NSString?
    var dictionaryPath: String?
    
    var mServerHandle: BluetoothSDPServiceRecordHandle?
    var mServerChannelID: BluetoothRFCOMMChannelID?
    var mIncomingChannelNotification: IOBluetoothUserNotification?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("viewDidLoad()")

        // Do any additional setup after loading the view.
        publishService()
    }
    
    
    func publishService() -> Bool {

        // Create a string with the new service name.
        serviceName = "My New Service"
        
        // Get the path for the dictionary we wish to publish.
        dictionaryPath = NSBundle.mainBundle().pathForResource("MyServiceDictionary", ofType: "plist")
        
        if dictionaryPath != nil && serviceName != nil {
            // Initialize sdpEntries with the dictionary from the path.
            sdpEntries = NSMutableDictionary(contentsOfFile: dictionaryPath!)
            
            if (sdpEntries != nil) {
                var serviceRecordRef: IOBluetoothSDPServiceRecordRef
                sdpEntries!.setObject(serviceName!, forKey: "0100 - ServiceName*")
                
                // Create a new IOBluetoothSDPServiceRecord that includes both
                // the attributes in the dictionary and the attributes the
                // system assigns. Add this service record to the SDP database.
                if ((IOBluetoothSDPServiceRecord.publishedServiceRecordWithDictionary(sdpEntries!)) != nil) {
                    var serviceRecord: IOBluetoothSDPServiceRecord
                    serviceRecord = IOBluetoothSDPServiceRecord.withSDPServiceRecordRef(serviceRecordRef!)
                    
                    // Preserve the RFCOMM channel assigned to this service.
                    // A header file contains the following declaration:
                    // IOBluetoothRFCOMMChannelID mServerChannelID;
                    serviceRecord.getRFCOMMChannelID(&mServerChannelID!)
                    
                    // Preserve the service-record handle assigned to this
                    // service.
                    // A header file contains the following declaration:
                    // IOBluetoothSDPServiceRecordHandle mServerHandle;
                    serviceRecord.getServiceRecordHandle(&mServerHandle!)

                    
                }
                
                }

        }
        
    }

}