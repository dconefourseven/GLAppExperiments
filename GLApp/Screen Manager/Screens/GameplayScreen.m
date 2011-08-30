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
    
}



@end
