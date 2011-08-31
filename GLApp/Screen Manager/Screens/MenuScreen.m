//
//  MenuScreen.m
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "MenuScreen.h"
#import "Sprite.h"
#import "SpriteFont.h"

@implementation MenuScreen

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
    
    [self loadShaders];
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
    
    glUniform2f(uniforms[UNIFORM_SCALE], 2.0f, 2.0f);
    glUniform2f(uniforms[UNIFORM_TRANSLATE], 100.0f, 100.0f);
    
    [mSprite DrawSpriteES2WithTexture:ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    
    glUniform2f(uniforms[UNIFORM_SCALE], 1.0f, 1.0f);
    glUniform2f(uniforms[UNIFORM_TRANSLATE], 0.0f, 0.0f); 
    
    [mSpriteFont DrawFontES2: uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    
    // Validate program before drawing. This is a good check, but only really necessary in a debug build.
    // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
    if (![self validateProgram:program]) {
        NSLog(@"Failed to validate program: %d", program);
        return;
    }
#endif
}

@end
