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
    btn4.frame = CGRectMake(10, CGRectGetMaxY(btn3.frame) + 10, 120, 30);
    btn4.backgroundColor = [UIColor orangeColor];
    [btn4 setTitle:@"人脸变清晰" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(faceClearReturnsBinary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(140, CGRectGetMaxY(btn3.frame) + 10, 100, 30);
    btn5.backgroundColor = [UIColor orangeColor];
    [btn5 setTitle:@"照片上色" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(photoColoringReturnsBinary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];

    
    self.handleImage = [[UIImageView alloc] init];
    self.handleImage.frame = CGRectMake(0, CGRectGetMaxY(btn4.frame) + 10, screenW, screenH/2-50-100);
    self.handleImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.handleImage];
    
}

#pragma mark - 抠图
/**
 * 通用抠图（返回二进制文件流）
 */
- (void)universalReturnsBinary {
    //拼接请求URL
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=6", self.baseUrl];
    //获取图片数据
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    BOOL crop = 1;
    //填充背景色 （非必填）
    NSString *bgColor = @"000000";
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=6", self.baseUrl];
    
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    //BOOL faceAnalysis = 0;
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};
    
    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2", self.baseUrl];
    
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=2", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=2", self.baseUrl];
    
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=3", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=3", self.baseUrl];
    
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"test" withExtension:@"jpeg"];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    //是否裁剪至最小非透明区域 （非必填）
    //BOOL crop = 1;
    //填充背景色 （非必填）
    //NSString *bgColor = @"000000";
    NSDictionary *params = @{}; // @{@"crop" : @(crop), @"bgcolor" : bgColor};

    [[PKZNNetwork shared] uploadFileWithUrlString:urlStr parameters:params data:data success:^(id  _Nonnull responseObject) {
        if (responseObject) {
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=4", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=4", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=11", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=11", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=17", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=17", self.baseUrl];
    
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

#pragma mark - 人脸变清晰

/**
 * 人脸变清晰返回二进制文件流）
 */
- (void)faceClearReturnsBinary {
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=18", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=18", self.baseUrl];
    
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

#pragma mark - 照片上色

/**
 * 照片上色 (返回二进制文件流）
 */
- (void)photoColoringReturnsBinary {
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting?mattingType=19", self.baseUrl];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"%@/matting2?mattingType=19", self.baseUrl];
    
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
@end
