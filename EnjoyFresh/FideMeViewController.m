//
//  FideMeViewController.m
//  EnjoyFresh
//
//  Created by Mohnish vardhan on 15/08/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "FideMeViewController.h"

@interface FideMeViewController ()

@end

@implementation FideMeViewController
#pragma mark -
#pragma mark - ViewcontrollerLifeCycleMethods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // dropDwnBtn.imageEdgeInsets = UIEdgeInsetsMake(17, 0, 0, 0);

    CGFloat dragOutMenuViewWidth = self.view.bounds.size.width;
    CGFloat dragOutMenuViewHeight = self.view.bounds.size.height * 0.9;
    CGFloat dragOutMenuPeakAmount = dragOutMenuViewHeight * 0.1;
    CGFloat dragOutMenuVisibleAmount = dragOutMenuViewHeight * 0.6;
    
    DragOutMenuView *dragOutMenuView = [[DragOutMenuView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- dragOutMenuVisibleAmount, dragOutMenuViewWidth, dragOutMenuViewHeight)];
    dragOutMenuView.peakAmount = dragOutMenuPeakAmount;

    dragOutMenuView.visibleAmount = dragOutMenuVisibleAmount;
    dragOutMenuView.maxExtendedAmount = dragOutMenuViewWidth;
    dragOutMenuView.dragOutViewStrategy = [[EHDragOutViewBottomToTopStrategy alloc] init];
    dragOutMenuView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    
    
     table=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, dragOutMenuView.frame.size.width, dragOutMenuVisibleAmount-40)];
    table.dataSource=self;
    table.delegate=self;
    [dragOutMenuView addSubview:table];
    
    UIButton *category =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [category setFrame:CGRectMake(10, 10, 100, 30)];
    [category setTitle:@"Category  >" forState:UIControlStateNormal];
    [category setTitleColor:[UIColor colorWithRed:46/255.f green:45/255.f blue:45/255.f alpha:1.0f] forState:UIControlStateNormal];
    category.titleLabel.font=[UIFont fontWithName:Regular size:14 ];
    
    [dragOutMenuView addSubview:category];
    
    
    UIButton *Button1 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Button1 setFrame:CGRectMake(120, 10, 80, 30)];
    [Button1 setTitle:@"Dietary  >" forState:UIControlStateNormal];
    [Button1 setTitleColor:[UIColor colorWithRed:46/255.f green:45/255.f blue:45/255.f alpha:1.0f] forState:UIControlStateNormal];
Button1.titleLabel.font=[UIFont fontWithName:Regular size:14 ];
    [dragOutMenuView addSubview:Button1];
    
    
    UIButton *Button2 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Button2 setFrame:CGRectMake(220, 10, 80, 30)];
    [Button2 setTitle:@"Location  >" forState:UIControlStateNormal];
    [Button2 setTitleColor:[UIColor colorWithRed:46/255.f green:45/255.f blue:45/255.f alpha:1.0f] forState:UIControlStateNormal];
Button2.titleLabel.font=[UIFont fontWithName:Regular size:14 ];
    [dragOutMenuView addSubview:Button2];
    
   
    
    [self.view addSubview:dragOutMenuView];
  //  [ [UILabel appearance]setFont:[UIFont fontWithName:Regular size:16]];
     
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - MapView Delegates
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    
    annotationView.image = [UIImage imageNamed:@"nf_map_pin"];

    
    UIImage *im=[UIImage imageNamed:@"menu_icon.png"];
    UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
    [bu setBackgroundImage:im forState:UIControlStateNormal];
    [bu setFrame:CGRectMake(0, 0, 30, 30)];
    annotationView.leftCalloutAccessoryView=bu;
    
    annotationView.canShowCallout = YES;
    
    annotationView.annotation = annotation;
    
    [self zoomToFitMapAnnotations];
    

    return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}
