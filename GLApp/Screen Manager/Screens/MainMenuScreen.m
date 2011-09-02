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
    mSprite = [[Sprite alloc]init:@"Sprite.png"];
    
    mSpriteFont = [[SpriteFont alloc] init:@"MAIN MENU"];
    
    mPlayGameButton = [[GLButton alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventHandler:) name:@"buttonTapped" object:nil ];
    
    [self loadShaders];
}

-(void)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    [mScreenManager RemoveScreen];
    [mScreenManager AddScreen:[[GameplayScreen alloc]init]];
}

-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    
}

-(void)eventHandler: (NSNotification *) notification
{
    if([notification.name isEqualToString:@"buttonTapped"])
        NSLog(@"Button tapped event triggered");
}

-(void)Update
{
    [mPlayGameButton Update];
}

-(void)Draw
{
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Use shader program.
    glUseProgram(program);
    
    glUniform2f(uniforms[UNIFORM_SCALE], 2.0f, 2.0f);
    glUniform2f(uniforms[UNIFORM_TRANSLATE], 100.0f, 100.0f);
    
    [mSprite DrawSpriteES2WithTexture:ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    
    glUniform2f(uniforms[UNIFORM_SCALE], 1.0f, 1.0f);
    glUniform2f(uniforms[UNIFORM_TRANSLATE], 100.0f, 0.0f); 
    
    [mSpriteFont DrawFontES2: @"DRAW ME": uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    
    //[mPlayGameButton Draw:ATTRIB_VERTEX :ATTRIB_TEXTURE :uniforms[UNIFORM_SAMPLER] :uniforms[UNIFORM_TRANSLATE] :uniforms[UNIFORM_SCALE]];
    
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
    [mSpriteFont release];
    [mSprite release];
    
    [mPlayGameButton release];
    
    [super dealloc];
}

@end
