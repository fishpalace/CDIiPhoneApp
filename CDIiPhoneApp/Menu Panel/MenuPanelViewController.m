//
//  MenuPanelViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MenuPanelViewController.h"
#import "UIView+Resize.h"
#import "MPDragIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSNotificationCenter+Addition.h"
#import "ModelPanelViewController.h"
#import "TimeDisplayPanelViewController.h"
#import "CDIDataSource.h"
#import "MenuItemCell.h"
#import "MenuRoomInfoCell.h"
#import "NSDate+Addition.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"
#import "RPTimeViewController.h"
#import "ModelPassGestureViewController.h"

@interface MenuPanelViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIButton *checkRoomA;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomB;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomC;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomD;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentUserNameLabel;

@property (nonatomic, readwrite) BOOL doesCurrentUserExist;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *iconImageNameArray;
@property (nonatomic, readwrite) NSInteger selectedRoomID;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingBigRangeButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;


@end

@implementation MenuPanelViewController

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
    [self configureCurrentUserSetting];
    [self.tableView setTableFooterView:self.dragIndicatorView];
    [self.dragIndicatorView configureScrollView:self.tableView];
    self.dragIndicatorView.stretchLimitHeight = 100;
    self.dragIndicatorView.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _avatarImageView.layer.cornerRadius = 20;
    _avatarImageView.layer.masksToBounds = YES;
    [NSNotificationCenter registerDidFetchNewEventsNotificationWithSelector:@selector(reloadTableView) target:self];
    [NSNotificationCenter registerDidChangeCurrentUserNotificationWithSelector:@selector(updateAfterCurrentUserChanged) target:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RoomInfoTimeSegue"]) {
        RPTimeViewController *vc = segue.destinationViewController;
        vc.roomID = self.selectedRoomID;
    }
}

- (void)configureCurrentUserSetting
{
    CDIUser *currentUser = [CDIUser currentUserInContext:self.managedObjectContext];
    self.doesCurrentUserExist = currentUser != nil;
    
    self.settingsButton.hidden = !self.doesCurrentUserExist;
    self.infoButton.hidden = self.doesCurrentUserExist;
    self.settingBigRangeButton.hidden = !self.doesCurrentUserExist;
    self.loginButton.hidden = self.doesCurrentUserExist;
    
    if (self.doesCurrentUserExist) {
        self.currentUserNameLabel.text = currentUser.realNameEn;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:currentUser.avatarSmallURL]];
    } else {
        self.currentUserNameLabel.text = @"Login";
        self.avatarImageView.image = [UIImage imageNamed:@"menu_avatar_login"];
    }
    self.currentUserNameLabel.textColor = kColorCurrentUserNameLabel;
    self.currentUserNameLabel.font = kFontCurrentUserNameLabel;
}

- (void)updateAfterCurrentUserChanged
{
    [self configureCurrentUserSetting];
    _titleArray = nil;
    _iconImageNameArray = nil;
    [self.tableView reloadData];
}

- (void)setUp
{
    self.avatarImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.avatarImageView.layer.borderWidth = 1;
}

