//
//  GraphView.m
//  Calculator
//
//  Created by Adam Parrish on 1/26/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 0.90

-(CGFloat)scale
{
    if(!_scale)
    {
        return DEFAULT_SCALE;
    }
    else
    {
        return _scale;
    }
}

-(void) setScale:(CGFloat)scale
{
    if(scale != _scale)
    {
        _scale = scale;
        [self setNeedsDisplay];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width / 2;
    if( self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= self.scale;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:self.scale];
    
    //get left most x value
    CGPoint leftMostPoint;
    leftMostPoint.x = self.bounds.origin.x;
    
    //get right most x value
    CGPoint rightMostPoint;
    rightMostPoint.x = self.bounds.origin.x + self.bounds.size.width;
    
    double start = leftMostPoint.x;
    double end = rightMostPoint.x;

    double currentX = start;
    double currentY;
    
    double lastX;
    double lastY;
    
    CGContextSetLineWidth(context, 0.5);
    [[UIColor orangeColor] setStroke];
    
    NSLog(@"startX: %g", start);
    NSLog(@"end: %g", end);
    
    while (currentX <= end)
    {
        currentY = [self.dataSource yCoordinateForX:currentX];
        
        if( currentX != start )
        {
            //don't draw on the first run
            CGPoint last;
            last.x = lastX;
            last.y = lastY > 0 ? midPoint.y - lastY : midPoint.y + lastY;
            
            CGPoint current;
            current.x = currentX;
            current.y = currentY > 0 ? midPoint.y - currentY : midPoint.y + currentY;
            
            CGContextMoveToPoint(context, last.x, last.y);
            CGContextAddLineToPoint(context, current.x, current.y);
            CGContextStrokePath(context);
        }
        
        lastX = currentX;
        lastY = currentY;
        
        currentX++;
        
    }
    
    //iterate from left-x to right-x
    // for each x calculate y
    // draw line from last x,y to new x,y

    
    
}

@end
