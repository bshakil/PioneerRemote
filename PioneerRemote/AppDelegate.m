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
    [self updateUserInterface];
    [self QueryVolume];
    NSData *dataR = [[NSUserDefaults standardUserDefaults] objectForKey:@"RokuIP"];
    NSString  *RokuIP = [NSKeyedUnarchiver unarchiveObjectWithData:dataR];
    NSData *dataP = [[NSUserDefaults standardUserDefaults] objectForKey:@"PioneerIP"];
    NSString  *PioneerIP = [NSKeyedUnarchiver unarchiveObjectWithData:dataP];
    self.hostAddress.stringValue=PioneerIP;
    self.rokuAddress.stringValue=RokuIP;
    
    
    
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    NSString *RokuIP=self.rokuAddress.stringValue;
    NSString *PioneerIP=self.hostAddress.stringValue;
    NSData *dataR = [NSKeyedArchiver archivedDataWithRootObject:RokuIP];
    NSData *dataP = [NSKeyedArchiver archivedDataWithRootObject:PioneerIP];

    [[NSUserDefaults standardUserDefaults] setObject:dataR forKey:@"RokuIP"];
    [[NSUserDefaults standardUserDefaults] setObject:dataP forKey:@"PioneerIP"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
- (IBAction)RokuUp:(id)sender {
    
    [self RokuSendDown:@"up"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"up"];
}

- (IBAction)RokuDown:(id)sender {
    [self RokuSendDown:@"down"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"down"];
}

- (IBAction)RokuRight:(id)sender {
    [self RokuSendDown:@"right"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"right"];
}

- (IBAction)RokuLeft:(id)sender {
    [self RokuSendDown:@"left"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"left"];
}

- (IBAction)RokuOK:(id)sender {
    [self RokuSendDown:@"select"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"select"];
}


- (IBAction)RokuPlay:(id)sender {
    [self RokuSendDown:@"play"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"play"];
}

- (IBAction)RokuFwd:(id)sender {
    [self RokuSendDown:@"fwd"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"fwd"];
}

- (IBAction)RokuRev:(id)sender {
    [self RokuSendDown:@"rev"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"rev"];
}

- (IBAction)RokuBack:(id)sender {
    [self RokuSendDown:@"back"];
    [NSThread sleepForTimeInterval:0.1];
    [self RokuSendUp:@"back"];
}

- (IBAction)RokuHome:(id)sender {
    [self RokuSendDown:@"home"];
    [self RokuSendUp:@"home"];
}
//-(void)RokuSendDown:(NSString *)RokuCommand {
//    NSString *RokuIP=self.rokuAddress.stringValue;
//    NSTask *task = [[NSTask alloc] init];
//    [task setLaunchPath:@"/usr/bin/curl"];
//    NSString *URL1=[NSString stringWithFormat:@"http://%@:8060/keydown/%@",RokuIP,RokuCommand];
//    NSArray *arguments = [NSArray arrayWithObjects:@"-d", @"",URL1, nil];
//    [task setArguments:arguments];
//    [task launch];
//}
//-(void)RokuSendUp:(NSString *)RokuCommand {
//    NSString *RokuIP=self.rokuAddress.stringValue;
//    NSTask *task = [[NSTask alloc] init];
//    [task setLaunchPath:@"/usr/bin/curl"];
//    NSString *URL1=[NSString stringWithFormat:@"http://%@:8060/keyup/%@",RokuIP,RokuCommand];
//    NSArray *arguments = [NSArray arrayWithObjects:@"-d", @"",URL1, nil];
//    [task setArguments:arguments];
//    [task launch];
//}
-(void)RokuSendDown:(NSString *)RokuCommand {
    
    NSString *RokuIP=self.rokuAddress.stringValue;
    NSString *URL1=[NSString stringWithFormat:@"http://%@:8060/keydown/%@",RokuIP,RokuCommand];
    NSMutableURLRequest *postRequestdown = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL1]];
        [postRequestdown setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [postRequestdown setHTTPMethod:@"POST"];
          postRequestdown.timeoutInterval = 1;
    NSURLConnection *theConnectiondown=[[NSURLConnection alloc] initWithRequest:postRequestdown delegate:self];
    if(theConnectiondown)
    {
        //[theConnectiondown cancel];
    }
}


