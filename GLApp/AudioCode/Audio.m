//
//  AudioWrapper.m
//  GLApp
//
//  Created by David Clarke on 27/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Audio.h"

#import <AudioToolbox/AudioToolbox.h>

@implementation Audio

- (id)init
{
    self = [super init];
    if (self) {
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        
        UInt32 otherAudioIsPlaying = 0;                                   // 1
        UInt32 propertySize = sizeof (otherAudioIsPlaying);
        
        AudioSessionGetProperty (                                     // 2
                                 kAudioSessionProperty_OtherAudioIsPlaying,
                                 &propertySize,
                                 &otherAudioIsPlaying
                                 );
        
        
        audioSession = [AVAudioSession sharedInstance];
        NSError *errRet;
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:&errRet];
        [audioSession setActive:YES error:&errRet];
        
        audioSession.delegate = self;
        
        NSLog(@"\nOther audio is playing: %lu", otherAudioIsPlaying);
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sound.caf", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = -1;
        
        /*if (audioPlayer == nil)
         NSLog([error description]);
         else*/  
        if(!otherAudioIsPlaying)
            [audioPlayer play];
        
        [url release];
        [error release];
        [errRet release];
    }
    
    return self;
}

- (void)beginInterruption 
{
}

- (void)endInterruption 
{
}

- (void)endInterruptionWithFlags:(NSUInteger)flags 
{
}

- (void)inputIsAvailableChanged:(BOOL)isInputAvailable 
{
}

-(void)release
{
    [audioPlayer release];
    [audioSession release];
}

@end
