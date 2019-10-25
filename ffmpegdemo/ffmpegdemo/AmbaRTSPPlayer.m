//
//  AmbaRTSPPlayer.m
//  ffmpegdemo
//
//  Created by zyyk on 2019/10/24.
//  Copyright © 2019 zyyk. All rights reserved.
//

#import "AmbaRTSPPlayer.h"

@interface AmbaRTSPPlayer ()

-(void)convertFrameToRGB;

-(UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height;

-(void)setupScaler;

@end

@implementation AmbaRTSPPlayer

@synthesize outputWidth, outputHeight;

@synthesize sourceHeight, sourceWidth;

volatile bool _stopDecode;

- (instancetype)init{
    if (self = [super init]) {
        _stopDecode = false;
    }
    return self;
}

- (id)initWithVideo:(NSString *)streamPath usesTcp:(BOOL)usesTcp{
    if (!(self = [super init])) {
        return nil;
    }
    AVCodec *pCodec;
    avcodec_register_all();
    av_register_all();
    
    avformat_network_init();
    
    AVDictionary *opts = 0;
    if (usesTcp) {
        av_dict_set(&opts, "rtsp_transport", "tcp", 0);
    }
    NSLog(@"%s", [streamPath cStringUsingEncoding:NSASCIIStringEncoding]);
    if (avformat_open_input(&_formatCtx, [streamPath cStringUsingEncoding:NSASCIIStringEncoding], NULL, &opts) != 0) {
        av_log(NULL, AV_LOG_ERROR, "Unable to open file\n");
        NSLog(@"Unable to open file\n");
        goto initError;
    }
    av_dict_free(&opts);
    
    _formatCtx->flags |= AVFMT_FLAG_NOBUFFER;
//    _formatCtx->flags |= AVFMT_FLAG_NONBLOCK;
    _formatCtx->flags |= AVFMT_FLAG_DISCARD_CORRUPT;
    
    if (avformat_find_stream_info(_formatCtx, NULL) == 0) {
        av_log(NULL, AV_LOG_ERROR, "Unable to open file\n");
        NSLog(@"Unable to open file\n");
        goto initError;
    }
    
    videoStream = -1;
    audioStream = -1;
    for ( int i=0; i < _formatCtx->nb_streams; i++){

        if (_formatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO){

            NSLog(@":Found Video Stream");

            videoStream = i;

        }
        if (_formatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO){
            audioStream = i;
            NSLog(@"Found Audio Stream");
        }
    }
    if ( videoStream== -1 && audioStream== -1){
        goto initError;
    }
    
    //Step 5: Get ptr to codec Context from the video stream

    //Codec Context has all info about the codec the stream is using

    _codexCtx = _formatCtx->streams[videoStream]->codec;
    //Detect the type of codec
    pCodec = avcodec_find_decoder(_codexCtx->codec_id);

    if (pCodec  == NULL){
        av_log(NULL, AV_LOG_ERROR,"Unsupported Codec");
        NSLog(@"Unsupported Codec!!!!!!!!");
        goto initError;
    }
    _codexCtx->skip_frame = AVDISCARD_NONREF;
    //Step 6: Now Open the Codec

    if (avcodec_open2(_codexCtx,pCodec, NULL) !=  0){
        av_log(NULL, AV_LOG_ERROR, "Unable to Open Video Decoder");
        NSLog(@"Unable to Open Video Decoder");
        goto initError;
    }
    //Step 7:Similar steps for Audio
    if (audioStream > -1){
        NSLog(@"SetUp Audio Decoder");
        [self setupAudioDecoder];
    }
    //Step 8: Allocate Video Frame

    _frame = av_frame_alloc();

    outputWidth = _codexCtx->width;

    outputHeight = _codexCtx->height;

    _stopDecode = false;

    return self;
    
    initError:

        NSLog(@"Error: Release Self");

        return nil;
    
}

- (int)sourceWidth{
    return _codexCtx->width;
}

- (int)sourceHeight{
    return _codexCtx->height;
}

- (void) setupAudioDecoder{
    NSLog(@"For this version Skipping Audio Decoding");
}

//解码视频得到帧

- (BOOL)stepFrame{
    int frameFinished = 0;
    while (!_stopDecode && !frameFinished && av_read_frame(_formatCtx, &packet) >= 0){
        if(packet.stream_index == videoStream) {
            //Decode video Frame
            avcodec_decode_video2(_codexCtx, _frame, &frameFinished, &packet);
        }

        //if (packet.stream_index == audioStream) {

        //    NSLog(@"Audio Stream");

        //}

    }
    return frameFinished;
}

- (UIImage *)currentImage{
    if (!_frame->data[0]) return nil;
    [self convertFrameToRGB];

    return [self imageFromAVPicture:picture width:outputWidth height:outputHeight];
}

//转换音视频帧到RGB

-(void) convertFrameToRGB

{

    //release old picture and scaler

    avpicture_free(&picture);

    sws_freeContext(img_convert_ctx);

    

    

    // Allocate RGB picture

    avpicture_alloc(&picture, AV_PIX_FMT_RGB24, outputWidth, outputHeight);

    // Setup scaler

    static int sws_flags =  SWS_FAST_BILINEAR;

    img_convert_ctx = sws_getContext(_codexCtx->width,

                                     _codexCtx->height,

                                     ////_codexCtx->pix_fmt,

                                     AV_PIX_FMT_YUV420P,
                                      outputWidth,

                                    outputHeight,

                                     AV_PIX_FMT_RGB24,

                                                                          sws_flags,

                                                                          NULL,

                                                                          NULL,

                                                                          NULL

                                                                          );

                                         sws_scale(img_convert_ctx,

                                                   (uint8_t const * const *)_frame->data,

                                                   _frame->linesize,

                                                   0,

                                                   _codexCtx->height,

                                                   picture.data,

                                                   picture.linesize);
    
}

- (UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height

{

    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;

    CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);

    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGImageRef cgImage = CGImageCreate(width,

                                       height,

                                       8,

                                       24,

                                       pict.linesize[0],

                                       colorSpace,

                                       bitmapInfo,

                                       provider,
                                       NULL,

                                                                              NO,

                                                                              kCGRenderingIntentDefault);

                                           CGColorSpaceRelease(colorSpace);

                                           UIImage *image = [UIImage imageWithCGImage:cgImage];

                                           

                                           CGImageRelease(cgImage);

                                           CGDataProviderRelease(provider);

                                           CFRelease(data);

                                           

                                           return image;
}

- (void) stopRTSPDecode{
    _stopDecode = true;
}




@end