-(void)addpin :(NSDictionary*)dict
{
    [mapview removeAnnotations:mapview.annotations];
    
    NSString *string = [dict valueForKey:@"Region_latlan"] ;
    
    if (![string length])
        return;
    NSArray *testArray = [string componentsSeparatedByString:@","];
    
    NSString *lat = [testArray objectAtIndex:0];
    lat = [lat stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *lon = [testArray objectAtIndex:1];
    lon = [lon stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    Place* current = [[Place alloc] init];
    
    NSString *str = [dict valueForKey:@"Region_name"] ;
    current.name= [str uppercaseString];
    current.latitude = [lat floatValue] ;
    current.longitude = [lon floatValue];
    
    PlaceMark *toAnnotation=[[PlaceMark alloc] initWithPlace:current];
    toAnnotation.pinColor = MKPinAnnotationColorPurple;
    [mapview addAnnotation:toAnnotation];
    
    [self zoomToFitMapAnnotations];
    
    
}
- (void)zoomToFitMapAnnotations {
    
    if ([mapview.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    /*  int i = 0;
     MKMapPoint points[[_mapView.annotations count]];
     
     //build array of annotation points
     for (id<MKAnnotation> annotation in [_mapView annotations])
     points[i++] = MKMapPointForCoordinate(annotation.coordinate);
     
     MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
     
     [_mapView setRegion:MKCoordinateRegionForMapRect([poly boundingMapRect]) animated:YES];
     */
    
    for(id<MKAnnotation> annotation in mapview.annotations)// here MYAnnotation is custom annotation call.
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
        
    }
    
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    
    region = [mapview regionThatFits:region];
    [mapview setRegion:region animated:YES];
    
}


#pragma mark
#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    Find_me_custom *cell = (Find_me_custom *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Find_me_custom" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.restaurant_name.font=[UIFont fontWithName:Regular size:16];
    cell.Chef_restaurant.font=[UIFont fontWithName:Regular size:9];
    cell.Restaraunt_desc.font=[UIFont fontWithName:Regular size:14];

    return cell;
}
#pragma mark
#pragma mark - TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark
#pragma mark - Button Actions
- (IBAction)Back_Btn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)dropDownBtnClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    if(drp==nil)
    {
        [btn setImage:[UIImage imageNamed:@"close_icon_03.png"] forState:UIControlStateNormal];
        drp = [[DropDown alloc] initWithStyle:UITableViewStylePlain];
        [drp.view setFrame:CGRectMake(100, 63, 220, 0)];
        
        drp.delegate = self;
        [self.view addSubview:drp.view];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        [drp.view setFrame:[drp dropDownViewFrame]];
        [UIView commitAnimations];
    }
    else
    {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             [drp.view setFrame:CGRectMake(100, 63, 220, 0)];
                         }
                         completion:^(BOOL finished){
                             [drp.view removeFromSuperview];
                             drp=nil;
                             [btn setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
                             
                         }
         ];
    }
    
}
#pragma mark
#pragma mark - DropDown Delegtes
-(void)removeDropdown
{
    [drp.view removeFromSuperview];
    drp=nil;
    [dropDwnBtn setImage:[UIImage imageNamed:@"HamburgerIcon"] forState:UIControlStateNormal];
}
#pragma mark
#pragma mark - ParseAndGetData Delegates
-(void)dataDidFinishLoadingwithResult:(NSDictionary *)result
{
    BOOL errMsg=[[result valueForKey:@"error"]boolValue];
    if(errMsg)
        [GlobalMethods showAlertwithString:[result valueForKey:@"message"]];
    else
    {
    }
}
-(void)dataDidFailedLoadingWithError:(NSString *)err
{
    [GlobalMethods showAlertwithString:err];
}
//- (CGPoint)pointForDragginView:(EHDragOutView *)dragginView afterTranslation:(CGPoint)translation
//{
//    return CGPointMake(160, 160);
//}
//- (BOOL)isShowingPeakAmountForDraggingView:(EHDragOutView *)draggingView atPoint:(CGPoint)point inView:(UIView *)view{
//    return YES;
//}
//- (BOOL)isMaxExtendedAmountReachedForDraggingView:(EHDragOutView *)draggingView atPoint:(CGPoint)point inView:(UIView *)view
//{
//    return YES;
//}
//- (BOOL)isEntireViewShownForDraggingView:(EHDragOutView *)draggingView atPoint:(CGPoint)point inView:(UIView *)view{
//    return YES;
//}
//- (BOOL)isShowingMoreThanVisibleAmountForDraggingView:(EHDragOutView *)draggingView atPoint:(CGPoint)point inView:(UIView *)view{
//    return YES;
//}
//- (BOOL)shouldShowDraggingView:(EHDragOutView *)draggingView basedOnVelocity:(CGPoint)velocity{
//    return YES;
//}
//- (CGPoint)pointForClosedDraggingView:(EHDragOutView *)draggingView inView:(UIView *)view{
//    return CGPointMake(0, 0);
//
//}
//- (CGPoint)pointForOpenedDraggingView:(EHDragOutView *)draggingView inView:(UIView *)view{
//    return CGPointMake(0, 0);
//
//}
@end
