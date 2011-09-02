//
//  GLButton.h
//  GLApp
//
//  Created by David Clarke on 02/09/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sprite;
@class SpriteFont;

@interface GLButton : NSObject
{
    Sprite* mSprite;
    SpriteFont* mSpriteFont;
}

-(void)Update;
-(void)Draw;



@end
