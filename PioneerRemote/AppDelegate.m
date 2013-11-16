//
//  AppDelegate.m
//  PioneerRemote
//
//  Created by Burhan S Ahmed on 11/9/13.
//  Copyright (c) 2013 Burhan S Ahmed. All rights reserved.
//

#import "AppDelegate.h"
#import "Track.h"
#import "GCDAsyncSocket.h"

@implementation AppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    Track *aTrack = [[Track alloc] init];
    [self setTrack:aTrack];
    [self QueryVolume];
    [self updateUserInterface];
    [self connectReceiver];
    [self.connectButton setTitle:@"Disconnect"];
    [self QueryVolume];
    
    
}
- (IBAction)PowerControl:(id)sender {
    NSString *welcomeMsg = @"?P\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
    [asyncSocket readDataWithTimeout:-1 tag:0];

}

- (IBAction)mute:(id)sender {
    [self.track setVolume:0.0];
    [self updateUserInterface];
    NSLog(@"received a mute: message");
    //NSlog(@"Starting TLS with settings:");
    NSString *welcomeMsg = @"MZ\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
    

}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"didReadData: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    StaticPower=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (([StaticPower isEqualToString:@"PWR0\r\n"]) || ([StaticPower isEqualToString:@"PWR1\r\n"])) {
    [self pwrOnOff];
    }
    if ([StaticPower rangeOfString:@"VOL"].location == NSNotFound) {
        NSLog(@"sub string doesnt exist");
    }
    else
    {
        [self getIntFromString:StaticPower];
    }
    

}
- (IBAction)ConnectRemote:(id)sender {
    
}

- (IBAction)SourceSelector:(id)sender {
    NSString *welcomeMsg = @"FU\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}



- (IBAction)takeFloatValueForVolumeFrom:(id)sender {

    
    float newValue = [sender floatValue];
    [self.track setVolume:newValue];
    [self updateUserInterface];
    
    
    int myInt = (int) newValue;
    NSString *intstring =  [@(myInt) description];
    NSString *strwithpadding = [NSString stringWithFormat:@"%03d", [intstring intValue]];
    NSString *welcomeMsg  = [strwithpadding stringByAppendingString:@"VL\r"];
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}
- (void)updateUserInterface {
    
    float volume = [self.track volume];
    [self.textField setFloatValue:volume];
    [self.slider setFloatValue:volume];
}

- (void)QueryVolume {
    
    //Query Volume
    NSString *welcomeMsg = @"?V\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
    [asyncSocket readDataWithTimeout:-1 tag:0];

    //float volume = [self.track volume];
    //[self.textField setFloatValue:volume];
    //[self.slider setFloatValue:volume];
}

- (void)connectReceiver {
    NSString *host = self.hostAddress.stringValue;
    int port = [self.hostPort.stringValue intValue];
    NSError *error = nil;
    if (![asyncSocket connectToHost:host onPort:port error:&error])
    {
        [self.connectStatus setStringValue:@"Error"];
        
    }
    else
    {
        [self.connectStatus setStringValue:@"Connected"];
    }
}
- (void)pwrOnOff {
    if ([StaticPower isEqualToString:@"PWR0\r\n"]){
        NSString *welcomeMsg = @"PF\r";
        NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
        [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
    }
    else
    {
        NSString *welcomeMsg = @"PO\r";
        NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
        [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
    }
}
- (int)getIntFromString:(NSString *)originalString {
    
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    // Result.
    int number = [numberString integerValue];
    currentVolume=number;
    [self.textField setFloatValue:currentVolume];
    [self.slider setFloatValue:currentVolume];
    return number;
}

@end
