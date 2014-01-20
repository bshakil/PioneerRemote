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
    NSColor *color = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [window setOpaque:NO];
    [window setBackgroundColor:color];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    Track *aTrack = [[Track alloc] init];
    [self connectReceiver];
    [self setTrack:aTrack];
    [self QueryVolume];
    [self updateUserInterface];
    [self QueryVolume];
    
}
- (IBAction)RokuUp:(id)sender {
    
    // In body data for the 'application/x-www-form-urlencoded' content type,
    // form fields are separated by an ampersand. Note the absence of a
    // leading ampersand.
    NSString *bodyData = @"";
    
    NSMutableURLRequest *postRequestdown = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.2.81:8060/keydown/up"]];
    NSMutableURLRequest *postRequestup = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.2.81:8060/keyup/up"]];
    // Set the request's content type to application/x-www-form-urlencoded
    [postRequestdown setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request a POST request and specify its body data
    [postRequestdown setHTTPMethod:@"POST"];
    [postRequestdown setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    [postRequestup setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request a POST request and specify its body data
    [postRequestup setHTTPMethod:@"POST"];
    [postRequestup setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    
    NSURLConnection *theConnectiondown=[[NSURLConnection alloc] initWithRequest:postRequestdown delegate:self];
    if (!theConnectiondown) {
    }
    NSURLConnection *theConnectionup=[[NSURLConnection alloc] initWithRequest:postRequestup delegate:self];
    if (!theConnectionup) {
        
    }
}

-(void)RokuSend:(NSString *)RokuCommand {
    
    
    NSString *bodyData = @"";
    
    NSMutableURLRequest *postRequestdown = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.2.81:8060/keydown/up"]];
    NSMutableURLRequest *postRequestup = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.2.81:8060/keyup/up"]];
    
    [postRequestdown setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    [postRequestdown setHTTPMethod:@"POST"];
    [postRequestdown setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    [postRequestup setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [postRequestup setHTTPMethod:@"POST"];
    [postRequestup setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    
    NSURLConnection *theConnectiondown=[[NSURLConnection alloc] initWithRequest:postRequestdown delegate:self];
    if (!theConnectiondown) {
    }
    NSURLConnection *theConnectionup=[[NSURLConnection alloc] initWithRequest:postRequestup delegate:self];
    if (!theConnectionup) {
        
    }

}


- (IBAction)PowerControl:(id)sender {
    NSString *welcomeMsg = @"?P\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    LastInstruction=welcomeMsg;
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
    [asyncSocket readDataWithTimeout:-1 tag:0];
    [self QueryVolume];

}

- (IBAction)SourceDVD:(id)sender {
    
    NSString *welcomeMsg = @"04FN\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
    
}

- (IBAction)SourceBD:(id)sender {
    NSString *welcomeMsg = @"25FN\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}

- (IBAction)SourceDVR:(id)sender {
    NSString *welcomeMsg = @"15FN\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}

- (IBAction)SourceHDMI1:(id)sender {
    NSString *welcomeMsg = @"19FN\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}

- (IBAction)SourceVideo1:(id)sender {
    NSString *welcomeMsg = @"10FN\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
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
    if ([LastInstruction isEqualToString:@"?P\r"])
    {
        if (([StaticPower isEqualToString:@"PWR0\r\n"]) || ([StaticPower isEqualToString:@"PWR1\r\n"])) {
            [self pwrOnOff];
            LastInstruction=@"";
            }
    }
    if ([StaticPower rangeOfString:@"VOL"].location == NSNotFound) {
        NSLog(@"sub string doesnt exist");
    }
    else
    {
        [self getIntFromString:StaticPower];
    }
    
    [asyncSocket readDataWithTimeout:-1 tag:0];
    

    
    
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

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
      [self.connectStatus setStringValue:@"Connected"];
      [self.connectButton setTitle:@"Disconnect"];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [self.connectStatus setStringValue:@"Disconnected"];
}

@end
