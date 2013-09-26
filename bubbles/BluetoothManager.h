//
//  BluetoothManager.h
//  bubbles
//
//  Created by MEGHA GULATI on 9/26/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

typedef enum {
    BluetoothCommandHandshake=1,
    BluetoothCommandNegotiate,
    BluetoothCommandNegotiateConfirm,
    BluetoothCommandLayout,
    BluetoothCommandPickUp,
    BluetoothCommandMove,
    BluetoothCommandPop,
    BluetoothCommandCreateNew,
    BluetoothCommandDrop
} BluetoothCommand;



@interface BluetoothManager : NSObject <MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
{
    MCNearbyServiceBrowser *nearbyBrowser;
    MCNearbyServiceAdvertiser *nearbyAdvertiser;
    
    MCSession *session;
    NSString *peerId;
    
    NSDate *playerIndexTimestamp;

}

@property (nonatomic, readonly) NSString *peerName;
@property (nonatomic, readonly) NSInteger playerIndex;

+(BluetoothManager*) instance;
+(BOOL) hasConnection;

-(void) sendDictionaryToPeers:(NSDictionary*)dict;

@end
