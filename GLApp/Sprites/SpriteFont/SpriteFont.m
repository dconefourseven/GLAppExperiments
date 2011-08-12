//
//  SpriteFont.m
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import "SpriteFont.h"

@implementation SpriteFont

static const char charMap[] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', 'A', 'A',
};

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
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
        
        mStringText = [[NSString alloc]initWithString:(NSString*)stringText];
        
        [self InitialiseSprites:sizeOfString];
        
    }
    
    return self;
}

-(void)AppendToEndOfString:(const NSString*) stringText
{
    
}

-(void)ReplaceStringText:(const NSString*) stringText
{
    
}

-(void)InitialiseSprites:(int) stringSize
{
    // Sets up an array of values for the texture coordinates.
    static const GLfloat s_spriteTexcoords[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    mSprites = [[NSMutableArray alloc]initWithCapacity:stringSize];
    
    for(int i = 0; i < stringSize; i++)
    {
        Sprite* sprite = [[Sprite alloc]init:@"SpriteSheet.jpg":(GLfloat*)s_spriteTexcoords];
        
        [mSprites addObject:sprite];
        
        [sprite release];
    }
}

-(void)DrawFont
{
    
}

@end