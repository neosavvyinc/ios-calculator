//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Adam Parrish on 1/26/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface CalculatorGraphViewController() <GraphViewDataSource>

@property (weak, nonatomic) IBOutlet GraphView *graphView;


@end

@implementation CalculatorGraphViewController

@synthesize graphView = _graphView;
@synthesize equationDisplay = _equationDisplay;
@synthesize program = _program;

-(void) setProgram:(NSMutableArray *)program
{
    if( _program != program )
    {
        _program = program;
        [self.graphView setNeedsDisplay];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self equationDisplay].text = @"Adam was here";
}

-(double) yCoordinateForX:(double)x
{
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:x],@"x", nil];
        
    double result = [CalculatorBrain runProgram:self.program usingVariables:variables];
    
    NSLog(@"Determined Y: %g for X: %g", result, x);
    
    return result;
}

- (void)viewDidUnload {
    [self setEquationDisplay:nil];
    [self setGraphView:nil];
    [super viewDidUnload];
}
@end
