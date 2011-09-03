//
//  MainMenuScreen.m
//  GLApp
//
//  Created by David Clarke on 02/09/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "OptionsMenuScreen.h"

#import "ScreenManager.h"
#import "MainMenuScreen.h"
#import "Sprite.h"
#import "SpriteFont.h"

#import "GLButton.h"

@implementation OptionsMenuScreen

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)LoadContent
{
    mDifficultyButton = [[GLButton alloc]initWithData:CGPointMake(100.0f, 100.0f) :@"difficultyTapped": @"Sprite.png": @"Difficulty"];
    
    mBackButton = [[GLButton alloc]initWithData:CGPointMake(100.0f, 150.0f) :@"backButtonTapped": @"Sprite.png": @"Back"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(difficultyTappedHandler:) name:@"difficultyTapped" object:nil ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backTappedHandler:) name:@"backButtonTapped" object:nil ];
    
    [self loadShaders];
}

-(void)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    if(![mDifficultyButton touchesBeganWithEvent:touches withEvent:event :view])
    {
        [mBackButton touchesBeganWithEvent:touches withEvent:event :view];
    }
}

-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    
}

-(void)difficultyTappedHandler: (NSNotification *) notification
{
    if([notification.name isEqualToString:@"difficultyTapped"])
    {
        NSLog(@"Difficulty tapped event triggered");
        //[mScreenManager RemoveScreen];
        //[mScreenManager AddScreen:[[GameplayScreen alloc]init]];
    }
}

-(void)backTappedHandler: (NSNotification *) notification
{
    if([notification.name isEqualToString:@"backButtonTapped"])
    {
        NSLog(@"back tapped event triggered");
        [mScreenManager RemoveScreen];
        [mScreenManager AddScreen:[[MainMenuScreen alloc]init]];
    }
}

-(void)Update
{
    [mDifficultyButton Update];
}

-(void)Draw
{
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Use shader program.
    glUseProgram(program);
    
    /*glUniform2f(uniforms[UNIFORM_SCALE], 2.0f, 2.0f);
     glUniform2f(uniforms[UNIFORM_TRANSLATE], 100.0f, 100.0f);
     
     [mSprite DrawSpriteES2WithTexture:ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
     
     glUniform2f(uniforms[UNIFORM_SCALE], 1.0f, 1.0f);
     glUniform2f(uniforms[UNIFORM_TRANSLATE], 100.0f, 0.0f); 
     
     [mSpriteFont DrawFontES2: @"DRAW ME": CGPointMake(100.0f, 0.0f): uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];*/
    
    [mDifficultyButton Draw:ATTRIB_VERTEX :ATTRIB_TEXTURE :uniforms[UNIFORM_SAMPLER] :uniforms[UNIFORM_TRANSLATE] :uniforms[UNIFORM_SCALE]];
    
    [mBackButton Draw:ATTRIB_VERTEX :ATTRIB_TEXTURE :uniforms[UNIFORM_SAMPLER] :uniforms[UNIFORM_TRANSLATE] :uniforms[UNIFORM_SCALE]];
    
    // Validate program before drawing. This is a good check, but only really necessary in a debug build.
    // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
    if (![self validateProgram:program]) {
        NSLog(@"Failed to validate program: %d", program);
        return;
    }
#endif
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    glDeleteProgram(program);
    
    [mDifficultyButton release];
    [mBackButton release];
    
    [super dealloc];
}

@end
