//
//  ViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MainPanelViewController.h"
#import "MPTableViewCell.h"
#import "MPDragIndicatorView.h"
#import "MenuPanelViewController.h"
#import "UIView+Resize.h"
#import "UIApplication+Addition.h"
#import <QuartzCore/QuartzCore.h>
#import "GYPositionBounceAnimation.h"
#import "NSNotificationCenter+Addition.h"
#import "AppDelegate.h"
#import "CDINetClient.h"
#import "CDIDataSource.h"
#import "CDINews.h"
#import "CDIWork.h"
#import "CDIEvent.h"
#import "ProjectDetailViewController.h"
#import "NewsDetailViewController.h"
#import "ScheduleEventDetailViewController.h"
#import "ModelPassGestureViewController.h"

@interface MainPanelViewController ()

//@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MPDragIndicatorView *dragIndicatorView;

@property (assign, nonatomic) NSInteger currentActiveRow;
@property (strong, nonatomic) UINavigationController *menuPanelContainerViewController;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopSpaceConstraint;

@property (nonatomic, strong) NSFetchedResultsController *frEventsController;
@property (nonatomic, strong) NSFetchedResultsController *frProjectsController;
@property (nonatomic, strong) NSFetchedResultsController *frNewsController;
@property (nonatomic, strong) NSFetchedResultsController *frLabController;

@property (nonatomic, readwrite) NSInteger selectedRow;
@property (nonatomic, readwrite) NSInteger selectedIndex;
@property (nonatomic, weak) NSFetchedResultsController *selectedFC;

@end

@implementation MainPanelViewController
{
    BOOL isScrolling;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureBasicViews];
    [NSNotificationCenter registerShouldBounceDownNotificationWithSelector:@selector(bounceDown) target:self];
    [NSNotificationCenter registerShouldBounceUpNotificationWithSelector:@selector(bounceUp) target:self];
    [NSNotificationCenter registerDidFetchNewDataNotificationWithSelector:@selector(refresh) target:self];
    self.isMainPanel = YES;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(test) userInfo:nil repeats:YES];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isScrolling = YES;
    [self resetSectionHeaderHeight];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//     withRowAnimation:UITableViewRowAnimationNone];
}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    isScrolling = NO;
//    [self performSelector:@selector(resetSectionHeaderHeight) withObject:nil afterDelay:0.5];
////    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
////                  withRowAnimation:UITableViewRowAnimationNone];
//}
//
- (void)resetSectionHeaderHeight
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)test
{
    NSLog(@"test");

}


#pragma mark - View Setup Methods
- (void)configureBasicViews
{
    //  UIImage *backgroundImage = [[UIImage imageNamed:@"mp_bg"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    //  [self.backgroundImageView setImage:backgroundImage];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableHeaderView:self.dragIndicatorView];
//    [self.dragIndicatorView setFrame:CGRectMake(0.0, 0.0, 320.0, 38.0)];
    
    self.dragIndicatorView.stretchLimitHeight = 100;
    self.dragIndicatorView.delegate = self;
    [self.dragIndicatorView configureScrollView:self.tableView];
//    [self.view addSubview:self.dragIndicatorView];
    
    [self.menuPanelViewController setUp];
}

//- (void)viewDidLayoutSubviews
//{
//    CGRect tableViewFrame = self.tableViewContainerView.frame;
//    [self.tableViewContainerView setFrame:CGRectMake(0.0, 28.0, tableViewFrame.size.width, tableViewFrame.size.height)];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [self.dragIndicatorView resetHeight:kDragIndicatorViewHeight];
    [self.menuPanelContainerViewController.view resetOrigin:CGPointZero];
    [self.menuPanelContainerViewController.view resetSize:kCurrentScreenSize];
    [self.menuPanelViewController.view resetOrigin:CGPointZero];
    [self.menuPanelViewController.view resetSize:kCurrentScreenSize];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.tableViewHeightConstraint.constant = kCurrentScreenHeight;
    self.tableViewTopSpaceConstraint.constant = kCurrentScreenHeight;
    self.containerViewTopSpaceConstraint.constant = -kCurrentScreenHeight;
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        if (!isScrolling) {
//            return 20;
//        }
//        else {
//            return 42;
//        }
//    }
//    else
        return 42;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    switch (section) {
//        case 0:
//            return @"Events";
//            break;
//        case 1:
//            return @"Projects";
//            break;
//        case 2:
//            return @"News";
//            break;
//        default:
//            return @"";
//            break;
//    }
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger sectionTitleHeight;
    NSString * sectionTitleString;
    NSInteger sectionTitle_Y_point;
    switch (section) {
        case 0:
            sectionTitleString = NSLocalizedStringFromTable(@"Events", @"InfoPlist", nil);
            sectionTitle_Y_point = 20.0;
            break;
        case 1:
            sectionTitleString = NSLocalizedStringFromTable(@"Projects", @"InfoPlist", nil);
            sectionTitle_Y_point = 20.0;
            break;
        case 2:
            sectionTitleString = NSLocalizedStringFromTable(@"News", @"InfoPlist", nil);
            sectionTitle_Y_point = 20.0;
            break;
        default:
            sectionTitleHeight = 0.0;
            sectionTitle_Y_point = 0.0;
            sectionTitleString = NSLocalizedStringFromTable(@"Events", @"InfoPlist", nil);
            break;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 42.0)];
    
    UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, sectionTitle_Y_point, tableView.frame.size.width, 14.0)];
    [sectionTitleLabel setText:sectionTitleString];
