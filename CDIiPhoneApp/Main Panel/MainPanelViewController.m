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
#import "CDINews.h"
#import "CDIWork.h"
#import "CDIEvent.h"
#import "ProjectDetailViewController.h"
#import "NewsDetailViewController.h"
#import "ScheduleEventDetailViewController.h"

@interface MainPanelViewController ()

//@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MPDragIndicatorView *dragIndicatorView;
@property (strong, nonatomic) MenuPanelViewController *menuPanelViewController;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureBasicViews];
    [NSNotificationCenter registerShouldBounceDownNotificationWithSelector:@selector(bounceDown) target:self];
    [NSNotificationCenter registerShouldBounceUpNotificationWithSelector:@selector(bounceUp) target:self];
    [NSNotificationCenter registerDidFetchNewDataNotificationWithSelector:@selector(refresh) target:self];
}

#pragma mark - View Setup Methods
- (void)configureBasicViews
{
    //  UIImage *backgroundImage = [[UIImage imageNamed:@"mp_bg"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    //  [self.backgroundImageView setImage:backgroundImage];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableHeaderView:self.dragIndicatorView];
    self.dragIndicatorView.stretchLimitHeight = 100;
    self.dragIndicatorView.delegate = self;
    [self.dragIndicatorView configureScrollView:self.tableView];
    
    [self.menuPanelViewController setUp];
}

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 29.0)];
    UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 5.0, tableView.frame.size.width, 18.0)];
    [sectionTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    switch (section) {
        case 0:
            [sectionTitleLabel setText:@"Events"];
            break;
        case 1:
            [sectionTitleLabel setText:@"Projects"];
            break;
        case 2:
            [sectionTitleLabel setText:@"News"];
            break;
        default:
            [sectionTitleLabel setText:@""];
            break;
    }
    [view addSubview:sectionTitleLabel];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.0]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MPTableViewCell";
    MPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.contentTableViewController setUpWithRow:indexPath.row delegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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

- (NSInteger)numberOfRowsAtRow:(NSInteger)row
{
    NSFetchedResultsController *fc = nil;
    if (row == 0) {
        fc = self.frEventsController;
    } else if (row == 1) {
        fc = self.frProjectsController;
    } else if (row == 2) {
        fc = self.frNewsController;
    } else if (row == 3) {
        fc = self.frLabController;
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
    } else if (row == 1) {
        self.selectedFC = self.frProjectsController;
        segueID = @"MainProjectSegue";
    } else if (row == 2) {
        self.selectedFC = self.frNewsController;
        segueID = @"MainNewsSegue";
    } else if (row == 3) {
        self.selectedFC = self.frLabController;
        segueID = @"MainProjectSegue";
    }
    [self performSegueWithIdentifier:segueID sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if (self.selectedRow == 0) {
        CDIEventDAO *event = self.selectedFC.fetchedObjects[self.selectedIndex];
        ((ScheduleEventDetailViewController *)vc).event = event;
    } else if (self.selectedRow == 1 || self.selectedRow == 3) {
        CDIWork *work = self.selectedFC.fetchedObjects[self.selectedIndex];
        ((ProjectDetailViewController *)vc).work = work;
    } else {
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
}

- (void)bounceDown
{
    //  [self playAnimationWithDirectionUp:NO completion:nil];
}

- (void)bounceUp
{
    [self playAnimationWithDirectionUp:YES completion:nil];
}

- (void)playAnimationWithDirectionUp:(BOOL)isDirectionUp completion:(void (^)(BOOL finished))completion
{
    CGFloat startingValue = self.tableViewContainerView.frame.origin.y + kCurrentScreenHeight;
    CGFloat value = isDirectionUp ? 0 : kCurrentScreenHeight;
    GYPositionBounceAnimation *animation = [GYPositionBounceAnimation animationWithKeyPath:@"position.y"];
    animation.duration = 2.0;
    animation.delegate = self;
    
    [animation setValueArrayForStartValue:startingValue endValue:value];
    [self.tableViewContainerView.layer setValue:[NSNumber numberWithFloat:value] forKeyPath:animation.keyPath];
    [self.tableViewContainerView.layer addAnimation:animation forKey:@"bounce"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.tableView resetOriginY:kCurrentScreenHeight];
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
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"workTypeOrigin != %@", @"TANGIBLE_INTERACTIVE_OBJECTS"];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        _frProjectsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _frProjectsController.delegate = self;
        
        [_frProjectsController performFetch:nil];
    }
    return _frProjectsController;
}

@end
