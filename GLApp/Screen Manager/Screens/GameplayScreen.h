//
//  GameplayScreen.h
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScreen.h"
#import "Sprite.h"
#import "SpriteFont.h"

@interface GameplayScreen : GameScreen
{
    Sprite* mSprite;
    SpriteFont* mSpriteFont;
}

-(void)Update;
-(void)Draw;

-(void)dealloc;

@end
