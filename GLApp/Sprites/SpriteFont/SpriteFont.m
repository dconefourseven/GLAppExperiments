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
        
        [self InitialiseSprites:stringText:sizeOfString];
        
    }
    
    return self;
}

-(void)AppendToEndOfString:(const NSString*) stringText
{
    
}

-(void)ReplaceStringText:(const NSString*) stringText
{
    
}

-(void)InitialiseSprites:(const NSString*)stringText: (int) stringSize
{
    // Sets up an array of values for the texture coordinates.
    static const GLfloat s_spriteTexcoords[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
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
                                @"62", @"+",
                                @"63", @"-",
                                nil];
    
    mSprites = [[NSMutableArray alloc]initWithCapacity:stringSize];
    
    for(int i = 0; i < stringSize; i++)
    {
        char characterAtIndex = [stringText characterAtIndex:(NSUInteger)i];
        NSString* charInString = [[NSString alloc]initWithCString:&characterAtIndex];
         
        NSString *positionInMap = [[NSString alloc]initWithString:[dictionary objectForKey:charInString]]; 
        
        int intPositionInMap = [positionInMap intValue];
        
        //Calculate the x position using the modulus of the position in the char map, divide by 8 because our tex is 8x8
        int xPositionIn2DMap = intPositionInMap % 8;
        int yPositionIn2DMap = intPositionInMap / 8;
        
        
        
        Sprite* sprite = [[Sprite alloc]init:@"SpriteSheet.jpg":(GLfloat*)s_spriteTexcoords];
        
        [mSprites addObject:sprite];
        
        [sprite release];
    }
    
    [dictionary release];
    [mSprites release];
}

-(void)DrawFont
{
    
}

@end