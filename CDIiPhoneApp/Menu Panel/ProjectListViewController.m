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
#import "ProjectDetailViewController.h"
#import "UIImageView+AFNetworking.h"

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
    
    for (UIView * subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    if (!cell.isPlaceHolder) {
        
        CDIWork *work = self.fetchedResultsController.fetchedObjects[indexPath.row];
//        [cell.imageView loadImageFromURL:work.previewImageURL completion:^(BOOL succeeded) {
//        [cell.imageView fadeIn];
//        }];
        
        UIImageView * preivewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 90.0, 90.0)];
        UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 90.0, 90.0)];
        [maskView setBackgroundColor:[UIColor whiteColor]];
        [preivewImageView setImageWithURL:[NSURL URLWithString:work.previewImageURL]];
        preivewImageView.contentMode = UIViewContentModeScaleAspectFill;
        [preivewImageView.layer setMask:maskView.layer];
        [cell.contentView addSubview:preivewImageView];
        
        //      [cell.imageView setImageWithURL:[NSURL URLWithString:work.previewImageURL]];
        //      cell.imageView.image = [UIImage imageNamed:@"main_room_4.png"];
        //      cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //      cell.imageView.clipsToBounds = YES;
        //      NSLog(@"%f %f",cell.imageView.frame.size.width,cell.imageView.frame.size.height);
        
        [cell.projectNameLabel setText:work.name];
        [cell.projectStatusLabel setText:work.workStatus];
        [cell.projectTypeLabel setText:work.workType];
    }
    return cell;
}

//-(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect {
//    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
//    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
//    CGImageRef imageRef = superImage.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
//    UIGraphicsBeginImageContext(subImageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, subImageRect, subImageRef);
//    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext(); //返回裁剪的部分图像
//    return returnImage;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedWork = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"ProjectDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProjectDetailViewController *vc = segue.destinationViewController;
    vc.work = self.selectedWork;
}

#pragma mark - IBActions
- (IBAction)didClickBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
