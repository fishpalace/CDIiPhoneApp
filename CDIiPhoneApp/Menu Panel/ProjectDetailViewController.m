//
//  ProjectDetailViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "TTTAttributedLabel.h"
#import "CDIWork.h"
#import "UIImageView+Addition.h"
#import "UIView+Addition.h"
#import "ProjectDetailUserCell.h"
#import "CDIUser.h"
#import "CDINetClient.h"
#import "UIImageView+Addition.h"
#import "ModelPanelViewController.h"
#import "PeopleInfoViewController.h"

#define kLineSpacing 4
#define kTableViewIntent 9

@interface ProjectDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *projectInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectInfoLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *userListTableView;

@property (nonatomic, weak) CDIUser *selectedUser;

@end

@implementation ProjectDetailViewController

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
    
    _playButton.hidden = YES;
    if ([self.work.linkURL isEqualToString:@""]) {
        _moreButton.hidden = YES;
    }
    
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 182.0)];
    [maskView setBackgroundColor:[UIColor whiteColor]];
    _projectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_projectImageView.layer setMask:maskView.layer];
    [_projectImageView loadImageFromURL:self.work.imgURL completion:^(BOOL succeeded) {
        [_projectImageView fadeIn];
    }];
    if (kIsChinese) {
        [_projectNameLabel setText:self.work.name];
        [_projectInfoLabel setText:self.work.workInfo];
    }
    else {
        [_projectNameLabel setText:self.work.nameEn];
        [_projectInfoLabel setText:self.work.workInfoEn];
    }
    [_projectStatusLabel setText:self.work.workStatus];
    [_projectTypeLabel setText:self.work.workType];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_projectInfoLabel.attributedText];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:kLineSpacing];
    [string addAttribute:NSParagraphStyleAttributeName
                   value:style
                   range:NSMakeRange(0, string.length)];
    [_projectInfoLabel setAttributedText:string];
    
    _userListTableView.delegate = self;
    _userListTableView.dataSource = self;
    [_userListTableView setContentInset:UIEdgeInsetsMake(kTableViewIntent, 0, kTableViewIntent, 0)];
    _userListTableView.contentOffset = CGPointMake(0.0, -kTableViewIntent + 0.5);
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGFloat height = self.projectInfoLabel.frame.origin.y + self.projectInfoLabel.frame.size.height;
    height = height < self.scrollView.frame.size.height ? self.scrollView.frame.size.height + 1 : height;
    [self.scrollView setContentSize:CGSizeMake(320, height)];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.projectInfoLabelHeightConstraint setConstant:[self heightForContentLabel]];
    _userListTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

- (void)loadData
{
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        NSDictionary *rawDict = responseData;
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            NSArray *peopleArray = rawDict[@"data"];
            for (NSDictionary *dict in peopleArray) {
                CDIUser *user = [CDIUser insertUserInfoWithDict:dict inManagedObjectContext:self.managedObjectContext];
                [self.work addInvolvedUserObject:user];
                [user addRelatedWorkObject:self.work];
            }
            [self.managedObjectContext processPendingChanges];
            [self.fetchedResultsController performFetch:nil];
            
            [self.userListTableView reloadData];
            self.userListTableView.contentOffset = CGPointMake(0.0, -kTableViewIntent + 0.5);
        }
    };
    
    [client getUserListWithWorkID:self.work.workID
                       completion:handleData];
}

- (CGFloat)heightForContentLabel
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.projectInfoLabel.attributedText);
    CFRange fitRange;
    CFRange textRange = CFRangeMake(0, self.projectInfoLabel.attributedText.length);
    
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, CGSizeMake(290, CGFLOAT_MAX), &fitRange);
    
    CFRelease(framesetter);
    return frameSize.height + 25;
}

- (void)configureRequest:(NSFetchRequest *)request
{
    request.entity = [NSEntityDescription entityForName:@"CDIUser"
                                 inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF IN %@", self.work.involvedUser];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = predict;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat maxOffsetY = scrollView.contentSize.width - scrollView.frame.size.height;
    maxOffsetY = maxOffsetY < 320 ? 320 - kTableViewIntent : maxOffsetY - kTableViewIntent;
    CGFloat minOffsetY = -kTableViewIntent;
    if (scrollView.contentOffset.y == minOffsetY) {
        scrollView.contentOffset = CGPointMake(0.0, minOffsetY + 0.5);
    } else if (scrollView.contentOffset.y == maxOffsetY) {
        scrollView.contentOffset = CGPointMake(0.0, maxOffsetY - 0.5);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDIUser *user = self.fetchedResultsController.fetchedObjects[indexPath.row];
    ProjectDetailUserCell *cell = [self.userListTableView dequeueReusableCellWithIdentifier:@"ProjectDetailUserCell"];
    [cell.userAvatarImageVIew loadImageFromURL:user.avatarSmallURL completion:^(BOOL succeeded) {
        [cell.userAvatarImageVIew fadeIn];
    }];
    cell.userAvatarImageVIew.layer.masksToBounds = YES;
    cell.userAvatarImageVIew.layer.cornerRadius = 20;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedUser = self.fetchedResultsController.fetchedObjects[indexPath.row];
    PeopleInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleInfoViewController"];
    vc.user = self.fetchedResultsController.fetchedObjects[indexPath.row];
    vc.index = indexPath.row;
    [ModelPanelViewController displayModelPanelWithViewController:vc
                                                    withTitleName:vc.user.name
                                               functionButtonName:@"Write"
                                                         imageURL:vc.user.avatarSmallURL
                                                             type:ModelPanelTypePeopleInfo
                                                         callBack:nil];
}

- (IBAction)didClickMoreButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:self.work.linkURL];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
