//
//  ViewController.m
//  LRQQRCodeScan
//
//  Created by lirenqiang on 2016/12/29.
//  Copyright © 2016年 Ninja. All rights reserved.
//

// reference: https://github.com/kingsic/SGQRCode

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    
    [self scanQRCodeFromPhotosInAlbum:[UIImage new]];
}

- (void)setupScanningQRCode
{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) {
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
//    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    // 初始化连接对象(会话对象)
    self.session = [[AVCaptureSession alloc] init];
    
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //add session input
    [_session addInput:input];
    //output
    [_session addOutput:output];
    
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    _previewLayer.frame = self.view.layer.bounds;
//    _previewLayer.automaticallyAdjustsMirroring = NO;
//    _previewLayer.mirrored = YES;
    _previewLayer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_previewLayer above:0];
    [_session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate function
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_session stopRunning];

    AVMetadataMachineReadableCodeObject * obj = metadataObjects[0];
    NSString *stringValue = obj.stringValue;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue] options:@{} completionHandler:^(BOOL success) {
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor redColor];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma mark - Scan QRCode From Album
- (void)scanQRCodeFromPhotosInAlbum:(UIImage *)image
{
    image = [UIImage imageNamed:@"123"];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    //get scan result
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (NSInteger i = 0; i < [features count]; ++i) {
        CIQRCodeFeature *feature = [features objectAtIndex:i];
        NSString *scannedResult = feature.messageString;
        NSLog(@"result: %@", scannedResult);
        
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor redColor];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - 获取扫描区域的比例关系
//- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
//{
//    CGFloat x, y, width, height;
//    
////    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
//    y
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


















































