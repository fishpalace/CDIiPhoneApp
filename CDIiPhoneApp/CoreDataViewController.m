//
//  CoreDataViewController.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-24.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "CoreDataViewController.h"
#import "AppDelegate.h"

static CoreDataKernal *kernalInstance = nil;

@interface CoreDataViewController()

@property (nonatomic, readonly) CoreDataKernal *kernal;

@end

@implementation CoreDataViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - CoreData methods

- (void)configureRequest:(NSFetchRequest *)request
{
    
}

- (NSManagedObjectContext*)managedObjectContext
{
    if (_managedObjectContext == nil) {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = [delegate managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Logic methods

- (CoreDataKernal *)kernal {
    return [CoreDataKernal getKernalInstance];
}

- (CDIUser *)currentUser {
    return [CDIUser currentUserInContext:self.managedObjectContext];
}

+ (CDIUser *)getCurrentUser {
    return [CoreDataKernal getKernalInstance].currentUser;
}

#pragma mark -

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [self configureRequest:fetchRequest];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        
        [_fetchedResultsController performFetch:nil];
    }
    return _fetchedResultsController;
}

@end

@implementation CoreDataKernal

@synthesize currentUser = _currentUser;

- (id)init {
    self = [super init];
    if(self) {

    }
    return self;
}

+ (CoreDataKernal *)getKernalInstance {
    if(kernalInstance == nil) {
        kernalInstance = [[CoreDataKernal alloc] init];
    }
    return kernalInstance;
}

@end
