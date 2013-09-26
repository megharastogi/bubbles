//
//  BluetoothManager.m
//  bubbles
//
//  Created by MEGHA GULATI on 9/26/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "BluetoothManager.h"

static BluetoothManager *sharedInstance = nil;

@implementation BluetoothManager

+(BluetoothManager*) instance
{
    if( sharedInstance == nil )
        sharedInstance = [BluetoothManager new];
    return sharedInstance;
}

-(id) init
{
    self = [super init];
    if( self ) {
        MCPeerID *myId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        
        nearbyBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:myId serviceType:@"russell"];
        
        nearbyBrowser.delegate = self;
        [nearbyBrowser startBrowsingForPeers];
        
        nearbyAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:myId discoveryInfo:nil serviceType:@"russell"];
        nearbyAdvertiser.delegate = self;
        [nearbyAdvertiser startAdvertisingPeer];
        
        session = [[MCSession alloc] initWithPeer:myId];
        session.delegate = self;
    }
    return self;
}

+(BOOL) hasConnection
{
    return (sharedInstance != nil && sharedInstance.peerName != nil);
}


-(void) sendDictionaryToPeers:(NSDictionary*)dict
{
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [session sendData:encodedData toPeers:session.connectedPeers withMode:MCSessionSendDataUnreliable error:nil];
}


#pragma mark - Nearby browser delegate

-(void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [browser invitePeer:peerID toSession:session withContext:nil timeout:0];
}

-(void) browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
}

#pragma mark - Nearby advertiser delegate

-(void) advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    invitationHandler( YES, session );
}




#pragma mark - Session delegate

-(void) session:(MCSession*)theSession
           peer:(MCPeerID *)peerID
 didChangeState:(MCSessionState)state
{
    if( state == MCSessionStateConnected )
    {
        NSDictionary *handshake = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(BluetoothCommandHandshake), @"command",
                                   [[UIDevice currentDevice] name], @"peerName",
                                   nil];
        [self sendDictionaryToPeers:handshake];
    }
    else if( state == MCSessionStateNotConnected )
    {
    }
}


- (void)session:(MCSession *)session
 didReceiveData:(NSData *)data
       fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSInteger command = [dict[@"command"] intValue];
    
    switch( command )
    {
        case BluetoothCommandHandshake:
        {
            _peerName = [dict objectForKey:@"peerName"];
            
            // start negotiating player index
            playerIndexTimestamp = [NSDate date];
            NSDictionary *negotiation = @{@"command":     @(BluetoothCommandNegotiate),
                                          @"playerIndex": @0,
                                          @"timestamp":   playerIndexTimestamp};
            [self sendDictionaryToPeers:negotiation];
            break;
        }
        case BluetoothCommandNegotiate:
        {
            NSDate *otherTimestamp = [dict objectForKey:@"timestamp"];
            NSInteger otherPlayer = [[dict objectForKey:@"playerIndex"] intValue];
            
            if( [otherTimestamp compare:playerIndexTimestamp] == NSOrderedAscending )
            {
                // other timestamp was earlier, so it wins
                _playerIndex = 1 - otherPlayer;
                NSDictionary *negotiation = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithInt:BluetoothCommandNegotiateConfirm], @"command",
                                             [NSNumber numberWithInt:_playerIndex], @"playerIndex",
                                             nil];
                [self sendDictionaryToPeers:negotiation];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Player Index"
                                                                    message:[NSString stringWithFormat:@"Other timestamp won, setting my index to %i", _playerIndex]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                });
            }
            break;
        }
        case BluetoothCommandNegotiateConfirm:
        {
            NSInteger otherPlayer = [[dict objectForKey:@"playerIndex"] intValue];
            _playerIndex = 1 - otherPlayer;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Player Index"
                                                                message:[NSString stringWithFormat:@"Peer confirmed my timestamp won, setting my index to %i", _playerIndex]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            });
            
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bluetoothDataReceived" object:dict];
}


@end
