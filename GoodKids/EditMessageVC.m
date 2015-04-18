//
//  EditMessageVC.m
//  GoodKids
//
//  Created by 詹鎮豪 on 2015/4/15.
//  Copyright (c) 2015年 SuperNova. All rights reserved.
//

#import "EditMessageVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface EditMessageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong,nonatomic) NSMutableArray *InfoArray;
@end

@implementation EditMessageVC
-(NSString *)getNowTime{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    NSString *nowTime=[dateFormatter stringFromDate:now];
    return nowTime;
}

-(void)doneCust{
    if (self.flag==1) {
        //新增存擋
        [_messageDic setValue:_titleText.text forKey:@"title"];
        [_messageDic setValue:[self getNowTime] forKey:@"date"];
        [_messageDic setValue:_contentText.text forKey:@"content"];
        if (_InfoArray.count){
        [_messageDic setValue:_InfoArray[0] forKey:@"image"];
        }
    
        [self.Delegate EditMessageVC:self messageDic:_messageDic];
    }else if (_flag==2){
        //修改存擋
        [_messageDic setValue:_titleText.text forKey:@"title"];
        [_messageDic setValue:[self getNowTime] forKey:@"date"];
        [_messageDic setValue:_contentText.text forKey:@"content"];
        if (_InfoArray.count){
            [_messageDic setValue:_InfoArray[0] forKey:@"image"];
        }
        [self.Delegate EditMessageVC:self messageDic:_messageDic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //新增完成按鈕
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneCust)];
    self.navigationItem.rightBarButtonItem=doneButton;
    //資料初始化
    _messageDic =[NSMutableDictionary new];
    _InfoArray=[NSMutableArray new];
    if (_flag==1) {
        //新增模式
        self.title=@"New Message";
        _dateText.text=[self getNowTime];
    }else if(_flag==2){
        //修改模式
        self.title=@"Edit Message";
        NSLog(@"%@",_receiveEditDic);
        _InfoArray[0]=_receiveEditDic[@"image"];
        _titleText.text=_receiveEditDic[@"title"];
        _dateText.text=_receiveEditDic[@"date"];
        _contentText.text=_receiveEditDic[@"content"];
//        if (_InfoArray.count){
//            _imageView1.image=_receiveEditDic[@"image"];
//        }
        
        [_button setBackgroundColor:[UIColor clearColor]];
        [_button setTitle:@"" forState:UIControlStateNormal];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imagePickerBtn:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新增圖片" message:@"選取方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerImageView =[[UIImagePickerController alloc] init];
        pickerImageView.delegate=self;
        //如果要使用相機要先測試iDevice是否有相機
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerImageView.sourceType=UIImagePickerControllerSourceTypeCamera;
        }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            pickerImageView.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }
        
        pickerImageView.mediaTypes =@[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        
        [self presentViewController:pickerImageView animated:YES completion:nil];
        
        
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"從相簿" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerImageView =[[UIImagePickerController alloc] init];
        pickerImageView.delegate=self;
        pickerImageView.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImageView.mediaTypes =@[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        
        [self presentViewController:pickerImageView animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"關閉" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}




#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_button setBackgroundColor:[UIColor clearColor]];
    [_button setTitle:@"" forState:UIControlStateNormal];
    //    NSLog(@"%@",info);
    self.imageView1.image =info[UIImagePickerControllerOriginalImage];
    [_InfoArray addObject:info[UIImagePickerControllerOriginalImage]];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
