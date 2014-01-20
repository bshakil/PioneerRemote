//
//  AppDelegate.h
//  PioneerRemote
//
//  Created by Burhan S Ahmed on 11/9/13.
//  Copyright (c) 2013 Burhan S Ahmed. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GCDAsyncSocket;
@class Track;

@interface AppDelegate : NSObject <NSApplicationDelegate>

{
@private
	GCDAsyncSocket *asyncSocket;
    NSString *StaticPower;
    float currentVolume;
    NSString *LastInstruction;
    NSWindow *__unsafe_unretained window;
    
}
@property (unsafe_unretained) IBOutlet NSWindow *window;
//@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSSlider *slider;
@property (strong) Track *track;


@property (weak) IBOutlet NSTextField *hostAddress;
@property (weak) IBOutlet NSTextField *hostPort;

@property (weak) IBOutlet NSTextField *connectStatus;
@property (weak) IBOutlet NSButton *connectButton;

- (IBAction)mute:(id)sender;
- (IBAction)takeFloatValueForVolumeFrom:(id)sender;
- (void)updateUserInterface;
- (void)QueryVolume;
- (void)connectReceiver;
- (void)pwrOnOff;
- (int)getIntFromString:(NSString *)originalString;
@end