//    [sectionTitleLabel setBackgroundColor:[UIColor redColor]];
    [sectionTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    [sectionTitleLabel setTextColor:[UIColor colorWithRed:144.0 / 255.0 green:144.0 / 255.0 blue:144.0 / 255.0 alpha:1.0]];
    [view addSubview:sectionTitleLabel];
    
    [view setBackgroundColor:[UIColor colorWithRed:234.0 /255.0 green:234.0 /255.0 blue:234.0 /255.0 alpha:1.0]];
    
    UIImageView * menuLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_line.png"]];
    menuLine.frame = CGRectMake(0.0, 41.0, menuLine.bounds.size.width, menuLine.bounds.size.height);
    [view addSubview:menuLine];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionNumber = indexPath.section;
    static NSString *CellIdentifier = @"MPTableViewCell";
    MPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.contentTableViewController setUpWithRow:indexPath.row + sectionNumber delegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158;
}

#pragma mark - MPCell Table View Delegate
- (void)cellForRow:(NSInteger)row didMoveByOffset:(CGFloat)offset
{
        NSArray *visibleCells = self.tableView.visibleCells;
        for (MPTableViewCell *cell in visibleCells) {
            MPCellTableViewController *cellTableViewController = cell.contentTableViewController;
            NSInteger gap = abs(cellTableViewController.row - row);
            if (gap != 0) {
                [cellTableViewController moveByOffset:offset / ((CGFloat)gap + 1.0)];
            }
        }
}

- (void)registerCurrentActiveRow:(NSInteger)row
{
    self.currentActiveRow = row;
}

- (BOOL)isActiveForRow:(NSInteger)row
{
    return self.currentActiveRow == row;
}

- (NSString *)imageURLForCellAtIndex:(NSInteger)index atRow:(NSInteger)row
{
    NSString *imageURL = @"";
    if (index == 0) {
        CDIEvent *event = self.frEventsController.fetchedObjects[row];
        imageURL = event.previewImageURL;
    } else if (index == 1) {
        CDIWork *work = self.frProjectsController.fetchedObjects[row];
        imageURL = work.previewImageURL;
    } else if (index == 2) {
        CDINews *news = self.frNewsController.fetchedObjects[row];
        imageURL = news.imageURL;
    } else if (index == 3) {
        CDIWork *work = self.frLabController.fetchedObjects[row];
        imageURL = work.previewImageURL;
    }
    return imageURL;
}

- (NSString *)contentNameForCellAtIndex:(NSInteger)index atRow:(NSInteger)row
{
    NSString *contentName = @"";
    if (index == 0) {
        CDIEvent *event = self.frEventsController.fetchedObjects[row];
        contentName = event.name;
    } else if (index == 1) {
        CDIWork *work = self.frProjectsController.fetchedObjects[row];
        if (kIsChinese) {
            contentName = work.name;
        }
        else{
            contentName = work.nameEn;
        }
    } else if (index == 2) {
        CDINews *news = self.frNewsController.fetchedObjects[row];
        contentName = news.title;
    }
    return contentName;
}

- (NSInteger)numberOfRowsAtRow:(NSInteger)row
{
    NSFetchedResultsController *fc = nil;
    if (row == 0) {
        fc = self.frEventsController;
    } else if (row == 1) {
        fc = self.frProjectsController;
    } else if (row == 2) {
        fc = self.frNewsController;
    }
    return fc.fetchedObjects.count > 8 ? 8 : fc.fetchedObjects.count;
}

