//
//  ASStudentsViewController.m
//  HW_41-44_CoreData
//
//  Created by MD on 07.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASStudentsViewController.h"
#import "ASEditStudentsViewController.h"

#import "ASStudents.h"

@interface ASStudentsViewController ()

@end

@implementation ASStudentsViewController
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"ASStudent";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - actions

-(void) deleteEntityAction:(id) sender {
    
    NSLog(@"deleteEntityAction - ASStudent View Controller");
    [[ASDataManager sharedManager] deleteAllObjects:@"ASStudents"];
}


-(void) addEntityAction:(id) sender {
    
    NSLog(@"addEntityAction - ASStudent View Controller");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ASEditStudentsViewController *vc = (ASEditStudentsViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"ASEditStudentsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"ASStudents"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* firstNameDescription =
    [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    NSSortDescriptor* lastNameDescription =
    [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];

    
    [fetchRequest setSortDescriptors:@[firstNameDescription,lastNameDescription]];
    
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ASStudents *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",student.firstName,student.lastName];
    cell.detailTextLabel.text = student.email;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ASStudents *student = [self.fetchedResultsController objectAtIndexPath:indexPath];

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    ASEditStudentsViewController *vc = (ASEditStudentsViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"ASEditStudentsViewController"];
    vc.student = student;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
