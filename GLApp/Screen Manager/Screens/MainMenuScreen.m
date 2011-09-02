//
//  MainMenuScreen.m
//  GLApp
//
//  Created by David Clarke on 02/09/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "MainMenuScreen.h"

#import "ScreenManager.h"
#import "GameplayScreen.h"
#import "OptionsMenuScreen.h"
#import "Sprite.h"
#import "SpriteFont.h"

#import "GLButton.h"

@implementation MainMenuScreen

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
    mPlayGameButton = [[GLButton alloc]initWithData:CGPointMake(100.0f, 100.0f): @"playGameTapped": @"Sprite.png": @"Play Game"];
    
    mOptionsButton = [[GLButton alloc]initWithData:CGPointMake(100.0f, 150.0f): @"optionsButtonTapped": @"Sprite.png": @"Options"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playGameTappedHandler:) name:@"playGameTapped" object:nil ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionsTappedHandler:) name:@"optionsButtonTapped" object:nil ];
    
    [self loadShaders];
}

-(void)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    if(![mPlayGameButton touchesBeganWithEvent:touches withEvent:event :view])
    {
        [mOptionsButton touchesBeganWithEvent:touches withEvent:event :view];
    }
}

-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    
}

-(void)playGameTappedHandler: (NSNotification *) notification
{
    if([notification.name isEqualToString:@"playGameTapped"])
    {
        NSLog(@"playGameTapped tapped event triggered");
        [mScreenManager RemoveScreen];
        [mScreenManager AddScreen:[[GameplayScreen alloc]init]];
    }
}

-(void)optionsTappedHandler: (NSNotification *) notification
{
    if([notification.name isEqualToString:@"optionsButtonTapped"])
    {
        NSLog(@"optionsButtonTapped tapped event triggered");
        [mScreenManager RemoveScreen];
        [mScreenManager AddScreen:[[OptionsMenuScreen alloc]init]];
    }
}

-(void)Update
{
}

-(void)Draw
{
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Use shader program.
    glUseProgram(program);
    
    [mPlayGameButton Draw:ATTRIB_VERTEX :ATTRIB_TEXTURE :uniforms[UNIFORM_SAMPLER] :uniforms[UNIFORM_TRANSLATE] :uniforms[UNIFORM_SCALE]];
    
    [mOptionsButton Draw:ATTRIB_VERTEX :ATTRIB_TEXTURE :uniforms[UNIFORM_SAMPLER] :uniforms[UNIFORM_TRANSLATE] :uniforms[UNIFORM_SCALE]];
    
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
    
    [mPlayGameButton release];
    [mOptionsButton release];
    
    glDeleteProgram(program);
    
    [super dealloc];
}

@end
