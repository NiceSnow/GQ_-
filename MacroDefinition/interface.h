//
//  interface.h
//  GQ_****
//
//  Created by Madodg on 2017/11/30.
//  Copyright © 2017年 Madodg. All rights reserved.
//

#ifndef interface_h
#define interface_h

#ifdef Start_LogService
#define LogService YES
#else
#define LogService NO
#endif

#ifdef Show_FPS
#define FPS YES
#else
#define FPS NO
#endif

#define URLAddress \
@{\
@"url1":@"www.baidu.com",\
@"url2":@"www.gq.com"\
}

#define RequestURL(url) [NSString stringWithFormat:@"%@/%@",URLAddress[URLKEY],url]

#define LoginURL @"GQ/Login"

#endif /* interface_h */
