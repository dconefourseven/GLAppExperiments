//
//  MenuScreen.h
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "GameScreen.h"

@class Sprite;
@class SpriteFont;

@interface MenuScreen : GameScreen
{
    Sprite* mSprite;
    
    SpriteFont* mSpriteFont;
}

-(void)LoadContent;
-(void)Update;
-(void)Draw;

@end
