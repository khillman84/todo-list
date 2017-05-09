//
//  InterfaceController.m
//  watchkit-todo-list Extension
//
//  Created by Kyle Hillman on 5/9/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "InterfaceController.h"
#import "Todo.h"
#import "TodoRowController.h"


@interface InterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) NSArray<Todo *> *allTodos;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [self setupTable];
}

-(void)setupTable {
    [self.table setNumberOfRows:self.allTodos.count withRowType:@"TodoRowController"];
    
    for (NSInteger i =  0; i < self.allTodos.count; i++) {
        TodoRowController *rowController = [self.table rowControllerAtIndex:i];
        [rowController.titleLabel setText:self.allTodos[i].title];
        [rowController.contentLabel setText:self.allTodos[i].content];
    }
}

-(NSArray<Todo *> *)allTodos {
    Todo *firstTodo = [[Todo alloc]init];
    firstTodo.title = @"First Todo";
    firstTodo.content = @"This a todo.";
    
    Todo *secondTodo = [[Todo alloc]init];
    secondTodo.title = @"Second Todo";
    secondTodo.content = @"This a todo 2.";
    
    Todo *thirdTodo = [[Todo alloc]init];
    thirdTodo.title = @"Third Todo";
    thirdTodo.content = @"This a todo 3.";
    
    return @[firstTodo, secondTodo, thirdTodo];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
}

@end



