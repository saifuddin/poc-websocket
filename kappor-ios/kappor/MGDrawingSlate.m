//
//  MGDrawingSlate.m
//  MGDrawingSlate
//
//  Created by Mihir Garimella on 6/28/12.
//  Copyright (c) 2012 Mihir Garimella.
//  Licensed for use under the MIT License. See the license file included with this source code or visit http://opensource.org/licenses/MIT for more information.
//

#import "MGDrawingSlate.h"

#define ARC4RANDOM_MAX 0x100000000
#define RAND_0_1 ((double)arc4random() / ARC4RANDOM_MAX)

@implementation MGDrawingSlate

@synthesize delegate;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initializeSlate];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self initializeSlate];
    
    return self;
}

- (void)initializeSlate
{
    if (self) {
        //Initialize MGDrawingSlate and set default values
        self.backgroundColor = [UIColor whiteColor];
        drawingPath = [[UIBezierPath alloc]init];
        drawingPath.lineCapStyle = kCGLineCapRound;
        drawingPath.miterLimit = 0;
        drawingPath.lineWidth = 4; //Default line weight - change with changeLineWeightTo: method.
//        drawingColor = [UIColor blackColor]; //Default color - change with changeColorTo: method.
        drawingColor = [UIColor blackColor];
        
        //2nd one
        self.backgroundColor = [UIColor whiteColor];
        drawingPath2 = [[UIBezierPath alloc]init];
        drawingPath2.lineCapStyle = kCGLineCapRound;
        drawingPath2.miterLimit = 0;
        drawingPath2.lineWidth = 4; //Default line weight - change with changeLineWeightTo: method.
    }
}

#pragma mark - Customization Methods

//Call from view controller to change the line weight of the drawing path. Alternatively, just change [drawingSlate]->drawingPath.lineWidth.
- (void)changeLineWeightTo:(NSInteger)weight
{
    drawingPath.lineWidth = weight;
}

//Call from view controller to change the color of the drawing path. Alternatively, just change [drawingSlate]->drawingColor.
- (void)changeColorTo:(UIColor *)color
{
    drawingColor = color;
}

#pragma mark - Drawing Methods

- (void)drawRect:(CGRect)rect
{
    [drawingColor setStroke];
    [drawingPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    [drawingPath2 strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    [drawingPath moveToPoint:point];
    if ([delegate respondsToSelector:@selector(moveToPoint:)])
    {
        [delegate moveToPoint:point];
    }
}

- (void)addLineToPoint:(CGPoint)point
{
    [drawingPath2 addLineToPoint:point];
    [self setNeedsDisplay];
}

- (void)moveToPoint:(CGPoint)point
{
    [drawingPath2 moveToPoint:point];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    [drawingPath addLineToPoint:point];
    if ([delegate respondsToSelector:@selector(addLineToPoint:)])
    {
        [delegate addLineToPoint:point];
    }
    [self setNeedsDisplay];
}

@end
