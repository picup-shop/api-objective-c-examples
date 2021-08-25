//
//  ViewController.m
//  api-oc-examples
//
//  Created by Eleven_Liu on 2021/8/23.
//

#import "ViewController.h"
#import "PKZNNetwork.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) UIImageView *originalImage;
@property (nonatomic, strong) UIImageView *handleImage;
@property (nonatomic, strong) NSString *baseUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.baseUrl = @"https://picupapi.tukeli.net/api/v1";
    
    // 测试物体,通用,头像，人像 图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    UIImage *testImg = [UIImage imageWithContentsOfFile:path];
    
    self.originalImage = [[UIImageView alloc] init];
    self.originalImage.image = testImg;
    self.originalImage.frame = CGRectMake(0, 50, screenW, screenH/2-50-50);
    self.originalImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.originalImage];
    
    
    // 切换方法名进行不同方法调用
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, CGRectGetMaxY(self.originalImage.frame) + 10, 50, 30);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"抠图" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(universalReturnsBinary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(70, CGRectGetMaxY(self.originalImage.frame) + 10, 100, 30);
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setTitle:@"一键美化" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(beautifyReturnsBinary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(180, CGRectGetMaxY(self.originalImage.frame) + 10, 70, 30);
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setTitle:@"动漫化" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(animeReturnsBinary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(260, CGRectGetMaxY(self.originalImage.frame) + 10, 100, 30);
    btn3.backgroundColor = [UIColor orangeColor];
    [btn3 setTitle:@"卡通头像" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(avatarCartoonReturnsBinary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(10, CGRectGetMaxY(btn3.frame) + 10, 110, 30);
    btn4.backgroundColor = [UIColor orangeColor];
    [btn4 setTitle:@"人脸变清晰" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(faceClearReturnsBinary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(130, CGRectGetMaxY(btn3.frame) + 10, 90, 30);
    btn5.backgroundColor = [UIColor orangeColor];
    [btn5 setTitle:@"照片上色" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(photoColoringReturnsBase64) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];

    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.frame = CGRectMake(230, CGRectGetMaxY(btn3.frame) + 10, 70, 30);
    btn6.backgroundColor = [UIColor orangeColor];
    [btn6 setTitle:@"证件照" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(idPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self .view addSubview:btn6];

    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.frame = CGRectMake(310, CGRectGetMaxY(btn3.frame) + 10, 90, 30);
    btn7.backgroundColor = [UIColor orangeColor];
    [btn7 setTitle:@"图片修复" forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(imageFix) forControlEvents:UIControlEventTouchUpInside];
    [self .view addSubview:btn7];
    
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn8.frame = CGRectMake(10, CGRectGetMaxY(btn7.frame) + 10, 70, 30);
    btn8.backgroundColor = [UIColor orangeColor];
    [btn8 setTitle:@"风格化" forState:UIControlStateNormal];
    [btn8 addTarget:self action:@selector(styleTransfer) forControlEvents:UIControlEventTouchUpInside];
    [self .view addSubview:btn8];
    
    
    self.handleImage = [[UIImageView alloc] init];
    self.handleImage.frame = CGRectMake(0, CGRectGetMaxY(btn8.frame) + 20, screenW, screenH/2-50-150);
    self.handleImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.handleImage];
}

#pragma mark - 抠图
/**
 * 通用抠图（返回二进制文件流）
 */
- (void)universalReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求URL
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=6", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    BOOL crop = 0;
    //填充背景色 （非必填）
    NSString *bgColor = @"";
    NSDictionary *params = @{@"crop" : @(crop), @"bgcolor" : bgColor};
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            //得到处理后的图片
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 通用抠图（返回Base64字符串）
 */
- (void)universalReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=6", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    //BOOL faceAnalysis = 0;
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

/**
 * 通用抠图（通过图片URL返回Base64字符串）
 */
- (void)universalByImageUrl {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/mattingByUrl", self.baseUrl];
    
    // 抠图类型,1：人像，2：物体，3：头像，4：一键美化，6：通用抠图，11：卡通化，17: 卡通头像，18: 人脸变清晰， 19: 照片上色
    NSInteger mattingType = 6;
    
    NSString *imgUrl = @"https://c-ssl.duitang.com/uploads/item/201908/08/20190808151534_tdivh.thumb.1000_0.jpg";
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    // 人脸检测点信息 （非必填）
    //BOOL faceAnalysis = 0;
    
    NSDictionary *params = @{@"mattingType" : @(mattingType), @"url" : imgUrl};
        
    [[PKZNNetwork shared] getWithUrlString:urlStr parameters:params success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
    
    }];
}

#pragma mark -

/**
 * 人像抠图（返回二进制文件流）
 */
- (void)portraitReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 人像抠图（返回Base64字符串）
 */
- (void)portraitReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark -

/**
 * 物体抠图（返回二进制文件流）
 */
- (void)objectReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=2", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 物体抠图（返回Base64字符串）
 */
- (void)objectReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=2", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark -

/**
 * 头像抠图（返回二进制文件流）
 */
- (void)avatarReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=3", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 头像抠图（返回Base64字符串）
 */
- (void)avatarReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=3", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 一键美化

/**
 * 一键美化（返回二进制文件流）
 */
- (void)beautifyReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=4", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 一键美化（返回Base64字符串）
 */
- (void)beautifyReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=4", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 动漫化

/**
 * 动漫化（返回二进制文件流）
 */
- (void)animeReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=11", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 动漫化（返回Base64字符串）
 */
- (void)animeReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=11", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 卡通头像

/**
 * 卡通头像（返回二进制文件流）
 */
- (void)avatarCartoonReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=17", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 卡通头像（返回Base64字符串）
 */
- (void)avatarCartoonReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=17", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 人脸变清晰

/**
 * 人脸变清晰返回二进制文件流）
 */
- (void)faceClearReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=18", self.baseUrl];
    //图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 人脸变清晰（返回Base64字符串）
 */
- (void)faceClearReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=18", self.baseUrl];
    //图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 照片上色

/**
 * 照片上色 (返回二进制文件流）
 */
- (void)photoColoringReturnsBinary {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=19", self.baseUrl];
    //图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.handleImage.image = responseObject;
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}

/**
 * 照片上色（返回Base64字符串）
 */
- (void)photoColoringReturnsBase64 {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=19", self.baseUrl];
    //图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:@{} data:data success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"imageBase64"] options:0];
            self.handleImage.image = [UIImage imageWithData:imageData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 证件照

- (void)idPhoto {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image_fix.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlString = [NSString stringWithFormat:@"%@/idphoto/printLayout", self.baseUrl];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //头像文件的base64
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"image_fix" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *encodedImageStr = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    [params setValue:encodedImageStr forKey:@"base64"];
    //证件照背景色
    [params setValue:@"0000FF" forKey:@"bgColor"];
    //证件照渐变背景色（非必填）
    [params setValue:@"0000FF" forKey:@"bgColor2"];
    //证件照打印dpi，一般为300
    [params setValue:@300 forKey:@"dpi"];
    //证件照物理高度，单位为毫米
    [params setValue:@35 forKey:@"mmHeight"];
    //证件照物理宽度，单位为毫米
    [params setValue:@25 forKey:@"mmWidth"];
    //排版背景色
    [params setValue:@"FFFFFF" forKey:@"printBgColor"];
    //打印的排版尺寸(高度)，单位为毫米
    [params setValue:@210 forKey:@"printMmHeight"];
    //打印的排版尺寸(宽度)，单位为毫米
    [params setValue:@150 forKey:@"printMmWidth"];
    //换装参数，填需额外扣除一个点点数
    //[params setValue:@"" forKey:@"dress"];
    [[PKZNNetwork shared] postWithUrlString:urlString parameters:params success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            //处理后的图片地址, 单个证件照的图片地址，url在十分钟内访问有效
            NSString *idPhotoImage = responseObject[@"data"][@"idPhotoImage"];
            //通过url获取网络数据
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:idPhotoImage]];
            //将数据转换为图片
            self.handleImage.image = [UIImage imageWithData:data];
            
            NSLog(@"idPhotoImage %@", idPhotoImage);
        }
    } failure:^(NSError * _Nonnull error) {
            
    }];
}


#pragma mark - 照片修复

- (void)imageFix {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image_fix.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlString = [NSString stringWithFormat:@"%@/imageFix", self.baseUrl];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //头像文件的base64
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"image_fix" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *encodedImageStr = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    [params setValue:encodedImageStr forKey:@"base64"];
    //mask图片文件转为base64字符串, 同时支持单通道，三通道，四通道黑白图片，修复区域为纯白色，其它区域为黑色。如果此字段有值，则矩形区域参数无效
    NSURL *fileUrlMask = [NSBundle.mainBundle URLForResource:@"mask" withExtension:@"jpeg"];
    NSData *dataMask = [NSData dataWithContentsOfURL:fileUrlMask];
    NSData *base64DataMask = [dataMask base64EncodedDataWithOptions:0];
    NSString *encodedImageStrMask = [[NSString alloc]initWithData:base64DataMask encoding:NSUTF8StringEncoding];
    [params setValue:encodedImageStrMask forKey:@"maskBase64"];
    //矩形区域, 支持多个数组
    //NSMutableArray *rectangles = [NSMutableArray array];
    //NSDictionary *rectangle1 = @{@"height" : @100, @"width" : @100, @"x" : @160, @"y" : @280};
    //NSDictionary *rectangle2 = @{@"height" : @100, @"width" : @100, @"x" : @560, @"y" : @680};
    //[rectangles addObject:rectangle1];
    //[rectangles addObject:rectangle2];
    //[params setValue:rectangles forKey:@"rectangles"];
    [[PKZNNetwork shared] postWithUrlString:urlString parameters:params success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            //处理后的图片地址
            NSString *imageUrl = responseObject[@"data"][@"imageUrl"];
            //通过url获取网络数据
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            //将数据转换为图片
            self.handleImage.image = [UIImage imageWithData:data];
            
            NSLog(@"imageUrl %@", imageUrl);
        }
    } failure:^(NSError * _Nonnull error) {
            
    }];
}


#pragma mark - 风格化

- (void)styleTransfer {
    //设置示例图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cat.jpeg" ofType:nil];
    self.originalImage.image = [UIImage imageWithContentsOfFile:path];
    
    //拼接请求地址
    NSString *urlString = [NSString stringWithFormat:@"%@/styleTransferBase64", self.baseUrl];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //输入待转化的图片文件的base64
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"cat" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *encodedImageStr = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    [params setValue:encodedImageStr forKey:@"contentBase64"];
    //输入风格图片文件的base64
    NSURL *fileUrlMask = [NSBundle.mainBundle URLForResource:@"style" withExtension:@"jpeg"];
    NSData *dataMask = [NSData dataWithContentsOfURL:fileUrlMask];
    NSData *base64DataMask = [dataMask base64EncodedDataWithOptions:0];
    NSString *encodedImageStrMask = [[NSString alloc]initWithData:base64DataMask encoding:NSUTF8StringEncoding];
    [params setValue:encodedImageStrMask forKey:@"styleBase64"];
    
    [[PKZNNetwork shared] postWithUrlString:urlString parameters:params success:^(id  _Nonnull responseObject) {
        if (responseObject && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"0"]) {
            //处理完成后结果图片的临时url，请及时下载，五分钟内失效
            NSString *imageUrl = responseObject[@"data"];
            //通过url获取网络数据
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            //将数据转换为图片
            self.handleImage.image = [UIImage imageWithData:data];
            
            NSLog(@"imageUrl %@", imageUrl);
        }
    } failure:^(NSError * _Nonnull error) {
            
    }];
}

@end
