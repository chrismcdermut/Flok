//
//  FindYourFlokViewController.m
//  Flok
//
//  Created by Ritwik Ghosh on 06/07/2017.
//  Copyright © 2017 Ajeet. All rights reserved.
//

#import "FindYourFlokViewController.h"
#import "AddressCell.h"
#import "TreePage.h"
#import "SVProgressHUD.h"
#import "FriendTableViewCell.h"
#import "WebImageOperations.h"
#import "myAnnotation.h"
#define geoAddress(address) [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@",address]

#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif


@interface FindYourFlokViewController ()
{
    CLLocationManager *locationManager;
    CLLocation *myLocation;
    NSMutableArray *arrAddress;
    NSMutableArray *arrFriend;
    NSTimer *mytimer;
    NSString *typedText;
    
    UIDatePicker *datePicker;
    NSMutableArray *arrPeople;
    NSMutableArray *arrCheck;
    UIPickerView *pickerMaxmin;
    NSInteger selectedRow;
    NSUserDefaults *prefs;
    NSString *strLocal,*strAccess;
    UIView *clearView1;
    UIView *blackView1;
    
    
    __weak IBOutlet UILabel *startdatelbl;
    __weak IBOutlet UILabel *Enddatelbl;
    __weak IBOutlet UILabel *starttimelbl;
    __weak IBOutlet UILabel *Endtimelbl;
    
}

@end

@implementation FindYourFlokViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.view.backgroundColor=[UIColor clearColor];
    
    NSLog(@"CreateFlokPage");
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager setDistanceFilter:1.0f];          // measured in meters
    //[locationManager setHeadingFilter:5];
    mapvw.showsUserLocation = YES;
    mapvw.userTrackingMode = MKUserTrackingModeFollow;
    prefs=[NSUserDefaults standardUserDefaults];
    btnViewpht.layer.cornerRadius=4;
    btnViewpht.layer.borderWidth=0.5;
    imgTextBg.layer.cornerRadius=4;
    imgTextBg.layer.borderWidth=1;
    imgTextBg.layer.borderColor=[UIColor lightGrayColor].CGColor;
    btnViewpht.layer.borderColor=appOrange.CGColor;
    mapvw.layer.cornerRadius=4;
    mapvw.layer.borderWidth=0.5;
    mapvw.layer.borderColor=[UIColor lightGrayColor].CGColor;
    btnPostflok1.layer.cornerRadius=4;
    btnPostflok1.layer.borderWidth=0.5;
    btnPostflok1.layer.borderColor=appOrangedark.CGColor;
    btnPostflok2.layer.cornerRadius=4;
    scrlMain.contentSize=CGSizeMake(scrlMain.frame.size.width, 1100);
    
    [self adddonebutton:tfTitle];
    [self adddonebutton:tfAddr];
    //    btnPostflok2.frame=CGRectMake(btnPostflok2.frame.origin.x, scrlMain.frame.size.height-80, btnPostflok2.frame.size.width, btnPostflok2.frame.size.height);
    
    
    tfTitle.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    tvDesc.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    tblAddr.hidden=YES;
    tblAddr.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    tblAddr.layer.cornerRadius=4;
    tblAddr.layer.borderWidth=0.5;
    tblAddr.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    arrPeople=[[NSMutableArray alloc]init];
    arrCheck=[[NSMutableArray alloc]init];
    for (int i=1; i<=100;i++) {
        [arrPeople addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    strLocal=@"local";
    strAccess=@"all access";
    tvDesc.text=@"Enter your optional description";
    app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    [vwFriend setFrame:CGRectMake(0, self.view.frame.size.height, vwFriend.frame.size.width, vwFriend.frame.size.height)];
    // [tblFriend setFrame:CGRectMake(0, 0, tblFriend.frame.size.width, tblFriend.frame.size.height)];
    
    UIView *accessoryView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    accessoryView.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *btnDone=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 63, 40)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(DoneAction:) forControlEvents:UIControlEventTouchUpInside];
    btnDone.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [accessoryView addSubview:btnDone];
    tfFlokLimit.inputAccessoryView=accessoryView;
    
    UIView *accessoryView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    accessoryView1.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *btnDone1=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, 63, 40)];
    [btnDone1 setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone1 addTarget:self action:@selector(DoneActionForDescription:) forControlEvents:UIControlEventTouchUpInside];
    btnDone1.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [accessoryView1 addSubview:btnDone1];
    tvDesc.inputAccessoryView=accessoryView1;
    
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    NSLog(@"current date=======%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *datestring=[dateFormatter stringFromDate:[NSDate date]];
    
    NSArray *datearr=[datestring componentsSeparatedByString:@" "];
    NSString *string1=[datearr objectAtIndex:0];
    NSString *string2=[datearr objectAtIndex:1];
    NSString *string4=[datearr objectAtIndex:2];
    
    NSArray *datearr1=[string1 componentsSeparatedByString:@"-"];
    NSString *string3=[NSString stringWithFormat:@"%@/%@/%@",[datearr1 objectAtIndex:0],[datearr1 objectAtIndex:1],[datearr1 objectAtIndex:2]];
    
    // NSString *string6=[NSString stringWithFormat:@"%@-%@-%@",[datearr1 objectAtIndex:2],[datearr1 objectAtIndex:1],[datearr1 objectAtIndex:0]];
    
    startdatelbl.text=string3;
    starttimelbl.text =[NSString stringWithFormat:@"%@ %@",string2,string4];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    strStarTime = [dateFormatter2 stringFromDate:[NSDate date]];
    
    //strStardate=[NSString stringWithFormat:@"%@ %@",string6,string4];
    vwSub.hidden=YES;
    NSDateFormatter *dateFormat2=[[NSDateFormatter alloc]init];
    dateFormat2.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    strStardate=[NSString stringWithFormat:@"%@",[dateFormat2 stringFromDate:[NSDate date]]];
    
    
    [tfAddr addTarget:self
               action:@selector(textFieldDidChange:)
     forControlEvents:UIControlEventEditingChanged];
}


