//
//  ScreenManager.h
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScreen.h"

@interface ScreenManager : NSObject
{
    NSMutableArray* mScreenQueue;
}

-(void)AddScreen:(GameScreen*) screen;
-(void)RemoveScreen;
-(void)Update;
-(void)Draw;

-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view;
-(void)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view;

-(void)dealloc;

@end
