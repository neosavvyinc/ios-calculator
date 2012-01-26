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
@property (nonatomic, strong) NSDictionary *testVariables;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize variableDisplay = _variableDisplay;
@synthesize infixDisplay = _infixDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariables = _testVariables;

- (NSDictionary *) testVariables
{
    if(!_testVariables) _testVariables = [[NSMutableDictionary alloc] init];
    
    return _testVariables;
}

- (CalculatorBrain *) brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateDisplays
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:self.display.text];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
}

- (IBAction)enterPressed 
{
    if( [self.display.text isEqualToString:@"x"] 
       || [self.display.text isEqualToString:@"a"] 
       || [self.display.text isEqualToString:@"b"] )
    {
        [self.brain pushVariable:self.display.text];
    }
    else
    {
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    [self updateDisplays];
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
    else if( [digit isEqualToString:@"x"] || [digit isEqualToString:@"a"] || [digit isEqualToString:@"b"] )
    {
        self.display.text = digit;
    }    
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

- (void) updateAfterExecutionForResult:(double) result
{
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
    self.infixDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];

}

- (IBAction)operationPressed:(UIButton *)sender 
{    
    if( self.userIsInTheMiddleOfEnteringANumber ) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:sender.currentTitle];
    [self updateAfterExecutionForResult:result];
}

- (IBAction)clearPressed:(id)sender {
    [self.brain clear];
    self.display.text = @"0";
    self.historyDisplay.text = @"";
    self.infixDisplay.text = @"";
    self.variableDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)undoPressed:(UIButton *)sender {
    
    
}

- (IBAction)testPressed:(UIButton *)sender {
    NSString *testButtonTitlePressed = sender.currentTitle;
    
    if( [@"Test 1" isEqualToString:testButtonTitlePressed] )
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithDouble:10], @"x"
                              ,[NSNumber numberWithDouble:20],@"a"
                              ,[NSNumber numberWithDouble:30], @"b"
                              ,nil];
        self.testVariables = dict;
    }
    else if( [@"Test 2" isEqualToString:testButtonTitlePressed] )
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithDouble:20],@"x"
                              ,[NSNumber numberWithDouble:30],@"a"
                              ,[NSNumber numberWithDouble:40],@"b"
                              ,nil];
        self.testVariables = dict;
    }
    else if( [@"Test 3" isEqualToString:testButtonTitlePressed] )
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithDouble:30], @"x"
                              ,[NSNumber numberWithDouble:40],@"a"
                              ,[NSNumber numberWithDouble:50], @"b"
                              ,nil];
        self.testVariables = dict;        
    }
    
    self.variableDisplay.text = [NSString stringWithFormat:@"%@=%@, %@=%@, %@=%@"
                            ,@"x", [self.testVariables objectForKey:@"x"]
                            ,@"a", [self.testVariables objectForKey:@"a"]                                    
                            ,@"b", [self.testVariables objectForKey:@"b"]
                                    ];
    [self.brain updateVariables:self.testVariables];
    double resultVal = [self.brain execute];
    [self updateAfterExecutionForResult:resultVal];
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [self setVariableDisplay:nil];
    [self setInfixDisplay:nil];
    [super viewDidUnload];
}
@end