-(void)clearView1tap{
    NSLog(@"clearView1tap");
    [datePicker removeFromSuperview];
    [clearView1 removeFromSuperview];
    [blackView1 removeFromSuperview];
    //[vwSub removeFromSuperview];
    vwSub.hidden=YES;
}
-(IBAction)hideDatePicker:(id)sender{
    
    [datePicker removeFromSuperview];
    [clearView1 removeFromSuperview];
    [blackView1 removeFromSuperview];
    //[vwSub removeFromSuperview];
    vwSub.hidden=YES;
}

- (IBAction)startdatebuttonclick:(id)sender {
    NSLog(@"startdatebuttonclick");
    
    clearView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    clearView1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:clearView1];
    
    
    blackView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blackView1.backgroundColor=[UIColor blackColor];
    blackView1.alpha=0.4;
    [clearView1 addSubview:blackView1];
    
    vwSub.hidden=NO;
    UITapGestureRecognizer *clearView1tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearView1tap)];
    clearView1tap.numberOfTapsRequired=1;
    [clearView1 addGestureRecognizer:clearView1tap];
    
    
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-170,self.view.frame.size.width, 170)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    // UIDatePickerModeDate;
    datePicker.minimumDate=[NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:30];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setDay:-3];
    //NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [datePicker setMaximumDate:maxDate];
    //[datePicker setMinimumDate:minDate];
    
    datePicker.hidden=NO;
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(LabelTitle1:) forControlEvents:UIControlEventValueChanged];
    [clearView1 addSubview:datePicker];
    [vwSub setFrame:CGRectMake(0, datePicker.frame.origin.y-vwSub.frame.size.height,vwSub.frame.size.width, vwSub.frame.size.height)];
    [clearView1 addSubview:vwSub];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    //assign text to label
    startdatelbl.text=str;
    
    NSDateFormatter *dateFormat2=[[NSDateFormatter alloc]init];
    dateFormat2.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    strStardate=[NSString stringWithFormat:@"%@",[dateFormat2  stringFromDate:datePicker.date]];
    
    
}

-(void)LabelTitle1:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    
    NSDateFormatter *dateFormat2=[[NSDateFormatter alloc]init];
    dateFormat2.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    strStardate=[NSString stringWithFormat:@"%@",[dateFormat2  stringFromDate:datePicker.date]];
    
    
    
    //assign text to label
    startdatelbl.text=str;
}


- (IBAction)StartTimebtnclick:(id)sender {
    NSLog(@"StartTimebtnclick");
    
    clearView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    clearView1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:clearView1];
    
    
    blackView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blackView1.backgroundColor=[UIColor blackColor];
    blackView1.alpha=0.4;
    [clearView1 addSubview:blackView1];
    
    vwSub.hidden=NO;
    
    UITapGestureRecognizer *clearView1tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearView1tap)];
    clearView1tap.numberOfTapsRequired=1;
    [clearView1 addGestureRecognizer:clearView1tap];
    
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, self.view.frame.size.height-170,self.view.frame.size.width, 170); // set frame as your need
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [clearView1 addSubview: datePicker];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [vwSub setFrame:CGRectMake(0, datePicker.frame.origin.y-vwSub.frame.size.height,vwSub.frame.size.width, vwSub.frame.size.height)];
    [clearView1 addSubview:vwSub];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    starttimelbl.text = [dateFormatter stringFromDate:datePicker.date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    strStarTime = [dateFormatter2 stringFromDate:datePicker.date];
    
}

- (void)dateChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    starttimelbl.text = [dateFormatter stringFromDate:datePicker.date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    strStarTime = [dateFormatter2 stringFromDate:datePicker.date];
    
    
}


- (IBAction)Enddatebutton:(id)sender {
    NSLog(@"Enddatebutton");
    clearView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    clearView1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:clearView1];
    
    
    blackView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blackView1.backgroundColor=[UIColor blackColor];
    blackView1.alpha=0.4;
    [clearView1 addSubview:blackView1];
    
    vwSub.hidden=NO;
    
    UITapGestureRecognizer *clearView1tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearView1tap)];
    clearView1tap.numberOfTapsRequired=1;
    [clearView1 addGestureRecognizer:clearView1tap];
    
    
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-170,self.view.frame.size.width, 170)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.minimumDate=[NSDate date];
    datePicker.hidden=NO;
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.date=[NSDate date];
    [datePicker addTarget:self action:@selector(LabelTitle2:) forControlEvents:UIControlEventValueChanged];
    [clearView1 addSubview:datePicker];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:3];
    [comps setDay:-3];
    [vwSub setFrame:CGRectMake(0, datePicker.frame.origin.y-vwSub.frame.size.height,vwSub.frame.size.width, vwSub.frame.size.height)];
    [clearView1 addSubview:vwSub];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    //assign text to label
    Enddatelbl.text=str;
    
    NSDateFormatter *dateFormat2=[[NSDateFormatter alloc]init];
    dateFormat2.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    strEnddate=[NSString stringWithFormat:@"%@",[dateFormat2  stringFromDate:datePicker.date]];
}

-(void)LabelTitle2:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    //assign text to label
    Enddatelbl.text=str;
    
    NSDateFormatter *dateFormat2=[[NSDateFormatter alloc]init];
    dateFormat2.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];
    strEnddate=[NSString stringWithFormat:@"%@",[dateFormat2  stringFromDate:datePicker.date]];
}




