//
//  FirebaseAPI.m
//  todo-list
//
//  Created by Kyle Hillman on 5/10/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "FirebaseAPI.h"
#import "Credentials.h"
#import "LoginViewController.h"
#import "Todo.h"

@implementation FirebaseAPI

+(void)fetchAllTodos:(AllTodosCompletion)completion {
    
    NSString *urlString = [NSString stringWithFormat:@"https://todo-list-ed96c.firebaseio.com/users.json?auth=%@", APP_KEY];
    
    NSURL *databaseURL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:databaseURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"ROOT OBJECT:%@", rootObject);
        
        NSMutableArray *allTodos = [[NSMutableArray alloc] init];
        
        LoginViewController *userEmail = [[LoginViewController alloc]init];

        
        for (NSDictionary *userTodosDictionary in [rootObject allValues]) {
            NSArray *userTodos = [userTodosDictionary[@"todos"] allValues];
            
            for (NSDictionary *todoDictionary in userTodos) {
                
                if ([todoDictionary[@"email"] isEqualToString:userEmail.currentEmail]) {
                    Todo *newTodo = [[Todo alloc]init];
                    newTodo.title = todoDictionary[@"title"];
                    newTodo.content = todoDictionary[@"content"];
                    //assign other todo properties here
                    
                    [allTodos addObject:newTodo];
                }
                
            }
        }
        if (completion) {
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                completion(allTodos);
//            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(allTodos);
            });
        }
    }]resume];
}

@end
