//
//  GraphView.h
//  Calculator
//
//  Created by Adam Parrish on 1/26/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource

-(double) yCoordinateForX:(double)x;

@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic, weak) IBOutlet id<GraphViewDataSource> dataSource;

@end
