//
//  AudioWrapper.h
//  GLApp
//
//  Created by David Clarke on 27/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface Audio : NSObject<AVAudioSessionDelegate>
{
    AVAudioSession *audioSession;
    AVAudioPlayer *audioPlayer;
}

- (void)beginInterruption;
- (void)endInterruption;
- (void)endInterruptionWithFlags:(NSUInteger)flags;
- (void)inputIsAvailableChanged:(BOOL)isInputAvailable;

-(void)release;

@end
