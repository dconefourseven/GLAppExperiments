//
//  SpriteFont.h
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class Sprite;

@interface SpriteFont : NSObject 
{
    NSString* mStringText;
    NSMutableArray* mSprites;
    
    GLuint mSpriteTexture;
    
    const NSDictionary* mCharacterMapDictionary;
}

-(id)init;
-(id)init: (const NSString*) stringText;

-(void)InitialiseSprites;

-(void) InitTexture: (NSString* const) textureName;

-(void)DrawFont;
-(void)DrawFont:(const NSString*) newText;
-(void)DrawFontES2:(int)UniformTranslate: (int)VertexAttribute: (int)TexCoordAttribute: (int)UniformSampler;
-(void)DrawFontES2:(const NSString*) newText:(int)UniformTranslate: (int)VertexAttribute: (int)TexCoordAttribute: (int)UniformSampler;

-(void)dealloc;

@end







