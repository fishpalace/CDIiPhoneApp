//
//  NewsListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-28.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsListTableViewCell.h"
#import "CDINetClient.h"
#import "CDINews.h"
#import "NSDate+Addition.h"

#define kNewsListTableViewCellStandardHeight 70
#define kSingleLineHeight 18

@interface NewsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation NewsListViewController

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
        [CDINews insertNewsInfoWithDict:dict inManagedObjectContext:self.managedObjectContext];
      }
      [self.managedObjectContext processPendingChanges];
      [self.fetchedResultsController performFetch:nil];
      
      [self.tableView reloadData];
    }
  };
  
  [client getNewsListWithCompletion:handleData];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDINews"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
//  request.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.user.relatedWork];
  request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NewsListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewsListTableViewCell"];
  CDINews *news = self.fetchedResultsController.fetchedObjects[indexPath.row];
  [cell.contentLabel setText:news.title];
  [cell.dateLabel setText:[NSDate stringOfDate:news.date includingYear:YES]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = kNewsListTableViewCellStandardHeight;
  NSArray *newsArray = self.fetchedResultsController.fetchedObjects;
  if (newsArray.count != 0) {
    CDINews *news = [newsArray objectAtIndex:indexPath.row];
    CGSize size = [news.title sizeWithFont:kRLightFontWithSize(14)
                         constrainedToSize:CGSizeMake(292, 1000)
                             lineBreakMode:NSLineBreakByCharWrapping];
    height = kNewsListTableViewCellStandardHeight + size.height - kSingleLineHeight;
  }
  return height;
}

#pragma mark - IBActions
- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}


@end
