//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Adam Parrish on 1/18/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize  programStack = _programStack;

+(NSSet *) noOperandOperators
{
    return [NSSet setWithObjects:@"π", nil];;
}

+(NSSet *) singleOperandOperators
{
    return [NSSet setWithObjects:@"sin",@"sqrt",@"cos", nil];
}

+(NSSet *) twoOperandOperators
{
    return [NSSet setWithObjects:@"+",@"-",@"/",@"*", nil];
}

+ (BOOL) isOperation:(id)objectFromProgram
{
    if( [[self noOperandOperators] containsObject:objectFromProgram]
       || [[self singleOperandOperators] containsObject:objectFromProgram] 
       || [[self twoOperandOperators] containsObject:objectFromProgram])
    {
        return YES;
    }
    return NO;
}


-(NSMutableArray *) programStack
{
    if( _programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand: (double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable: (NSString *)variable
{
    [self.programStack addObject:variable];
}

- (double)performOperation: (NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (void)updateVariable: (NSString *)variable 
             withValue:(NSString *)value
{
    
}

- (id) program
{
    return [_programStack copy];
}

+ (NSString *) descriptionOfTopOfStack:(NSMutableArray *)stack
{
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    NSString *resultString;

    if([CalculatorBrain isOperation:topOfStack])
    {
        NSLog(@"top of stack: %@",topOfStack);
        if([[self noOperandOperators] containsObject:topOfStack])
        {
            resultString = [NSString stringWithFormat:@"%@", topOfStack];
        }
        else if([[self singleOperandOperators] containsObject:topOfStack])
        {
            id op1 = [self descriptionOfTopOfStack:stack];
            resultString = [NSString stringWithFormat:@"%@(%@)", topOfStack, op1];
        }
        else if([[self twoOperandOperators] containsObject:topOfStack])
        {
            id op1 = [self descriptionOfTopOfStack:stack];
            id op2 = [self descriptionOfTopOfStack:stack];
            
            resultString = [NSString stringWithFormat:@"( %@ %@ %@ )", op2,topOfStack,op1];   
        }
    }
    else
    {
        NSLog(@"top of stack is %@", topOfStack);        
        resultString = [NSString stringWithFormat:@"%@", topOfStack];
    }
    
    NSLog(@"result string is about to be returned as %@", resultString);
    return resultString;

}

+ (NSString *) descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    
    if( [program isKindOfClass:[NSArray class]] )
    {
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack];    
}


+ (NSSet *)variablesUsedInProgram:(id)program
{
    return nil;
}

+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if( [topOfStack isKindOfClass:[NSNumber class]] )
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]] )
    {   
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([@"/" isEqualToString:operation]) {
            double divisor = [self popOperandOffStack:stack];
            if(divisor) result = [self popOperandOffStack:stack] / divisor;
        }
        else if ([@"-" isEqualToString:operation]) {
            double subtractor = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtractor;
        }
        else if ([@"sin" isEqualToString:operation]) {
            result = sin([self popOperandOffStack:stack]); 
        }
        else if ([@"cos" isEqualToString:operation]) {
            result = cos([self popOperandOffStack:stack]); 
        }
        else if ([@"sqrt" isEqualToString:operation]) {
            result = sqrt([self popOperandOffStack:stack]); 
        }
        else if ([@"π" isEqualToString:operation]) {
            result = M_PI;
        }
    }
    
    return result;
}

+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    
    if( [program isKindOfClass:[NSArray class]] )
    {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double) runProgram:(id)program 
       usingVariables:(NSDictionary *)variableValues
{
    return 0;
}

-(void)clear
{
    [self setProgramStack:[[NSMutableArray alloc] init]];
}

@end
