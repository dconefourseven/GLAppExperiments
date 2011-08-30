//
//  GameplayScreen.h
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScreen.h"
#import "Sprite.h"

@interface GameplayScreen : GameScreen
{
    Sprite* mSprite;
}

-(void)Update;
-(void)Draw;

@end
