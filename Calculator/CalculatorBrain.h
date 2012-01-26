//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Adam Parrish on 1/18/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand: (double)operand;
- (void)pushVariable: (NSString *)variable;
- (double)performOperation: (NSString *)operation;
- (void)clear;

@property (readonly) id program;

+ (double) runProgram:(id)program;
+ (double) runProgram:(id)program 
       usingVariables:(NSDictionary *)variableValues;
+ (NSString *) descriptionOfProgram:(id)program;
+ (NSSet *) variablesUsedInProgram:(id)program;

@end
