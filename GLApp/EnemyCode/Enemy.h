//
//  Enemy.h
//  GLApp
//
//  Created by David Clarke on 27/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

@interface Enemy : NSObject
{
    CGPoint mPosition;
    BOOL hasBeenHit;
    
    Sprite* mSprite;
}

@property CGPoint mPosition;
@property BOOL hasBeenHit;
@property (assign) Sprite* mSprite; 

-(void)Reset;

-(void)Update;
-(void)Draw;
-(void)DrawES2:(int)VertexAttribute :(int) TexCoordAttribute:(int) UniformSampler;

-(void)dealloc;

@end
