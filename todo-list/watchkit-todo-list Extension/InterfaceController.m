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
#import "DetailController.h"

@import WatchConnectivity;


@interface InterfaceController () <WCSessionDelegate>

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
    
    [[WCSession defaultSession] setDelegate:self];
    [[WCSession defaultSession] activateSession];
    
    //The message paramter is where you would wnat to hand the iOS app new todo data to save to Firebase
    [[WCSession defaultSession] sendMessageData:@{} replyHandler:^(NSData * _Nonnull replyMessageData) {
        
        
        NSArray *todoDictionaries = replyMessageData[@"todos"];
        
        NSMutableArray *allTodos = [[NSMutableArray alloc]init];
        
        for (NSDictionary *todoObject in todoDictionaries) {
            Todo *newTodo = [[Todo alloc]init];
            newTodo.title = todoObject[@"title"];
            newTodo.content = todoObject[@"content"];
            //assign any other values here
            
            [allTodos addObject:newTodo];
        }
        
        self.allTodos = allTodos.copy;
        [self setupTable];
        
    } errorHandler:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", error.localizedDescription);
        
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    NSDictionary *currentTodo = @{@"title": self.allTodos[rowIndex].title, @"content": self.allTodos[rowIndex].content};
    [self pushControllerWithName:@"DetailController" context:currentTodo];
    
    
}

@end



