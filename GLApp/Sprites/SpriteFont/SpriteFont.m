//
//  SpriteFont.m
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#define LETTERWIDTH  0.125
#define LETTERHEIGHT 0.125

#import "SpriteFont.h"

@implementation SpriteFont

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        mSpriteTexture = 0;
    }
    
    return self;
}

-(id)init: (const NSString*) stringText
{
    self = [super init];
    if (self) {
        // Initialization code here.
        int sizeOfString = stringText.length;
        
        if(sizeOfString == 0)
            return NO;
        
        mSpriteTexture = 0;
        
        mStringText = [[NSString alloc]initWithString:(NSString*)stringText];
        
        [self InitialiseSprites];
        
    }
    
    return self;
}

-(void)AppendToEndOfString:(const NSString*) stringText
{
    
}

-(void)ReplaceStringText:(const NSString*) stringText
{
    
}

-(void)InitialiseSprites
{    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"0", @"A",
                                @"1", @"B",
                                @"2", @"C",
                                @"3", @"D",
                                @"4", @"E",
                                @"5", @"F",
                                @"6", @"G",
                                @"7", @"H",
                                @"8", @"I",
                                @"9", @"J",
                                @"10", @"K",
                                @"11", @"L",
                                @"12", @"M",
                                @"13", @"N",
                                @"14", @"O",
                                @"15", @"P",
                                @"16", @"Q",
                                @"17", @"R",
                                @"18", @"S",
                                @"19", @"T",
                                @"20", @"U",
                                @"21", @"V",
                                @"22", @"W",
                                @"23", @"X",
                                @"24", @"Y",
                                @"25", @"Z",
                                @"26", @"a",
                                @"27", @"b",
                                @"28", @"c",
                                @"29", @"d",
                                @"30", @"e",
                                @"31", @"f",
                                @"32", @"g",
                                @"33", @"h",
                                @"34", @"i",
                                @"35", @"j",
                                @"36", @"k",
                                @"37", @"l",
                                @"38", @"m",
                                @"39", @"n",
                                @"40", @"o",
                                @"41", @"p",
                                @"42", @"q",
                                @"43", @"r",
                                @"44", @"s",
                                @"45", @"t",
                                @"46", @"u",
                                @"47", @"v",
                                @"48", @"w",
                                @"49", @"x",
                                @"50", @"y",
                                @"51", @"z",
                                @"52", @"0",
                                @"53", @"1",
                                @"54", @"2",
                                @"55", @"3",
                                @"56", @"4",
                                @"57", @"5",
                                @"58", @"6",
                                @"59", @"7",
                                @"60", @"8",
                                @"61", @"9",
                                @"62", @" ",
                                @"63", @"-",
                                nil];
    
    //Create the sprites here as this is called from places other than "init"
    mSprites = [[NSMutableArray alloc]initWithCapacity:[mStringText length]];
    
    //Make sure to load the spritefont texture if it hasn't been loaded already
    if(mSpriteTexture == 0)
        //Load ONLY if it hasn't been loaded already. Do not waste resources
        [self InitTexture:@"SpriteSheet.png"];
    
    for(int i = 0; i < [mStringText length]; i++)
    {
        //Get the character at the current index in the string
        char characterAtIndex = [mStringText characterAtIndex:(NSUInteger)i];
        //Convert it to an NSString so it is usable
        NSString* charInString = [[NSString alloc]initWithFormat:@"%C", characterAtIndex];
         
        //Find it's position in the char map dictionary
        NSString *positionInMap = [[NSString alloc]initWithString:[dictionary objectForKey:charInString]]; 
        
        //Convert that data into an index
        int intPositionInMap = [positionInMap intValue];
        
        //Calculate the x position using the modulus of the position in the char map, divide by 8 because our tex is 8x8
        int xPositionIn2DMap = intPositionInMap % 8;
        int yPositionIn2DMap = intPositionInMap / 8;
        
        //Work out the texture co-ordinates for each letter in the spritefont texture
        GLfloat texCoords[] = {
            LETTERWIDTH * xPositionIn2DMap,                 LETTERHEIGHT * yPositionIn2DMap,
            (LETTERWIDTH * xPositionIn2DMap) + LETTERWIDTH, LETTERHEIGHT * yPositionIn2DMap,
            LETTERWIDTH * xPositionIn2DMap,                 (LETTERHEIGHT * yPositionIn2DMap) + LETTERHEIGHT,
            (LETTERWIDTH * xPositionIn2DMap) + LETTERWIDTH, (LETTERHEIGHT * yPositionIn2DMap) + LETTERHEIGHT,
        };
        
        //Create the sprite
        Sprite* sprite = [[Sprite alloc]initWithTexture:mSpriteTexture :texCoords];
        
        //Add it onto the mutable array
        [mSprites addObject:sprite];
        
        //Clean up after ourselves, these temp objects should not be seen outside of this function
        [sprite release];
        [charInString release];
        [positionInMap release];
        characterAtIndex = 0;
        intPositionInMap = 0;
        xPositionIn2DMap = 0;
        yPositionIn2DMap = 0;
    }
    
    //Release the dictionary as we don't need it outside of this function
    [dictionary release];
}

-(void)DrawFont
{
    //Loop through all the sprites and draw them
    for(int i = 0; i < [mStringText length]; i++)
    {
        glPushMatrix();
    
        glTranslatef(200 + ( i * 20) , 200, 0.0f);     
    
        [[mSprites objectAtIndex:(NSInteger)i] DrawSprite];
        
        glPopMatrix();
    }    
}

-(void)DrawFont:(const NSString*) newText
{
    //If the string has changed, something needs to be done
    if(![newText isEqualToString:mStringText])
    {
        //First thing's first, clear up after ourselves
        [mStringText release];
        [mSprites release];
        
        //Load the new string and initialise the sprites again
        mStringText = [[NSString alloc] initWithString:(NSString*)newText];
        [self InitialiseSprites];
    }
        
    //Loop through all the sprites and draw them
    for(int i = 0; i < [mStringText length]; i++)
    {
        glPushMatrix();
        
        glTranslatef(200 + ( i * 20) , 200, 0.0f);     
        
        [[mSprites objectAtIndex:(NSInteger)i] DrawSprite];
        
        glPopMatrix();
    }    
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
		glGenTextures(1, &mSpriteTexture);
		// Bind the texture name. 
		glBindTexture(GL_TEXTURE_2D, mSpriteTexture);
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

-(id)release
{
    [mStringText release];
    [mSprites release];
    
    mSpriteTexture = 0;
    
    return self;
}

@end