- (IBAction)EndTimebtnclick:(id)sender {
    NSLog(@"EndTimebtnclick");
    
    clearView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    clearView1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:clearView1];
    
    
    blackView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blackView1.backgroundColor=[UIColor blackColor];
    blackView1.alpha=0.4;
    [clearView1 addSubview:blackView1];
    
    UITapGestureRecognizer *clearView1tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearView1tap)];
    clearView1tap.numberOfTapsRequired=1;
    [clearView1 addGestureRecognizer:clearView1tap];
    
    vwSub.hidden=NO;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, self.view.frame.size.height-170,self.view.frame.size.width, 170); // set frame as your need
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [clearView1 addSubview: datePicker];
    [datePicker addTarget:self action:@selector(dateChanged2:) forControlEvents:UIControlEventValueChanged];
    
    [vwSub setFrame:CGRectMake(0, datePicker.frame.origin.y-vwSub.frame.size.height,vwSub.frame.size.width, vwSub.frame.size.height)];
    [clearView1 addSubview:vwSub];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    Endtimelbl.text = [dateFormatter stringFromDate:datePicker.date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    strEndTime = [dateFormatter2 stringFromDate:datePicker.date];
    
    
}

- (void)dateChanged2:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    Endtimelbl.text = [dateFormatter stringFromDate:datePicker.date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    strEndTime = [dateFormatter2 stringFromDate:datePicker.date];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    lblMaxLimit.hidden=YES;
    
    if ([app.flokLocation length]!=0) {
        tfAddr.text=app.flokLocation;
        
        /* MKCoordinateRegion newRegion;
         newRegion.center.latitude = [app.flokLat floatValue];
         newRegion.center.longitude = [app.flokLang floatValue];
         newRegion.span.latitudeDelta = 0.008388;
         newRegion.span.longitudeDelta = 0.016243;
         [mapvw setRegion:newRegion animated:YES];*/
        
        CLLocationCoordinate2D center;
        center.latitude=[app.flokLat floatValue];
        center.longitude =[app.flokLang floatValue];
        
        myAnnotation *myannotation= [[myAnnotation alloc] initWithCoordinate:center title:@"User" Description:@"Description"];
        [mapvw addAnnotation:myannotation];
    }else{
        [self getCurrentlocation];
        
    }
    [self performSelector:@selector(getFriendList) withObject:nil afterDelay:1.0];
}

-(IBAction)getFriendView:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwFriend setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //[tblFriend setFrame:CGRectMake(0, 50, tblFriend.frame.size.width, tblFriend.frame.size.height)];
    [UIView commitAnimations];
    
    NSLog(@"%f--%f--%f--%f",tblFriend.frame.origin.x,tblFriend.frame.origin.y,tblFriend.frame.size.width,tblFriend.frame.size.height);
}
-(IBAction)DoneAction:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    int limit=[tfFlokLimit.text intValue];
    if (limit>1000) {
        // [AppWindow makeToast:@"Request too high, why not click the ‘unlimited box’?" duration:2 position:CSToastPositionBottom];
        
        [[[UIAlertView alloc]initWithTitle:@"Request too high" message:@"Why not click the ‘unlimited box'?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        tfFlokLimit.text=@"";
    }
    [tfFlokLimit  resignFirstResponder];
    
    
}
-(IBAction)DoneActionForDescription:(id)sender{
    [tvDesc resignFirstResponder];
}
-(IBAction)doneFriendView:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwFriend setFrame:CGRectMake(0, self.view.frame.size.height, vwFriend.frame.size.width, vwFriend.frame.size.height)];
    // [tblFriend setFrame:CGRectMake(0, self.view.frame.size.height, tblFriend.frame.size.width, tblFriend.frame.size.height)];
    [UIView commitAnimations];
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
    arrTemp=[arrFriend mutableCopy];
    
    NSMutableArray *arrGroup=[[NSMutableArray alloc] init];
    for (int i=0; i<arrCheck.count; i++) {
        int count=[[arrCheck objectAtIndex:i] intValue];
        NSMutableDictionary *dict=[arrFriend objectAtIndex:count];
        [arrTemp removeObject:dict];
        [arrGroup addObject:[dict valueForKey:@"id"]];
    }
    
    //    if (arrGroup.count==0) {
    //        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please select any follower" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    //    }else{
    //
    //    }
    if([strAccess isEqualToString:@"all access"]){
        allaccessed = [[arrGroup valueForKey:@"description"] componentsJoinedByString:@","];
    }else{
        accessList = [[arrGroup valueForKey:@"description"] componentsJoinedByString:@","];
    }
    
    [search resignFirstResponder];
}
-(IBAction)checkBoxClick:(id)sender{
    
    if (isCheck) {
        [imgCheck setImage:[UIImage imageNamed:@"uncheck"]];
        isCheck=NO;
        [tfFlokLimit setUserInteractionEnabled:YES];
    }else{
        [imgCheck setImage:[UIImage imageNamed:@"check"]];
        isCheck=YES;
        tfFlokLimit.text=@"1000";
        [tfFlokLimit setUserInteractionEnabled:NO];
    }
}
-(IBAction)CancelFriendView:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [vwFriend setFrame:CGRectMake(0, self.view.frame.size.height, vwFriend.frame.size.width, vwFriend.frame.size.height)];
    [UIView commitAnimations];
    [search resignFirstResponder];
}
#pragma mark- Picker delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (arrPeople.count>0) {
        selectedRow=row;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrPeople.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    
    title = arrPeople[row];
    
    return title;
}

