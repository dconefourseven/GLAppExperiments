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
    
    CGPoint mPosition;
    
    NSString* mNotificationName;
}

-(id)init;
-(id)initWithData:(const CGPoint) position: (const NSString*) notificationName: (const NSString*) spriteName: (const NSString*) buttonText;

-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view;
-(BOOL)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view;

-(BOOL)TouchedTest:(const CGPoint) TouchCoordinates: (const float) TouchXScale: (const float) TouchYScale: (const float)ButtonXScale: (const float)ButtonYScale;

-(void)Update;
-(void)Draw: (int)VertexAttribute: (int)TexCoordAttribute: (int)UniformSampler: (int)UniformTranslate: (int)UniformScale;

-(void)dealloc;

@end
