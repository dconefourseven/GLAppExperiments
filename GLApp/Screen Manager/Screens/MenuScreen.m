//
//  MenuScreen.m
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "MenuScreen.h"
#import "GameplayScreen.h"
#import "Sprite.h"
#import "SpriteFont.h"

#import "ScreenManager.h"

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

-(void)Update
{
    
}

-(void)Draw
{
    
}

-(void)dealloc
{
    
    [super dealloc];
}

@end