#pragma mark- Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField==tfMinfolk){
        if (arrPeople.count==0) {
            return NO;
        }
        
        //[self.view endEditing:YES];
        pickerMaxmin = [[UIPickerView alloc] init];
        pickerMaxmin.tag=5;
        pickerMaxmin.delegate =(id) self;
        pickerMaxmin.dataSource =(id) self;
        pickerMaxmin.showsSelectionIndicator = YES;
        tfMinfolk.inputView=pickerMaxmin;
        [self adddonebutton:tfMinfolk];
        
    }else if (textField==tfTitle){
        lblPlaceHolder.hidden=YES;
    }
    else if (textField==tfMaxfolk){
        if (arrPeople.count==0) {
            return NO;
        }
        
        //[self.view endEditing:YES];
        pickerMaxmin = [[UIPickerView alloc] init];
        pickerMaxmin.tag=6;
        pickerMaxmin.delegate =(id) self;
        pickerMaxmin.dataSource =(id) self;
        pickerMaxmin.showsSelectionIndicator = YES;
        tfMaxfolk.inputView=pickerMaxmin;
        [self adddonebutton:tfMaxfolk];
        
    }
    else{
        //[self adddonebutton:textField];
    }
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        scrlMain.contentOffset = CGPointMake(0, textField.frame.origin.y-160);
    } completion:NULL];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==tfTitle) {
        [self colorWord:textField.text];
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (newLength <= 60) {
            lblMaxLimit.hidden=YES;
            return YES;
        }else{
            lblMaxLimit.hidden=NO;
            return NO;
        }
    }
    /*     }*/
    return YES;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([tvDesc.text isEqualToString:@"Enter your optional description"]) {
        tvDesc.text=@"";
    }
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        scrlMain.contentOffset = CGPointMake(0, textView.frame.origin.y-170);
    } completion:NULL];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        //        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //            scrlMain.contentOffset = CGPointMake(0,0);
        //        } completion:NULL];
        [textView resignFirstResponder];
    }
    return  YES;
}

-(void)textFieldDidChange :(UITextField *)textField{
    
    // if a timer is already active, prevent it from firing
    if (mytimer != nil) {
        [mytimer invalidate];
        mytimer = nil;
    }
    
    // reschedule the search: in 1.0 second, call the searchForKeyword: method on the new textfield content
    mytimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                               target: self
                                             selector: @selector(endtyping:)
                                             userInfo: textField.text
                                              repeats: NO];
    
}

- (void)colorWord:(NSString*)text {
    NSRange range;
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:text];
    NSArray *words=[text componentsSeparatedByString:@" "];
    UIFont *fontText = [UIFont boldSystemFontOfSize:14];
    NSDictionary *dictBoldText = [NSDictionary dictionaryWithObjectsAndKeys:fontText, NSFontAttributeName, nil];
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"#"]) {
            range=[text rangeOfString:word];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            [string setAttributes:dictBoldText range:range];
            
        }
    }
    
    
    [tfTitle setAttributedText:string];
    
}

- (void)s{
    arrHashtag=[[NSMutableArray alloc] init];
    NSRange range;
    NSArray *words=[tfTitle.text componentsSeparatedByString:@" "];
    
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"#"]) {
            range=[tfTitle.text rangeOfString:word];
            NSString *string1 = [tfTitle.text substringWithRange:range];
            [arrHashtag addObject:string1];
        }
    }
    
    
}
- (void)endtyping:(NSTimer *)timer
{
    // retrieve the keyword from user info
    
    [self performSelector:@selector(searchAPI) withObject:nil afterDelay:0.1];
    
}

-(void)searchAPI
{
    //text=[text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURL *dataUrl;
    NSString *strLoc=[Global addSpclCharecters:tfAddr.text];
    if (strLoc.length==0) {
        tblAddr.hidden=YES;
    }
    NSString *key=@"AIzaSyCvwpkQLC25a-CDiBhiOJgxomxy7h9vkOY";//@"AIzaSyCHZruCnmsgtnCz_Kv9AN_zw6yPc_dPVlU";
    dataUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=%@",strLoc,key]];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:dataUrl] options:kNilOptions error:nil]];
    
    arrAddress=[[NSMutableArray alloc]init];
    arrAddress=[dict objectForKey:@"predictions"];
    if (arrAddress.count>0) {
        tblAddr.hidden=NO;
    }
    [tblAddr reloadData];
}

- (IBAction)backTap:(id)sender {
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)serachLocationTap:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    [Global disableAfterClick:btn];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"SearchLocationViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)segLocalsocialTap:(UISegmentedControl *)sender {
    
    
    
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            strLocal=@"local";
        }
            break;
        case 1:
        {
            strLocal=@"social";
        }
            break;
        case 2:
        {
            strLocal=@"both";
        }
            break;
            
            
        default:
            break;
    }
}

- (IBAction)segAccessTap:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            strAccess=@"all access";
        }
            break;
        case 1:
        {
            strAccess=@"request based";
            [self getFriendView:self];
            //[self getFriendList ];
        }
            break;
            
        default:
            break;
    }
    
}
-(IBAction)allAccessTap:(id)sender{
    
    setAccess.selectedSegmentIndex=0;
    [self getFriendView:self];
    strAccess=@"all access";
}
#pragma mark map-delegate
-(void)loadMapView:(CLLocation*)location_current :(NSString*)address
{
    [mapvw setDelegate:(id)self];
    
    
    [mapvw removeAnnotations:mapvw.annotations];
    [mapvw removeOverlays:mapvw.overlays];
    CLLocationCoordinate2D coordinate_current;
    coordinate_current.latitude=location_current.coordinate.latitude;
    coordinate_current.longitude=location_current.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate_current, 50*15, 50*15);
    MKCoordinateRegion adjustedRegion = [mapvw regionThatFits:viewRegion];
    [mapvw setRegion:adjustedRegion animated:NO];
    
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        
        return nil;
    }
    
    static NSString *identifier = @"myAnnotation";
    MKAnnotationView * annotationView = (MKAnnotationView *)[mapvw dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    annotationView.image = [UIImage imageNamed:@"map-locator"];
    
    annotationView.canShowCallout=YES;
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = infoButton;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    
}

