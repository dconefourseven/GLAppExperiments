//
//  GLAppViewController.h
//  GLApp
//
//  Created by David Clarke on 05/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "Sprites/Sprite.h"

@interface GLAppViewController : UIViewController<UIAccelerometerDelegate> {
    EAGLContext *context;
    GLuint program;
    
    BOOL animating;
    NSInteger animationFrameInterval;
    id displayLink;	
    
    UIAccelerometer* accelerometer;
    
    BOOL displayLinkSupported;
    
    Sprite* mSprite;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

@end
