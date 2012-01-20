//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Adam Parrish on 1/18/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    
    /**
     * Disallow multiple decimal values from being passed into
     * the digitPressed method
     */
    NSRange rangeOfDecimalInDisplay = [self.display.text rangeOfString:@"."];
    NSRange rangeOfDecimalInDigit = [digit rangeOfString:@"."];
    if( rangeOfDecimalInDisplay.location != NSNotFound &&
        rangeOfDecimalInDigit.location != NSNotFound )
    {
        return;
    }
    
    if( self.userIsInTheMiddleOfEnteringANumber )
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else if( rangeOfDecimalInDigit.location != NSNotFound 
            && self.userIsInTheMiddleOfEnteringANumber == NO )
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:self.display.text];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
}


- (IBAction)operationPressed:(UIButton *)sender 
{    
    if( self.userIsInTheMiddleOfEnteringANumber ) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:sender.currentTitle];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
}

- (IBAction)clearPressed:(id)sender {
    [self.brain clear];
    self.display.text = @"0";
    self.historyDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
