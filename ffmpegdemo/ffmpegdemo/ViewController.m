//
//  ViewController.m
//  ffmpegdemo
//
//  Created by zyyk on 2019/8/20.
//  Copyright © 2019 zyyk. All rights reserved.
//

#import "ViewController.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfilter.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    av_register_all();
    char info[10000] = {0};
    printf("%s\n", avcodec_configuration());
    sprintf(info, "%s\n", avcodec_configuration());
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    NSLog(@"%@", info_ns);
}

- (IBAction)clicktoprotocol:(id)sender {
}
- (IBAction)clicktoformat:(id)sender {
}
- (IBAction)clicktocodec:(id)sender {
}
- (IBAction)clicktofilter:(id)sender {
}
- (IBAction)clicktoconfigure:(id)sender {
}

@end
