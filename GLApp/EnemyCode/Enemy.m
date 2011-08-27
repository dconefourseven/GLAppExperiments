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
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
