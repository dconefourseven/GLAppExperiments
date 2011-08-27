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
#import <AVFoundation/AVFoundation.h>

#import "Sprites/Sprite.h"
#import "SpriteFont.h"
#import "Audio.h"
#import "Enemy.h"

typedef struct EnemyPositions
{
    CGPoint points[4];
    BOOL hasBeenHit[4];
}EnemyPositions;

@interface GLAppViewController : UIViewController<UIAccelerometerDelegate> {
    EAGLContext *context;
    GLuint program;
    
    BOOL animating;
    NSInteger animationFrameInterval;
    id displayLink;	
    
    BOOL displayLinkSupported;
    
    Sprite* mSprite;
    
    SpriteFont* mSpriteFont;
    
    NSMutableArray* mEnemies;
    EnemyPositions* mEnemyPositions;
    
    Audio* mAudio;
    
    Enemy* mEnemy;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)ResetEnemies;

-(BOOL)TouchedEnemy:(const CGPoint) TouchCoordinates: (const float) XScale: (const float) YScale: 
    (const float)EnemyXPos: (const float)EnemyYPos: (const float)EnemyXScale: (const float)EnemyYScale;


@end
