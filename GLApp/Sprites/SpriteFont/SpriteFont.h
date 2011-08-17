//
//  SpriteFont.h
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "../Sprite.h"

@interface SpriteFont : NSObject 
{
    NSString* mStringText;
    NSMutableArray* mSprites;
    
    GLuint mSpriteTexture;
}

-(id)init;
-(id)init: (const NSString*) stringText;

-(void)AppendToEndOfString:(const NSString*) stringText;
-(void)ReplaceStringText:(const NSString*) stringText;
-(void)InitialiseSprites;

-(void) InitTexture: (NSString* const) textureName;

-(void)DrawFont;
-(void)DrawFont:(const NSString*) newText;

-(id)release;

@end







