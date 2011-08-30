//
//  GameplayScreen.m
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayScreen.h"



@implementation GameplayScreen

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        mSprite = [[Sprite alloc]init:@"Sprite.png"];
        
        mSpriteFont = [[SpriteFont alloc] init:@"Hello. World"];
        
        [self loadShaders];

    }
    
    return self;
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
    
    NSString* testNSString;
    static int testInt = 0;
    testInt++;
    testNSString = [[NSString alloc]initWithFormat:@"HELLO DAVE. %d", testInt];
    //testNSString = [[NSString alloc]initWithFormat:@"%d %d %d %d", [[mEnemies objectAtIndex:0] hasBeenHit], [[mEnemies objectAtIndex:1] hasBeenHit], [[mEnemies objectAtIndex:2] hasBeenHit], [[mEnemies objectAtIndex:3] hasBeenHit]];                                    
    
    glUniform2f(uniforms[UNIFORM_SCALE], 1.0f, 1.0f);
    //[mSpriteFont DrawFontES2: uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    [mSpriteFont DrawFontES2: testNSString: uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
    
    [testNSString release];
    
}

-(void)dealloc
{
    [mSprite release];
    [mSpriteFont release];
    
    [super dealloc];
}


@end
