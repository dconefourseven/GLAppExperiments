//
//  GameplayScreen.m
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "GameplayScreen.h"
#import "Sprite.h"
#import "SpriteFont.h"

#import "EAGLView.h"

#import "ScreenManager.h"

@implementation GameplayScreen

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
    
    mSpriteFont = [[SpriteFont alloc] init:@"Hello. World"];
    
    [self loadShaders];
}

NSString* testNSString;
static int testInt = 0;

-(void)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    testInt += 1000;
}

-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    
}


-(void)Update
{
    
    testInt++;
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
    //glUniform2f(uniforms[UNIFORM_TRANSLATE], 10.0f, 10.0f);    
    
    testNSString = [[NSString alloc]initWithFormat:@"HELLO DAVE. %d", testInt];
    //testNSString = [[NSString alloc]initWithFormat:@"%d %d %d %d", [[mEnemies objectAtIndex:0] hasBeenHit], [[mEnemies objectAtIndex:1] hasBeenHit], [[mEnemies objectAtIndex:2] hasBeenHit], [[mEnemies objectAtIndex:3] hasBeenHit]];                                    
    
    glUniform2f(uniforms[UNIFORM_SCALE], 1.0f, 1.0f);
    //[mSpriteFont DrawFontES2: uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    [mSpriteFont DrawFontES2: testNSString: CGPointMake(10.0f, 10.0f): uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    
    [testNSString release];
    
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
    [mSprite release];
    [mSpriteFont release];
    
    glDeleteProgram(program);
    
    [super dealloc];
}


@end
