//
//  ViewController.m
//  todo-list
//
//  Created by Kyle Hillman on 5/8/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"


@import FirebaseAuth;
@import Firebase;


@interface ViewController ()

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentUser;
@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todoHeight;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        NSMutableArray *allTodos = [[NSMutableArray alloc]init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *todoData = child.value;
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
                
            //for lab append new todo to all todos array
                NSLog(@"Todo Title: %@ - Content: %@", todoTitle, todoContent);
        }
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


@end





































