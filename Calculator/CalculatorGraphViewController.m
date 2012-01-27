//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Adam Parrish on 1/26/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "GraphView.h"

@interface CalculatorGraphViewController() <GraphViewDataSource>

@end

@implementation CalculatorGraphViewController

@synthesize equationDisplay;

-(void)viewWillAppear:(BOOL)animated
{
    [self equationDisplay].text = @"Adam was here";
}

-(double) yCoordinateForX:(double)x
{
    return 30.0;
}

- (void)viewDidUnload {
    [self setEquationDisplay:nil];
    [super viewDidUnload];
}
@end
