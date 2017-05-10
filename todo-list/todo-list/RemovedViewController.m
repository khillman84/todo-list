//
//  RemovedViewController.m
//  todo-list
//
//  Created by Kyle Hillman on 5/9/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "RemovedViewController.h"
#import "RemovedTableViewCell.h"
#import "Todo.h"
#import "LoginViewController.h"

@import Firebase;

@interface RemovedViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentUser;
@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property(strong, nonatomic) NSMutableArray *allTodos;

@end

@implementation RemovedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupFirebase];
    [self startMonitoringTodoUpdates];
}

-(void)setupFirebase {
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    self.currentUser = [[FIRAuth auth] currentUser];
    
    self.userReference = [[databaseReference child:@"users"] child:self.currentUser.uid];
    
    NSLog(@"User Reference: %@", self.userReference);
}

-(void)startMonitoringTodoUpdates {
    
    
    self.allTodosHandler = [[self.userReference child:@"todos"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.allTodos = [[NSMutableArray alloc]init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *todoData = child.value;
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            NSNumber *todoCompleted = todoData[@"completed"];
            
            //for lab append new todo to all todos array
            if (todoCompleted.integerValue == 1) {
                NSLog(@"Todo Title: %@ - Content: %@", todoTitle, todoContent);
                Todo *currentTodo = [[Todo alloc] init];
                currentTodo.title = todoTitle;
                currentTodo.content = todoContent;
                [self.allTodos addObject:currentTodo];
            }
        }
        [self.tableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RemovedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.allTodos[indexPath.row];
    cell.titleText.text = currentTodo.title;
    cell.contentText.text = currentTodo.content;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTodos.count;
}


@end
