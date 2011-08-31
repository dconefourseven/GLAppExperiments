//
//  MenuScreen.h
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScreen.h"

@class Sprite;

@interface MenuScreen : GameScreen
{
    Sprite* mSprite;
}

-(void)LoadContent;
-(void)Update;
-(void)Draw;

@end
