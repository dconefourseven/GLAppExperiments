//
//  GLButton.m
//  GLApp
//
//  Created by David Clarke on 02/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GLButton.h"

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "Sprite.h"
#import "SpriteFont.h"

@implementation GLButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        mSprite = [[Sprite alloc]init:@"Sprite.png"];
        
        mSpriteFont = [[SpriteFont alloc]init:@"Play Game"];
        
        mPosition = CGPointMake(100.0f, 100.0f);
        
        mNotificationName = [[NSString alloc]initWithString:@"buttonTapped"];
    }
    
    return self;
}

-(id)initWithData:(const CGPoint) position: (const NSString*) notificationName: (const NSString*) spriteName: (const NSString*) buttonText
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        mSprite = [[Sprite alloc]init:(NSString*)spriteName];
        
        mSpriteFont = [[SpriteFont alloc]init:(NSString*)buttonText];
        
        mPosition = position;
        
        mNotificationName = [[NSString alloc]initWithString:(NSString*)notificationName];
    }
    
    return self;
}


-(BOOL)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    //Create a structure that countains the touch data
    UITouch *myTouch = [[event allTouches] anyObject];
    //Extract the location of the touch
    CGPoint myPoint = [myTouch locationInView:view];
    
    BOOL isTapped = [self TouchedTest: myPoint: 20: 20: 20: 20 ];
    
    //If the player touched the button send a message that the button was tapped
    if(isTapped)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:mNotificationName object:nil];
    }
    
    return isTapped;
}
-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    
}

//This test is performed to check if the user has touched the button or missed it
-(BOOL)TouchedTest:(const CGPoint) TouchCoordinates: (const float) TouchXScale: (const float) TouchYScale: (const float)ButtonXScale: (const float)ButtonYScale;
{     
    if(TouchCoordinates.x - (TouchXScale/2) > mPosition.x + (ButtonXScale/2))
        return NO;
    if(TouchCoordinates.x + (TouchXScale/2) < mPosition.x - (ButtonXScale/2))
        return NO;
    if(TouchCoordinates.y - (TouchYScale/2) > mPosition.y + (ButtonYScale/2))
        return NO;
    if(TouchCoordinates.y + (TouchYScale/2) < mPosition.y - (ButtonYScale/2))
        return NO;
    
    return YES;
}

-(void)Update
{
}

//Draw the button and its accompanying text to the screen
-(void)Draw: (int)VertexAttribute: (int)TexCoordAttribute: (int)UniformSampler: (int)UniformTranslate: (int)UniformScale
{    
    glUniform2f(UniformScale, 2.0f, 2.0f);
    glUniform2f(UniformTranslate, mPosition.x, mPosition.y);
     
    [mSprite DrawSpriteES2WithTexture:VertexAttribute: TexCoordAttribute: UniformSampler];
    
    CGPoint textPosition = CGPointMake(mPosition.x + 40.0f, mPosition.y);
    
    glUniform2f(UniformScale, 1.0f, 1.0f);
    //glUniform2f(UniformTranslate, textPosition.x + 20.0f , textPosition.y); 
     
    [mSpriteFont DrawFontES2: textPosition: UniformTranslate: VertexAttribute: TexCoordAttribute: UniformSampler];
}

//Deallocate the resources the button uses
-(void)dealloc
{
    [mSprite release];
    [mSpriteFont release];
    
    [mNotificationName release];
    
    [super dealloc];
}

@end
