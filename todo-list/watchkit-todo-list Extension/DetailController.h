//
//  DetailController.h
//  todo-list
//
//  Created by Kyle Hillman on 5/9/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Todo.h"

@interface DetailController : WKInterfaceController

@property(strong, nonatomic)Todo *currentTodo;

@end