-(void)RokuSendUp:(NSString *)RokuCommand {
    
    NSString *RokuIP=self.rokuAddress.stringValue;
    NSString *URL2=[NSString stringWithFormat:@"http://%@:8060/keyup/%@",RokuIP,RokuCommand];
    NSMutableURLRequest *postRequestup = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL2]];
    [postRequestup setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequestup setHTTPMethod:@"POST"];
    postRequestup.timeoutInterval = 1;
    NSURLConnection *theConnectionup=[[NSURLConnection alloc] initWithRequest:postRequestup delegate:self];
    if(theConnectionup)
    {
        //[theConnectionup cancel];
    }
}

-(void)RokuSendKeyboard:(NSString *)RokuKeys {
    
    NSString *RokuIP=self.rokuAddress.stringValue;
    NSString *URL2=[NSString stringWithFormat:@"http://%@:8060/keypress/Lit_",RokuIP];
    char Character='a';
    

    
        for (int i = 0; i < [RokuKeys length]; i++)
        {
            [NSThread sleepForTimeInterval:0.05];
            Character=[RokuKeys characterAtIndex:i];
            URL2=[NSString stringWithFormat:@"http://%@:8060/keypress/Lit_%c",RokuIP,Character];
            NSMutableURLRequest *postRequestup = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL2]];
            [postRequestup setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [postRequestup setHTTPMethod:@"POST"];
            NSURLConnection *theConnectionup=[[NSURLConnection alloc] initWithRequest:postRequestup delegate:self];
            if(theConnectionup)
            {
                //[theConnectionup cancel];
            }
        }
}
- (IBAction)RokuBackKeyboard:(id)sender {
    NSString *RokuIP=self.rokuAddress.stringValue;
    NSString *URL2=[NSString stringWithFormat:@"http://%@:8060/keypress/Backspace",RokuIP];
    NSMutableURLRequest *postRequestup = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL2]];
    [postRequestup setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequestup setHTTPMethod:@"POST"];
    postRequestup.timeoutInterval = 1;
    NSURLConnection *theConnectionup=[[NSURLConnection alloc] initWithRequest:postRequestup delegate:self];
}

- (IBAction)RokuKeyboard:(id)sender {
    NSString *RokuKeys=self.RokuKeyboard.stringValue;
    [self RokuSendKeyboard:RokuKeys];
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

- (IBAction)pUp:(id)sender {
    NSString *welcomeMsg = @"CUP\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}

- (IBAction)pDown:(id)sender {
    NSString *welcomeMsg = @"CDN\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}

- (IBAction)pRight:(id)sender {
    NSString *welcomeMsg = @"CRI\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}

- (IBAction)pLeft:(id)sender {
    NSString *welcomeMsg = @"CLE\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}

- (IBAction)pOk:(id)sender {
    NSString *welcomeMsg = @"CEN\r";
    NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    [asyncSocket writeData:welcomeData withTimeout:-1 tag:0];
}
- (IBAction)pHomeMenu:(id)sender {
    NSString *welcomeMsg = @"HM\r";
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
    [self connectReceiver];
    [self updateUserInterface];
    [self QueryVolume];
    
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
    if([self.connectButton.title isEqual:@"Connect"])
    {
        if (![asyncSocket connectToHost:host onPort:port error:&error])
        {
        [self.connectStatus setStringValue:@"Error"];
        [asyncSocket disconnect];
        
        }
    }
    if([self.connectButton.title isEqual:@"Disconnect"])
    {
            [asyncSocket disconnect];
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
    [self.connectButton setTitle:@"Connect"];

}

@end
