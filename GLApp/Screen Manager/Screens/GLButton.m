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
    }
    
    return self;
}

-(void)touchesBeganWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    UITouch *myTouch = [[event allTouches] anyObject];
    
    CGPoint myPoint = [myTouch locationInView:view];
    
    if([self TouchedTest: myPoint: 10: 10: 10: 10 ])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonTapped" object:nil];
    }
}
-(void)touchesMovedWithEvent:(NSSet *)touches withEvent:(UIEvent *)event: (UIView*)view
{
    
}


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
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"buttonTapped" object:nil ];
}

-(void)Draw: (int)VertexAttribute: (int)TexCoordAttribute: (int)UniformSampler: (int)UniformTranslate: (int)UniformScale
{    
    glUniform2f(UniformScale, 2.0f, 2.0f);
    glUniform2f(UniformTranslate, mPosition.x, mPosition.y);
     
    [mSprite DrawSpriteES2WithTexture:VertexAttribute: TexCoordAttribute: UniformSampler];
     
    glUniform2f(UniformScale, 1.0f, 1.0f);
    glUniform2f(UniformTranslate, mPosition.x + 50.0f, mPosition.y); 
     
    [mSpriteFont DrawFontES2: mPosition: UniformTranslate: VertexAttribute: TexCoordAttribute: UniformSampler];
}

-(void)dealloc
{
    [mSprite release];
    [mSpriteFont release];
    
    [super dealloc];
}

@end