- (void)refresh
{
    [self.tableView setContentOffset:CGPointZero];
    [self.dragIndicatorView resetHeight:kDragIndicatorViewHeight];
    [self.dragIndicatorView resetWidth:320];
    [self.dragIndicatorView resetPositions];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (NSString *)imageNameForStatusWithRoomID:(NSInteger)roomID
{
    NSString *imageName = nil;
    CDIRoomStatus status = [CDIDataSource statusForRoom:roomID isToday:YES];
    if (status == CDIRoomStatusAvailable) {
        imageName = @"menu_room_clear";
    } else if (status == CDIRoomStatusBusy) {
        imageName = @"menu_room_available";
    } else {
        imageName = @"menu_room_unavailable";
    }
    return imageName;
}

- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view
{
    self.dragIndicatorView.hidden = YES;
    [NSNotificationCenter postShouldBounceUpNotification];
}

#pragma mark - Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = nil;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 320, 15)];
        view.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60;
    if (indexPath.section == 1 && indexPath.row == 3) {
        height = 143;
        if (kIsiPhone5 && !self.doesCurrentUserExist) {
            height += 60;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section == 0) {
        height = 15;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 1 && indexPath.row == 3) {
        MenuRoomInfoCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"MenuRoomInfoCell"];
        [self configureRoomButton:detailCell.roomAButton label:detailCell.roomALabel roomID:1];
        [self configureRoomButton:detailCell.roomBButton label:detailCell.roomBLabel roomID:2];
        [self configureRoomButton:detailCell.roomCButton label:detailCell.roomCLabel roomID:3];
        [self configureRoomButton:detailCell.roomDButton label:detailCell.roomDLabel roomID:4];
        cell = detailCell;
    } else {
        NSInteger index = indexPath.section == 1 ? indexPath.row + [self numberOfRowsInSection:0] : indexPath.row;
        MenuItemCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
        detailCell.iconImageView.image = [UIImage imageNamed:self.iconImageNameArray[index]];
        detailCell.titleLabel.text = self.titleArray[index];
        detailCell.titleLabel.textColor = kColorItemTitle;
        detailCell.titleLabel.font = kFontItemTitle;
        
        if (!self.doesCurrentUserExist) {
            detailCell.functionButton.hidden = YES;
        }
        else {
            detailCell.functionButton.hidden = (indexPath.row != 0 || indexPath.section == 1);
        }
        detailCell.displayButton.hidden = indexPath.row != 1 || indexPath.section == 1;
        
        if (indexPath.section == 0 && indexPath.row == 1 && self.doesCurrentUserExist) {
            NSInteger reservationCount = [CDIDataSource currentReservationCount];
            if (reservationCount == 0) {
                detailCell.displayButton.hidden = YES;
            } else {
                [detailCell.displayButton.titleLabel setText:[NSString stringWithFormat:@"%d", reservationCount]];
            }
        }
        
        if (indexPath.section == 0 && indexPath.row == 1 && !self.doesCurrentUserExist) {
            if ([ModelPassGestureViewController numberOfPasscodeGesture] == 0) {
                detailCell.displayButton.hidden = YES;
            }
            else {
                detailCell.displayButton.hidden = NO;
                [detailCell.displayButton.titleLabel setText:[NSString stringWithFormat:@"%d",
                                                              [ModelPassGestureViewController numberOfPasscodeGesture]]];
            }
        }
        
        if (indexPath.section == 0 && indexPath.row == 3 && self.doesCurrentUserExist) {
            if ([ModelPassGestureViewController numberOfPasscodeGesture] == 0) {
                detailCell.displayButton.hidden = YES;
            }
            else {
                detailCell.displayButton.hidden = NO;
                [detailCell.displayButton.titleLabel setText:[NSString stringWithFormat:@"%d",
                                                              [ModelPassGestureViewController numberOfPasscodeGesture]]];
            }
        }
        
        cell = detailCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *segueID = @"";
    if (indexPath.section == 0 && self.doesCurrentUserExist) {
        if (indexPath.row == 0 ) {
            segueID = @"MenuScheduleSegue";
        } else if (indexPath.row == 1) {
            segueID = @"MenuReservationSegue";
        } else if (indexPath.row == 2) {
            segueID = @"MenuDeviceSegue";
        } else if (indexPath.row == 3 && [ModelPassGestureViewController numberOfPasscodeGesture] > 0) {
            //MY PASSCODE
            [ModelPassGestureViewController displayModelPanelWithViewController:self];
        }
    }else if (indexPath.section == 0 && !self.doesCurrentUserExist){
        if (indexPath.row == 0) {
            segueID = @"MenuScheduleSegue";
        } else if (indexPath.row == 1 && [ModelPassGestureViewController numberOfPasscodeGesture] > 0) {
            //MY PASSCODE
            [ModelPassGestureViewController displayModelPanelWithViewController:self];
        }
    }
    else {
        if (indexPath.row == 0) {
            segueID = @"MenuNewsSegue";
        } else if (indexPath.row == 1) {
            segueID = @"MenuProjectsSegue";
        } else if (indexPath.row == 2) {
            segueID = @"MenuPeopleSegue";
        }
    }
    if (![segueID isEqualToString:@""]) {
        [self performSegueWithIdentifier:segueID sender:self];
    }
}

//- (void)addPasswordGesture
//{
//    UIImageView * passGestureImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pass_gesture.png"]];
//    passGestureImageview.frame = CGRectMake(28.0, [UIScreen mainScreen].bounds.size.height, 264, 369);
//    float passGestureHeight;
//    if (kIsiPhone5) {
//        passGestureHeight = 100;
//    }
//    else {
//        passGestureHeight = 56;
//    }
//    [self.view addSubview:passGestureImageview];
//    
//    UIView * bgGloomView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [bgGloomView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
//    [self.view insertSubview:bgGloomView belowSubview:passGestureImageview];
//    [bgGloomView setAlpha:0.0];
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [bgGloomView setAlpha:1.0];
//    }completion:nil];
//    
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        passGestureImageview.frame = CGRectMake(28.0, passGestureHeight, 264, 369);
//    }completion:nil];
//}

- (void)configureRoomButton:(UIButton *)button label:(UILabel *)label roomID:(NSInteger)roomID
{
    NSInteger percentage = [CDIDataSource availablePercentageWithRoomID:roomID isToday:YES];
    NSString *percentageString = [NSString stringWithFormat:@"%d", percentage];
    NSString *buttonBGImageName = @"";
    UIColor *color = nil;
    if (percentage == 0) {
        percentageString = [percentageString stringByAppendingString:@"%"];
        buttonBGImageName = @"menu_status_red";
        color = kRRoomStatusUnvailableColor;
    } else if (percentage < 50) {
        percentageString = [percentageString stringByAppendingString:@"%"];
        buttonBGImageName = @"menu_status_yellow";
        color = kRRoomStatusAvailableColor;
    } else {
        percentageString = [percentageString stringByAppendingString:@"%"];
        buttonBGImageName = @"menu_status_green";
        color = kRRoomStatusFreeColor;
    }
    [label setText:percentageString];
    [label setTextColor:color];
    [label setFont:[UIFont systemFontOfSize:10]];
    [button setBackgroundImage:[UIImage imageNamed:buttonBGImageName] forState:UIControlStateNormal];
}

#pragma mark - IBActions
- (IBAction)didClickCheckRoomButton:(UIButton *)sender
{
    [self displayModelPanelWithRoomID:sender.tag];
}

- (void)displayModelPanelWithRoomID:(NSInteger)roomID
{
    TimeDisplayPanelViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDisplayPanelViewController"];
    vc.roomID = roomID;
    self.selectedRoomID = roomID;
    
    char title = 'A' + roomID - 1;
    NSString *roomTitle = [NSString stringWithFormat:@"%c %@", title, [CDIDataSource nameForRoomID:roomID]];
    
    CDIUser * user = [CDIUser currentUserInContext:self.managedObjectContext];
    [ModelPanelViewController displayModelPanelWithViewController:vc
                                                    withTitleName:roomTitle
                                               functionButtonName:@"Reserve"
                                                         imageURL:user.avatarSmallURL
                                                             type:ModelPanelTypeRoomInfo
                                                         callBack:^{
                                                             [self performSegueWithIdentifier:@"RoomInfoTimeSegue" sender:self];
                                                         }];
}

- (IBAction)didClickLoginButton:(UIButton *)sender
{
    [LoginViewController displayLoginPanelWithCallBack:^{
        if ([self.currentUser.password isEqualToString:@"123456"]) {
            [self performSegueWithIdentifier:@"MenuSetupSegue" sender:self];
            [NSNotificationCenter postShouldChangeLocalDatasourceNotification];
        }
    }];
}

- (IBAction)didClickScheduleButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"MenuReserveSegue" sender:self];
}

