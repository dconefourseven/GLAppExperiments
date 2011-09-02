//
//  GLButton.m
//  GLApp
//
//  Created by David Clarke on 02/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GLButton.h"

@implementation GLButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)Update
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"buttonTapped"
     object:nil ];
}

-(void)Draw
{
    
}

@end
