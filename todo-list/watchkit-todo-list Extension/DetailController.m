//
//  DetailController.m
//  todo-list
//
//  Created by Kyle Hillman on 5/9/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "DetailController.h"
#import "Todo.h"

@interface DetailController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleText;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *contentText;

@end

@implementation DetailController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self.titleText setText:context[@"title"]];
    [self.contentText setText:context[@"content"]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



