//
//  ProductDetailsWEBController.m
//  shenzhoudc-iPhone
//
//  Created by zzh on 2017/6/15.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

#import "ProductDetailsWEBController.h"

@interface ProductDetailsWEBController ()

@end

@implementation ProductDetailsWEBController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadProductURL];
}

- (void)loadProductURL {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&type=%@", API_GET_PRODUCT_DETAILS_MESSAGE, _productId, @"1"];
    [[AINetworkEngine sharedClient] getWithApi:url parameters:nil CompletionBlock:^(AINetworkResult *result, NSError *error) {
        if (result.isSucceed) {
            NSDictionary *dict = result.getDataObj;
            if ([dict.allKeys containsObject:@"dataInstructionProduct"]) {
                [self webLodURL:dict[@"dataInstructionProduct"]];
            }
        }
    }];
}

- (void)webLodURL:(NSString *)URLStr {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLStr]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