-(void)getCurrentlocation
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = (id)self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //  mapvw.showsUserLocation = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
             
             NSString *strStreet=([[dictionary valueForKey:@"Street"] length]==0)?@"":[dictionary valueForKey:@"Street"];
             
             NSString *strCity=([[dictionary valueForKey:@"City"] length]==0)?@"":[dictionary valueForKey:@"City"];
             
             NSString *strState=([[dictionary valueForKey:@"State"] length]==0)?@"":[dictionary valueForKey:@"State"];
             
             NSString *strZip=([[dictionary valueForKey:@"Country"] length]==0)?@"":[dictionary valueForKey:@"Country"];
             
             NSString *address;
             if ([strStreet length]==0) {
                 address=[NSString stringWithFormat:@"%@,%@,%@",strCity,strState,strZip];
             }else{
                 address=[NSString stringWithFormat:@"%@ %@,%@,%@",strStreet,strCity,strState,strZip];
             }
             
             NSLog(@"Address=>%@",address);
             
             tfAddr.text=address;
             
             [self loadMapView:currentLocation :address];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }
         
     }];
}

-(CLLocation*)checkService:(NSString*)address
{
    NSError *err;
    CLLocation *loc=[[CLLocation alloc]initWithLatitude:0.00 longitude:0.00
                     ];
    address=[address stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url=[NSURL URLWithString:address];
    NSData *data=[NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&err];
    if(data)
    {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        if([dict[@"status"] isEqualToString:@"OK"])
        {
            float lat=[dict[@"results"][0][@"geometry"][@"location"][@"lat"] floatValue];
            float lng=[dict[@"results"][0][@"geometry"][@"location"][@"lng"] floatValue];
            NSLog(@"gotResponce: lat: %f, lang: %f",lat,lng);
            loc=[[CLLocation alloc]initWithLatitude:lat longitude:lng
                 ];
        }
        
    }
    [self loadMapView:loc :address];
    return loc;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    
    
    // searchResults = [arrFriend filteredArrayUsingPredicate:resultPredicate];
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length]>=2) {
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",
                                        searchText];
        
        searchResults = [arrFriend filteredArrayUsingPredicate:resultPredicate];
        if (searchResults.count>0) {
            isFilter=YES;
            [tblFriend reloadData];
        }else{
            isFilter=NO;
            [tblFriend reloadData];
        }
        
    }
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

#pragma mark UITableView-delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return 60.0;
    }else{
        return 55.0;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        if (isFilter) {
            return searchResults.count;
        }else{
            return arrFriend.count;
        }
        
    }else{
        return arrAddress.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        static NSString *cellIdentifier=@"CellIdentifier";
        FriendTableViewCell *cell=(FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"FriendTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        NSDictionary *dict;
        if (isFilter) {
            dict=[searchResults objectAtIndex:indexPath.row];
        }else{
            dict=[arrFriend objectAtIndex:indexPath.row];
        }
        
        cell.lblName.text=[dict valueForKey:@"full_name"];
        
        [cell.btnCheck addTarget:self action:@selector(checkMark:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheck setTag:indexPath.row];
        NSString *userImg=[dict valueForKey:@"user_image"];
        
        if ([userImg length]==0) {
            cell.profileImg.image=[UIImage imageNamed:@"no-profile"];
        }else{
            [self setImageWithurl:[dict valueForKey:@"user_image"] andImageView:cell.profileImg and:nil];
        }
        //NSString *str =[dict valueForKey:@"message"];
        NSString *tem=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        if ([self getCheckMarkList:tem]) {
            // [cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
            cell.imgCheck.image=[UIImage imageNamed:@"check"];
        }else{
            cell.imgCheck.image=[UIImage imageNamed:@"uncheck"];
            //[cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
        }
        return cell;
    }else{
        static NSString *cellIdentifier=@"CellIdentifier";
        AddressCell *cell=(AddressCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AddressCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict=[arrAddress objectAtIndex:indexPath.row];
        cell.lblAddress.textColor=[UIColor lightGrayColor];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[dict valueForKey:@"description"]];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, tfAddr.text.length-1)];
        
        [cell.lblAddress setAttributedText:string];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSDictionary *dict=[arrAddress objectAtIndex:indexPath.row];
    tfAddr.text=[dict valueForKey:@"description"];
    ;
    tblAddr.hidden=YES;
    // CLLocation *loc=[self checkService:geoAddress(tfAddr.text)];
    // latitude=[NSString stringWithFormat:@"%@",loc.lat]
    [self getLocationFromAddressString:tfAddr.text];
    
    
}

-(BOOL)getCheckMarkList:(NSString*)index{
    
    for(NSString *temp in arrCheck){
        if ([temp isEqualToString:index]) {
            return YES;
        }
    }
    return NO;
}

-(IBAction)checkMark:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    // [btn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    NSString *index=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    
    BOOL objectFound=NO;
    NSInteger myInt=0;
    
    for(NSString *temp in arrCheck){
        if ([temp isEqualToString:index]) {
            objectFound=YES;
            break;
        }
        myInt++;
    }
    
    if (objectFound==YES) {
        [arrCheck removeObjectAtIndex:myInt];
    }
    else{
        [arrCheck addObject:index];
    }
    
    [tblFriend reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}
