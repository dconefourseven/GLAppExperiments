//
//  Enemy.m
//  GLApp
//
//  Created by David Clarke on 27/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

@synthesize mPosition;
@synthesize hasBeenHit;
@synthesize mSprite;

- (id)init
{
    srand(time(NULL));
    self = [super init];
    if (self) {
        // Initialization code here.
        mSprite = [[Sprite alloc]init:@"Sprite.png"];
        [self Reset];
    }
    
    return self;
}

-(void)Reset
{    
    mPosition.x = (rand() % 440) + 20;
    mPosition.y = (rand() % 280) + 20;
    
    hasBeenHit = false;
}

-(void)Update
{
    
}

-(void)Draw
{
    
}

-(void)DrawES2:(int)VertexAttribute :(int) TexCoordAttribute:(int) UniformSampler
{
    [mSprite DrawSpriteES2WithTexture:VertexAttribute:TexCoordAttribute:UniformSampler];
}

-(void) dealloc
{
    hasBeenHit = false;
    [mSprite release];
    
    [super dealloc];
}

@end
