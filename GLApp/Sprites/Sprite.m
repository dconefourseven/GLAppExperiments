//
//  Sprite.m
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self InitSprite];
    }
    
    return self;
}

- (id)init : (NSString* const) textureName
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self InitSprite:textureName];
    }
    
    return self;
}

- (id)init : (NSString* const) textureName : (GLfloat[8]) texCoords
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self InitSprite:textureName:texCoords];
    }
    
    return self;
}

- (void) InitSprite
{
    static const GLfloat s_squareVertices[] = { 
        -10.0f, -10.0f, 
        10.0f, -10.0f, 
        -10.0f, 10.0f, 
        10.0f,  10.0f,
    };
    
    static const GLubyte s_squareColors[] = {
        255, 0, 0, 0,
        255, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
    };
    
    squareColors = s_squareColors;
    squareVertices = s_squareVertices;
    
}

- (void) InitSprite: (NSString* const) textureName
{
    [self InitTexture:textureName];
    
    static const GLfloat s_squareVertices[] = { 
        -10.0f, -10.0f, 
        10.0f, -10.0f, 
        -10.0f, 10.0f, 
        10.0f,  10.0f,
    };
        
    // Sets up an array of values for the texture coordinates.
    static const GLfloat s_spriteTexcoords[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    spriteTextureCoordinatesF = (GLfloat*)s_spriteTexcoords;
    
    squareVertices = s_squareVertices;
    
}

-(void) InitSprite: (NSString* const) textureName: (GLfloat[8]) texCoords
{
    [self InitTexture:textureName];
    
    static const GLfloat s_squareVertices[] = { 
        -10.0f, -10.0f, 
        10.0f, -10.0f, 
        -10.0f, 10.0f, 
        10.0f,  10.0f,
    };
    
    for(int i = 0; i < 8; i++)
    {
        spriteTexCoords[i] = texCoords[i];
    }
    
    squareVertices = s_squareVertices;
}

- (void) DrawSprite
{
    glBindTexture(GL_TEXTURE_2D, spriteTexture);
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    
    if(spriteTexture)
    {
        if(spriteTextureCoordinatesF == nil)
            glTexCoordPointer(2, GL_FLOAT, 0, spriteTexCoords); 
        else
            glTexCoordPointer(2, GL_FLOAT, 0, spriteTextureCoordinatesF);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    else
    {
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glEnableClientState(GL_COLOR_ARRAY);
    }
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void) InitTexture : (NSString* const) textureName
{
    CGImageRef spriteImage;
    CGContextRef spriteContext;
    GLubyte *spriteData;
	size_t	width, height;
    
    // Creates a Core Graphics image from an image file
	spriteImage = [UIImage imageNamed:textureName].CGImage;
	// Get the width and height of the image
	width = CGImageGetWidth(spriteImage);
	height = CGImageGetHeight(spriteImage);
	// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
	// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
    
	if(spriteImage) {
		// Allocated memory needed for the bitmap context
		spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
		// Uses the bitmap creation function provided by the Core Graphics framework. 
		spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the sprite image to the context.
		CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), spriteImage);
		// You don't need the context at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(spriteContext);
		
		// Use OpenGL ES to generate a name for the texture.
		glGenTextures(1, &spriteTexture);
		// Bind the texture name. 
		glBindTexture(GL_TEXTURE_2D, spriteTexture);
		// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		// Specify a 2D texture image, providing the a pointer to the image data in memory
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
		// Release the image data
		free(spriteData);
		
		// Enable use of the texture
		glEnable(GL_TEXTURE_2D);
		// Set a blending function to use
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		// Enable blending
		glEnable(GL_BLEND);
    }
}

@end
