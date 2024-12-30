//
//  CFGameModel.h
//  Tofee
//
//  Created by mac on 2023/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFGameModel : NSObject

// 游戏id
@property (nonatomic,assign) NSInteger g_id;
// 游戏名称
@property (nonatomic,copy) NSString *g_name;
// 游戏icon
@property (nonatomic,copy) NSString *g_icon;
// 游戏地址
@property (nonatomic,copy) NSString *g_url;


@end


@interface CFGamePropsModel : NSObject

//  用户id
@property (nonatomic, copy) NSString *c_uid;
//  道具id
@property (nonatomic, copy) NSString *prop_id;
//  过期时间戳
@property (nonatomic, copy) NSString *expire;
//  数量
@property (nonatomic, copy) NSString *num;

@end



NS_ASSUME_NONNULL_END