-(void)getFriendList{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *dataString=[NSString stringWithFormat:@"user_id=%@",userId];
    [[Global sharedInstance] setDelegate:(id)self];
    [[Global sharedInstance] serviceCall:dataString servicename:@"users/myFollowing" serviceType:@"POST"];
}

-(void)selectPicker:(id)sender
{
    if (datePicker.tag==1) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        dateFormat.dateStyle=NSDateFormatterMediumStyle;
        [dateFormat setDateFormat:@"MM/dd/YYYY"];
        tfStartdate.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
        [tfStartdate resignFirstResponder];
        
    }
    else if (datePicker.tag==2) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        dateFormat.dateStyle=NSDateFormatterMediumStyle;
        [dateFormat setDateFormat:@"MM/dd/YYYY"];
        tfEnddate.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
        [tfEnddate resignFirstResponder];
        
    }
    else if (datePicker.tag==3) {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        dateFormat.dateStyle=NSDateFormatterMediumStyle;
        [dateFormat setDateFormat:@"hh:mm a"];
        tfStarttime.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
        [tfStarttime resignFirstResponder];
        
    }
    else if(datePicker.tag==4){
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        dateFormat.dateStyle=NSDateFormatterMediumStyle;
        [dateFormat setDateFormat:@"hh:mm a"];
        tfEndtime.text=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
        [tfEndtime resignFirstResponder];
    }
    
}

-(void)adddonebutton:(UITextField*)tf
{
    UIToolbar * toolBar = [[UIToolbar alloc]init];
    toolBar.barTintColor=RGB(239, 244, 244);
    [toolBar sizeToFit];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTap:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    tf.inputAccessoryView = toolBar;
    
}


-(void)doneTap:(UIButton*)sender
{
    int limit=[tfFlokLimit.text intValue];
    if (limit>1000) {
        [AppWindow makeToast:@"You can't add people more then 1000" duration:2 position:CSToastPositionBottom];
        tfFlokLimit.text=@"";
    }
    [self.view endEditing:YES];
    if (pickerMaxmin.tag==5) {
        tfMinfolk.text=arrPeople[selectedRow];
    }
    else if (pickerMaxmin.tag==6) {
        tfMaxfolk.text=arrPeople[selectedRow];
    }
    
}
-(CLLocationCoordinate2D) getLocation{
    locationManager =[[CLLocationManager alloc] init];
    locationManager.delegate =(id)self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *location=[locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    // Prevent crashing undo bug – see note below.
//    if(range.length + range.location > textField.text.length)
//    {
//        return NO;
//    }
//
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//    return newLength <= 25;
//}

#pragma mark- Webservice
- (IBAction)postflokTap:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [Global disableAfterClick:sender];
    [self colorWordA];
    
    if (tfTitle.text.length==0) {
        [AppWindow makeToast:@"Enter flok title" duration:2 position:CSToastPositionBottom];
    }
    else if (tfTitle.text.length>100){
        [AppWindow makeToast:@"Flok Title may not exceed 100 character limit." duration:2 position:CSToastPositionBottom];
    }
    
    else if(tfAddr.text.length==0) {
        
        [AppWindow makeToast:@"Enter flok address" duration:2 position:CSToastPositionBottom];
    }
    
    else if(tfFlokLimit.text.length==0) {
        [AppWindow makeToast:@"Please input people limit" duration:2 position:CSToastPositionBottom];
    }
    //    else if(tfMaxfolk.text.length==0) {
    //        [AppWindow makeToast:@"Enter max. flok" duration:2 position:CSToastPositionBottom];
    //    }
    
    else if(tfAddr.text.length==0) {
        [AppWindow makeToast:@"Enter flok address" duration:2 position:CSToastPositionBottom];
    }
    //    else if(tvDesc.text.length==0) {
    //        [AppWindow makeToast:@"Enter flok description" duration:2 position:CSToastPositionBottom];
    //    }
    else if(strLocal.length==0) {
        [AppWindow makeToast:@"Select one from local,social,both" duration:2 position:CSToastPositionBottom];
    }
    else if(strAccess.length==0) {
        [AppWindow makeToast:@"Select one from All access & Request based" duration:2 position:CSToastPositionBottom];
    }
    //    else if([tvDesc.text isEqualToString:@"Enter your optional description"]) {
    //           tvDesc.text=@"";
    //    }
    //    else if([tvDesc.text length]==0) {
    //        tvDesc.text=@"";
    //    }
    else if([startdatelbl.text isEqualToString:@"Start Date"]) {
        [AppWindow makeToast:@"Please select start date" duration:2 position:CSToastPositionBottom];
    }
    else if([starttimelbl.text isEqualToString:@"Start Time"]) {
        [AppWindow makeToast:@"Please select start time" duration:2 position:CSToastPositionBottom];
    }
    else if([Enddatelbl.text isEqualToString:@"End Date"]) {
        
        [AppWindow makeToast:@"Please select End date" duration:2 position:CSToastPositionBottom];
    }
    else if([Endtimelbl.text isEqualToString:@"End Time"]) {
        
        [AppWindow makeToast:@"Please select End Time" duration:2 position:CSToastPositionBottom];
    }
    
    else{
        
        if (![self getTimeInterval]) {
            [Global showOnlyAlert:@"Error" :@"Please check start date and end date"];
            Endtimelbl.text=@"";
            return;
        }
        CLLocationCoordinate2D coordinate=[self getLocation];
        //CGFloat mylat=coordinate.latitude;
        //CGFloat mylong=coordinate.longitude;
        latitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
        longitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
        
#if TARGET_IPHONE_SIMULATOR
        latitude=@"22.5726";
        longitude=@"88.3639";
        
        
#endif
        
        NSString *action=@"flok/createFlok";
        // NSString *userid=[prefs objectForKey:@"rem_userdetail"][@"user_id"];
        // NSString *type=strLocal;
        // NSString *access=strAccess;
        
        [self uploadPhoto:action];
        
        /* NSString *dataString=[NSString stringWithFormat:@"title=%@&address=%@&lat=%f&lang=%f&min_people=%@&max_people=%@&description=%@&type=%@&access=%@&start_date=%@&end_date=%@&start_time=%@&end_time=%@&user_id=%@",tfTitle.text,tfAddr.text,mylat,mylong,tfMinfolk.text,tfMaxfolk.text,tvDesc.text,type,access,tfStartdate.text,tfEnddate.text,tfStarttime.text,tfEndtime.text,userid];
         //[self serviceCall:dataString servicename:action serviceType:@"POST"];
         
         [[Global sharedInstance] setDelegate:(id)self];
         [[Global sharedInstance] serviceCall:dataString servicename:action serviceType:@"POST"];*/
        
        
    }
    
}


-(IBAction)editProfileAction:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select image" delegate:self cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
        
    {
        [self showCamera];
        isImageUpload=YES;
    }
    else if(buttonIndex == 1)
        
    {
        [self openPhotoAlbum];
        isImageUpload=YES;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        [self updateEditButtonEnabled];
        [self openEditor:nil];
        
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self openEditor:nil];
        }];
    }
}


