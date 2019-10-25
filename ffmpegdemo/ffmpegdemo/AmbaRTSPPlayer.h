//
//  AmbaRTSPPlayer.h
//  ffmpegdemo
//
//  Created by zyyk on 2019/10/24.
//  Copyright © 2019 zyyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "avformat.h"
#import "avcodec.h"
#import "avio.h"
#import "swscale.h"

NS_ASSUME_NONNULL_BEGIN

@interface AmbaRTSPPlayer : NSObject{
    AVFormatContext * _formatCtx;
    AVCodecContext * _codexCtx;
    AVCodec * _codec;
    AVFrame * _frame;
    AVPacket packet;
    AVPacket _currentPacket;
    int outputWidth, outputHeight;
    int sourceWidth, sourceHeight;
    int videoStream;
    int audioStream;
    AVPicture picture;
    UIImage * currentImage;
    struct SwsContext * img_convert_ctx;
}

@property (nonatomic, readonly) UIImage *currentImage;
@property (nonatomic) int outputWidth, outputHeight;
@property (nonatomic, readonly) int sourceWidth, sourceHeight;
-(id)initWithVideo:(NSString *)moviePath usesTcp:(BOOL)usesTcp;
-(BOOL)stepFrame;
- (void) stopRTSPDecode;

@end

NS_ASSUME_NONNULL_END
