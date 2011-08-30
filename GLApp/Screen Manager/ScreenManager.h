//
//  ScreenManager.h
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenManager : NSObject
{
    NSMutableArray* mScreenQueue;
}

-(void)AddScreen;
-(void)RemoveScreen;
-(void)Update;
-(void)Draw;

@end
