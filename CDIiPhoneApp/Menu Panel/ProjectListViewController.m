//
//  ProjectListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ProjectListViewController.h"
#import "ProjectListTableViewCell.h"
#import "CDINetClient.h"
#import "CDIWork.h"
#import "UIImageView+Addition.h"
#import "UIView+Addition.h"

@interface ProjectListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) CDIWork *selectedWork;

@end

@implementation ProjectListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [self loadData];
}

- (void)loadData
{
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    NSDictionary *rawDict = responseData;
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSArray *peopleArray = rawDict[@"data"];
      for (NSDictionary *dict in peopleArray) {
        [CDIWork insertWorkInfoWithDict:dict inManagedObjectContext:self.managedObjectContext];
      }
      [self.managedObjectContext processPendingChanges];
      [self.fetchedResultsController performFetch:nil];
      
      [self.tableView reloadData];
    }
  };
  
  [client getProjectListWithCompletion:handleData];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIWork"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workID" ascending:NO];
  request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  NSInteger count = self.fetchedResultsController.fetchedObjects.count;
  return count == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ProjectListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProjectListTableViewCell"];
  cell.isPlaceHolder = self.fetchedResultsController.fetchedObjects.count == 0;
  if (!cell.isPlaceHolder) {
    CDIWork *work = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [cell.imageView loadImageFromURL:work.previewImageURL completion:^(BOOL succeeded) {
      [cell.imageView fadeIn];
      [cell updateConstraints];
    }];
    [cell.projectNameLabel setText:work.name];
    [cell.projectStatusLabel setText:work.workStatus];
    [cell.projectTypeLabel setText:work.workType];
    
    [cell updateConstraints];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//  CGFloat height = kNewsListTableViewCellStandardHeight;
//  NSArray *newsArray = self.fetchedResultsController.fetchedObjects;
//  if (newsArray.count != 0) {
//    CDINews *news = [newsArray objectAtIndex:indexPath.row];
//    CGSize size = [news.title sizeWithFont:kRLightFontWithSize(14)
//                         constrainedToSize:CGSizeMake(292, 1000)
//                             lineBreakMode:NSLineBreakByCharWrapping];
//    height = kNewsListTableViewCellStandardHeight + size.height - kSingleLineHeight;
//  }
//  return height;
  return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  self.selectedWork = self.fetchedResultsController.fetchedObjects[indexPath.row];
//  [self performSegueWithIdentifier:@"" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//  NewsDetailViewController *vc = segue.destinationViewController;
//  vc.news = self.selectedWork;
}

#pragma mark - IBActions
- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
