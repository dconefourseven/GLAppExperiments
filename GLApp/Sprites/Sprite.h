//
//  Sprite.h
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface Sprite : NSObject
{
    
    const GLfloat *squareVertices;
    const GLubyte *squareColors;
    GLfloat spriteTextureCoordinates[8];
    
    /* OpenGL name for the sprite texture */
    GLuint mSpriteTexture;   
    
    GLuint cubeVBO;
    GLuint cubeIBO;
}

-(id) init;
-(id) init:(NSString* const)textureName;
-(id) initWithTexture:(GLuint) spriteTexture: (GLfloat[8]) texCoords;

-(void) InitSprite;
-(void) InitSprite: (NSString* const) textureName;
-(void) InitSpriteWithTexture: (GLfloat[8]) texCoords;

-(void) DrawSprite;
-(void) DrawSpriteWithTexture;
-(void) DrawSpriteES2WithoutTexture: (int)VertexAttribute: (int)ColorAttribute;
-(void) DrawSpriteES2WithTexture: (int)VertexAttribute: (int)TexCoordAttribute: (int)UniformSampler;

-(void) InitTexture: (NSString* const) textureName;

-(void) DeleteBuffers;

-(void) dealloc;

@end
