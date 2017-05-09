//
//  ViewController.m
//  todo-list
//
//  Created by Kyle Hillman on 5/8/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "TodoTableViewCell.h"
#import "Todo.h"


@import FirebaseAuth;
@import Firebase;


@interface ViewController () <UITableViewDataSource>

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentUser;
@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todoHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSMutableArray *allTodos;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    self.todoHeight.constant = 0;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
}

-(void)checkUserStatus {
    
    if (![[FIRAuth auth] currentUser]) {
        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:loginController animated:YES completion:nil];
    } else {
        [self setupFirebase];
        [self startMonitoringTodoUpdates];
    }
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
                
            //for lab append new todo to all todos array
            NSLog(@"Todo Title: %@ - Content: %@", todoTitle, todoContent);
            Todo *currentTodo = [[Todo alloc] init];
            currentTodo.title = todoTitle;
            currentTodo.content = todoContent;
            [self.allTodos addObject:currentTodo];
        }
        [self.tableView reloadData];
    }];
}

- (IBAction)logoutButtonPressed:(id)sender {

    NSError *signOutError;
    [[FIRAuth auth] signOut:&signOutError];
    
    [self checkUserStatus];
    
}

- (IBAction)addButtonPressed:(id)sender {

    if (self.todoHeight.constant == 0) {
        self.todoHeight.constant = 150;
    } else {
        self.todoHeight.constant = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.allTodos[indexPath.row];
    cell.titleText.text = currentTodo.title;
    cell.contentText.text = currentTodo.content;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTodos.count;
}


@end





































