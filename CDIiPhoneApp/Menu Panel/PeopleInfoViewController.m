//
//  PeopleInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "PeopleInfoViewController.h"
#import "PeopleInfoWorkListCell.h"
#import "CDIUser.h"
#import "CDINetClient.h"
#import "CDIWork.h"
#import "UIImageView+AFNetworking.h"

@interface PeopleInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPositionLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoHomepageButton;
@property (weak, nonatomic) IBOutlet UIButton *infoDribbleButton;
@property (weak, nonatomic) IBOutlet UIButton *infoWeiboButton;
@property (weak, nonatomic) IBOutlet UIButton *infoLinkedinButton;
@property (weak, nonatomic) IBOutlet UIButton *infoTwitterButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation PeopleInfoViewController

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
    NSString *positionString = [NSString stringWithFormat:@"  %@", self.user.position];
    NSString *titleString;
    titleString = NSLocalizedStringFromTable(self.user.title, @"InfoPlist", nil);
    _userPositionLabel.text = positionString;
    _userTitleLabel.text = [titleString uppercaseString];
    
    _userTitleLabel.layer.cornerRadius = 5;
    _userTitleLabel.layer.masksToBounds = YES;
    _userPositionLabel.layer.cornerRadius = 5;
    _userPositionLabel.layer.masksToBounds = YES;
    
    _userTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _userPositionLabel.textColor = kColorPeopleInfoPositionLabel;
    _userTitleLabel.textColor = kColorPeopleInfoTitleLabel;
    _userPositionLabel.font = kFontPeopleInfoPositionLabel;
    _userTitleLabel.font = kFontPeopleInfoTitleLabel;
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self loadData];
}

- (void)loadData
{
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict = responseData;
            NSArray *dataArray = dict[@"data"];
            for (NSDictionary *workDict in dataArray) {
                CDIWork *work = [CDIWork insertWorkInfoWithDict:workDict inManagedObjectContext:self.managedObjectContext];
                [work addInvolvedUserObject:self.user];
                [self.user addRelatedWorkObject:work];
            }
            
            [self.managedObjectContext processPendingChanges];
            [self.fetchedResultsController performFetch:nil];
            
            [self.tableview reloadData];
        }
    };
    
    [client getWorkListWithUserID:self.user.userID completion:handleData];
}

- (void)configureRequest:(NSFetchRequest *)request
{
    request.entity = [NSEntityDescription entityForName:@"CDIWork"
                                 inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nameEn" ascending:YES];
    request.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.user.relatedWork];
    request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = self.fetchedResultsController.fetchedObjects.count;
    numberOfRows = numberOfRows == 0 ? 1 : numberOfRows;
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeopleInfoWorkListCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"PeopleInfoWorkListCell"];
    
    for (UIView * subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }

    cell.isPlaceHolder = self.fetchedResultsController.fetchedObjects.count == 0;
    if (!cell.isPlaceHolder) {
        CDIWork *work = self.fetchedResultsController.fetchedObjects[indexPath.row];
        UIImageView * testView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 25.0, 38.0, 38.0)];
        [testView setImageWithURL:[NSURL URLWithString:work.imgURL]];
        testView.contentMode = UIViewContentModeScaleAspectFill;
        testView.layer.cornerRadius = 19;
        testView.layer.masksToBounds = YES;
        [cell.contentView addSubview:testView];
        
//        [cell.workPicImageView setImageWithURL:[NSURL URLWithString:work.imgURL]];
//        cell.workPicCoverImageView.layer.cornerRadius = 19;
//        cell.workPicCoverImageView.layer.masksToBounds = YES;
        
        cell.workNameLabel.numberOfLines = 1;
        cell.workNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        if (kIsChinese) {
            cell.workNameLabel.text = work.name;
        }
        else {
            cell.workNameLabel.text = work.nameEn;
        }
        
        cell.workTypeLabel.text = work.workType;
        cell.workNameLabel.textColor = kColorPeopleInfoWorkNameLabel;
        cell.workNameLabel.font = kFontPeopleInfoWorkNameLabel;
        cell.workTypeLabel.textColor = kColorPeopleInfoWorkTypeLabel;
        cell.workTypeLabel.font = kFontPeopleInfoWorkTypeLabel;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