- (void)didSelectCellAtIndex:(NSInteger)index ofRow:(NSInteger)row
{
    NSString *segueID = @"";
    self.selectedIndex = index;
    self.selectedRow = row;
    if (row == 0) {
        self.selectedFC = self.frEventsController;
        segueID = @"MainEventSegue";
    } else if (row == 1 && index != [self numberOfRowsAtRow:row]) {
        self.selectedFC = self.frProjectsController;
        segueID = @"MainProjectSegue";
    } else if (row == 1 && index == [self numberOfRowsAtRow:row]) {
        segueID = @"MainSeeAllProjectsSegue";
    } else if (row == 2 && index != [self numberOfRowsAtRow:row]) {
        self.selectedFC = self.frNewsController;
        segueID = @"MainNewsSegue";
    } else if (row == 2 && index == [self numberOfRowsAtRow:row]) {
        segueID = @"MainSeeAllNewsSegue";
    }
    [self performSegueWithIdentifier:segueID sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if (self.selectedRow == 0) {
        CDIEventDAO *event = self.selectedFC.fetchedObjects[self.selectedIndex];
        ((ScheduleEventDetailViewController *)vc).event = event;
    } else if (self.selectedRow == 1 && self.selectedIndex != [self numberOfRowsAtRow:self.selectedRow]) {
        CDIWork *work = self.selectedFC.fetchedObjects[self.selectedIndex];
        ((ProjectDetailViewController *)vc).work = work;
    } else if (self.selectedRow == 2 && self.selectedIndex != [self numberOfRowsAtRow:self.selectedRow]){
        CDINews *news = self.selectedFC.fetchedObjects[self.selectedIndex];
        ((NewsDetailViewController *)vc).news = news;
    }
}

#pragma mark - Drag View Delegate
- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view
{
    [self showMenuPanel];
}

- (void)showMenuPanel
{
    [self.tableView resetOriginY:kCurrentScreenHeight - self.tableView.contentOffset.y];
    self.tableView.scrollEnabled = NO;
    self.tableView.scrollEnabled = YES;
    [self.menuPanelViewController refresh];
    
    [self playAnimationWithDirectionUp:NO completion:nil];
    self.isMainPanel = NO;
}

- (void)bounceDown
{

}

- (void)bounceUp
{
    [CDIDataSource reFetchAllDataInMainPanel];

    [self playAnimationWithDirectionUp:YES completion:^(BOOL finished){
        self.menuPanelViewController.dragIndicatorView.hidden = NO;
    }];
    
    self.isMainPanel = YES;
}


- (void)playAnimationWithDirectionUp:(BOOL)isDirectionUp completion:(void (^)(BOOL finished))completion
{
    CGFloat startingValue = self.tableViewContainerView.frame.origin.y + kCurrentScreenHeight;
    CGFloat value = isDirectionUp ? 0 : kCurrentScreenHeight;
    GYPositionBounceAnimation *animation = [GYPositionBounceAnimation animationWithKeyPath:@"position.y"];
    animation.duration = 2.0;
    animation.delegate = self;
    [self performSelector:@selector(showMenuDragIndicator) withObject:nil afterDelay:1.0];
    
    [animation setValueArrayForStartValue:startingValue endValue:value];
    [self.tableViewContainerView.layer setValue:[NSNumber numberWithFloat:value] forKeyPath:animation.keyPath];
    [self.tableViewContainerView.layer addAnimation:animation forKey:@"bounce"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.tableView resetOriginY:kCurrentScreenHeight];
}

- (void)showMenuDragIndicator
{
    self.menuPanelViewController.dragIndicatorView.hidden = NO;
}

#pragma mark - Property
- (MPDragIndicatorView *)dragIndicatorView
{
    if (!_dragIndicatorView) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MPDragIndicatorView"
                                                      owner:self
                                                    options:nil];
        _dragIndicatorView = [nibs objectAtIndex:0];
        _dragIndicatorView.isReversed = NO;
    }
    return _dragIndicatorView;
}

- (MenuPanelViewController *)menuPanelViewController
{
    if (!_menuPanelViewController) {
        _menuPanelContainerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuPanelViewControllerNaviController"];
        _menuPanelViewController = _menuPanelContainerViewController.viewControllers[0];
        [self.tableViewContainerView addSubview:_menuPanelContainerViewController.view];
    }
    return _menuPanelViewController;
}

- (void)refresh
{
    [self.frEventsController performFetch:nil];
    
    [self.frLabController performFetch:nil];
    
    [self.frNewsController performFetch:nil];
    
    [self.frProjectsController performFetch:nil];
}

- (NSFetchedResultsController *)frEventsController
{
    if (_frEventsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"CDIEvent"
                                          inManagedObjectContext:self.managedObjectContext];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"typeOrigin != %@", @"DISCUSSION"];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        _frEventsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _frEventsController.delegate = self;
        
        [_frEventsController performFetch:nil];
    }
    return _frEventsController;
}

- (NSFetchedResultsController *)frLabController
{
    if (_frLabController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"CDIWork"
                                          inManagedObjectContext:self.managedObjectContext];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"workTypeOrigin == %@", @"TANGIBLE_INTERACTIVE_OBJECTS"];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        _frLabController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _frLabController.delegate = self;
        
        [_frLabController performFetch:nil];
    }
    return _frLabController;
}

- (NSFetchedResultsController *)frNewsController
{
    if (_frNewsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"CDINews"
                                          inManagedObjectContext:self.managedObjectContext];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        _frNewsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _frNewsController.delegate = self;
        
        [_frNewsController performFetch:nil];
    }
    return _frNewsController;
}

- (NSFetchedResultsController *)frProjectsController
{
    if (_frProjectsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"CDIWork"
                                          inManagedObjectContext:self.managedObjectContext];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
//        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"workTypeOrigin != %@", @"TANGIBLE_INTERACTIVE_OBJECTS"];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        _frProjectsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _frProjectsController.delegate = self;
        
        [_frProjectsController performFetch:nil];
    }
    return _frProjectsController;
}


@end