- (IBAction)didClickSettingsButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"MenuSettingsSegue" sender:self];
}

- (IBAction)didClickSettingBigRangeButton:(id)sender
{
    [self performSegueWithIdentifier:@"MenuSettingsSegue" sender:self];
}
#pragma mark - Properties
- (MPDragIndicatorView *)dragIndicatorView
{
    if (!_dragIndicatorView) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MPDragIndicatorView"
                                                      owner:self
                                                    options:nil];
        _dragIndicatorView = [nibs objectAtIndex:0];
        _dragIndicatorView.isReversed = YES;
    }
    return _dragIndicatorView;
}

- (NSMutableArray *)iconImageNameArray
{
    if (!_iconImageNameArray) {
        if (self.doesCurrentUserExist) {
            _iconImageNameArray = [NSMutableArray arrayWithObjects:@"menu_icon_cal", @"menu_icon_key",
                                   @"menu_icon_device",@"menu_icon_passcode", @"menu_icon_news", @"menu_icon_proj", @"menu_icon_people", nil];
        } else {
            _iconImageNameArray = [NSMutableArray arrayWithObjects:@"menu_icon_cal", @"menu_icon_passcode",@"menu_icon_news",
                                   @"menu_icon_proj", @"menu_icon_people", nil];
        }
    }
    return _iconImageNameArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        if (self.doesCurrentUserExist) {
            _titleArray = [NSMutableArray arrayWithObjects:@"Schedule", @"My Reservations", @"Devices",@"My Passcode",
                           @"News", @"Projects", @"People", nil];
        } else {
            _titleArray = [NSMutableArray arrayWithObjects:@"Schedule",@"My Passcode",
                           @"News", @"Projects", @"People", nil];
        }
    }
    return _titleArray;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (section == 0) {
        numberOfRows = self.doesCurrentUserExist ? 4 : 2;
    } else {
        numberOfRows = 4;
    }
    return numberOfRows;
}

@end