#pragma mark WebServiceCallDeleGate Methods

-(void)webserviceCallFailOrError : (NSString *)errorMessage withFlag : (NSString*)serviceName{
    
    [Global showOnlyAlert:@"Error" :errorMessage ];
}
-(void)WebServiceCallFinishWithData : (NSDictionary *)data withFlag : (NSString*)serviceName{
    //
    if([serviceName isEqualToString:@"flok/createFlok"])
    {
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            arrCheck=[[NSMutableArray alloc]init];
            [Global showOnlyAlert:@"Holy Flok! Success!" :nil];
            arrHashtag=[[NSMutableArray alloc] init];
            for (UIViewController *controller in self.tabBarController.viewControllers){
                if ([controller isKindOfClass:[TreePage class]])
                {
                    [self.tabBarController setSelectedViewController:controller];
                    break;
                }
            }
        }
    }else if([serviceName isEqualToString:@"users/myFollowing"]){
        
        if ([[data valueForKey:@"Ack"] intValue]==1) {
            arrFriend=[data valueForKey:@"followingList"];
            [tblFriend reloadData];
        }
        
    }
}


-(void)uploadPhoto:(NSString*)ServiceName
{
    if([tvDesc.text isEqualToString:@"Enter your optional description"]) {
        tvDesc.text=@"";
    }
    if([tvDesc.text length]==0) {
        tvDesc.text=@"";
    }
    [SVProgressHUD showWithStatus:@"Please wait.."];
    //NSString *action=@"flok/createFlok";
    //NSString *userid=[prefs objectForKey:@"rem_userdetail"][@"user_id"];
    NSString *type=strLocal;
    NSString *access=strAccess;
    
    //    strAccess=@"all access";
    //    strAccess=@"request based";
    
    NSLog(@"Show date--%@-%@",startdatelbl,Enddatelbl);
    // NSString *access;
    if([strAccess isEqualToString:@"all access"]){
        access=@"0";
    }
    else if ([strAccess isEqualToString:@"request based"]){
        access=@"1";
    }
    
    NSString *startDate=[NSString stringWithFormat:@"%@ %@",strStardate,strStarTime];
    NSString *endDate=[NSString stringWithFormat:@"%@ %@",strEnddate,strEndTime];
    
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,ServiceName]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120000];
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    NSString *boundary = [NSString stringWithFormat:@"--"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSString * strHashtag;
    
    if (arrHashtag.count>0) {
        strHashtag = [[arrHashtag valueForKey:@"description"] componentsJoinedByString:@""];
        
    }else{
        strHashtag=@"";
    }
    
    NSString *strTime=[self getCurrentDate];
    //==============
    if([ServiceName isEqualToString:@"flok/createFlok"])
    {
        
        NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"user_id":[userId dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"title":[tfTitle.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"hashtag":[strHashtag dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"address":[tfAddr.text dataUsingEncoding:NSUTF8StringEncoding]];
        if ([app.flokLat length]!=0) {
            myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"lat":[app.flokLat dataUsingEncoding:NSUTF8StringEncoding]];
            myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"lang":[app.flokLang dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"lat":[latitude dataUsingEncoding:NSUTF8StringEncoding]];
            myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"lang":[longitude dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"min_people":[tfMinfolk.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"max_people":[tfFlokLimit.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"description":[tvDesc.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"type":[type dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"access":[access dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"accessed_users":[accessList dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"allaccessed_users":[allaccessed dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"start_date":[startdatelbl.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"end_date":[Enddatelbl.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"start_time":[starttimelbl.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"end_time":[Endtimelbl.text dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"date_time":[strTime dataUsingEncoding:NSUTF8StringEncoding]];
        
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"start":[startDate dataUsingEncoding:NSUTF8StringEncoding]];
        myRequestData=[Global makeData:myRequestData :boundary :@"String":@"":@"end":[endDate dataUsingEncoding:NSUTF8StringEncoding]];
        
       /* if (isImageUpload==YES) {
           myRequestData=[Global makeData:myRequestData :boundary :@"File":@"jpg":@"flok_image":UIImageJPEGRepresentation(imgBanner.image, 0.7)]; 
        }*/
        
        
        
    }
    //===========
    
    
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:myRequestData];
    
    // Configure the Session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [request setValue:[NSString stringWithFormat:@"%@=%@", strSessName, strSessVal] forHTTPHeaderField:@"Cookie"];
    
    
    // post the request and handle response
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                  // Handle the Response
                                                  if(error)
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [SVProgressHUD dismiss];
                                                      });
                                                      return;
                                                  }
                                                  NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
                                                  for (NSHTTPCookie * cookie in cookies)
                                                  {
                                                      strSessName=cookie.name;
                                                      strSessVal=cookie.value;
                                                      
                                                  }
                                                  
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [SVProgressHUD dismiss];
                                                      
                                                      if([ServiceName isEqualToString:@"flok/createFlok"])
                                                      {
                                                          NSDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
                                                          NSLog(@"the post value:%@",dict);
                                                          
                                                          dict=[Global cleanJsonToObject:dict];
                                                          
                                                          if ([[dict objectForKey:@"Ack"] integerValue]==1)
                                                          {
                                                              //                                                              [Global showOnlyAlert:@"Success" :@"Flok have been made successfully"];
                                                              
                                                            //  [Global showOnlyAlert:@"Holy Flok! Success!" :nil];
                                                              
                                                             
                                                    
                                                              app.flokLocation=@"";
                                                              app.flokLat=@"";
                                                              app.flokLang=@"";
                                                              
                                                              
                                                               [[[UIAlertView alloc]initWithTitle:@"Holy Flok!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                                                              
                                                              
                                                              
                                                              
                                                          }
                                                          else{
                                                              [Global showOnlyAlert:@"Error" :dict[@"msg"]];
                                                          }
                                                      }
                                                      
                                                  });
                                                  
                                              });
                                          }];
    
    // Initiate the Request
    [postDataTask resume];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0)//OK button pressed
    {
        self.tabBarController.selectedIndex = 0;
    }
    else if(buttonIndex == 1)//Annul button pressed.
    {
        //do something
    }
}

#pragma mark Save image

-(void)setImageWithurl:(NSString*)url andImageView:(UIImageView*)imgview and:(UIActivityIndicatorView *)loder{
    [loder startAnimating];
    NSString* imageName=[url lastPathComponent];
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *tempFolderPath = [docDir stringByAppendingPathComponent:@"tmp"];
    [[NSFileManager defaultManager] createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString  *FilePath = [NSString stringWithFormat:@"%@/%@",tempFolderPath,imageName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:FilePath];
    if (fileExists)
    {
        imgview.image=[UIImage imageWithContentsOfFile:FilePath];
        [loder stopAnimating];
    }
    else
    {
        [WebImageOperations processImageDataWithURLString:url andBlock:^(NSData *imageData)
         {
             imgview.image=[UIImage imageWithData:imageData];
             [imageData writeToFile:FilePath atomically:YES];
             [loder stopAnimating];
             
             
         }];
    }
    
}

- (void)colorWordA{
    NSRange range;
    NSArray *words=[tfTitle.text componentsSeparatedByString:@" "];
    
    for (NSString *word in words) {
        if ([word hasPrefix:@"#"]) {
            range=[tfTitle.text rangeOfString:word];
            NSString *string1 = [tfTitle.text substringWithRange:range];
            [arrHashtag addObject:string1];
        }
    }
    
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.imageView.image = croppedImage;
    
    imgBanner.image=self.imageView.image;
    
    // [self UpdateProfileImage];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)updateEditButtonEnabled
{
    self.editButton.enabled = !!self.imageView.image;
}
#pragma mark - Action methods

- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.imageView.image;
    
    UIImage *image = self.imageView.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - Private methods

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.popover.isPopoverVisible) {
            [self.popover dismissPopoverAnimated:NO];
        }
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover presentPopoverFromBarButtonItem:self.cameraButton
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    } else {
        [self presentViewController:controller animated:YES completion:NULL];
    }
}

-(NSString *)getCurrentDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
    return timeStamp;
}

-(BOOL)getTimeInterval{
    
    NSString *strDate=[NSString stringWithFormat:@"%@ %@",startdatelbl.text, starttimelbl.text];
    NSString *endDate=[NSString stringWithFormat:@"%@ %@",Enddatelbl.text, Endtimelbl.text];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *date1 = [[NSDate alloc] init];
    date1 = [dateFormatter dateFromString:strDate];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *date2 = [[NSDate alloc] init];
    date2 = [dateFormatter1 dateFromString:endDate];
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    
    int numberOfDays = secondsBetween / 60;
    
    if (numberOfDays>0) {
        return YES;
    }else{
        return NO;
    }
}


-(void)getLocationFromAddressString: (NSString*) addressStr {
    double lat = 0, lang = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&lat];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&lang];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=lat;
    center.longitude = lang;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    
    // AppDelegate *app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.flokLat=[NSString stringWithFormat:@"%f",center.latitude];
    app.flokLang=[NSString stringWithFormat:@"%f",center.longitude];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = lat;
    newRegion.center.longitude = lang;
    newRegion.span.latitudeDelta = 0.008388;
    newRegion.span.longitudeDelta = 0.016243;
    [mapvw setRegion:newRegion animated:YES];
    
    myAnnotation *myannotation= [[myAnnotation alloc] initWithCoordinate:center title:@"User" Description:@"Description"];
    [mapvw addAnnotation:myannotation];
    //green_lacation
    
}
@end
