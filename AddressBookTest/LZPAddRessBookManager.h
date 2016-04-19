//
//  LZPAddRessBookManager.h
//  AddressBookTest
//
//  Created by 刘志鹏 on 16/4/19.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#define LZPWeak(lzp_Self) __weak __typeof(&*(lzp_Self))weak##lzp_Self = lzp_Self

@interface LZPAddRessBookManager : NSObject

@property (nonatomic, copy) void(^getAllPerson)(NSMutableArray *allPerson);


// 删除指定的纪录
- (void)removePersonWIthRecord:(ABRecordRef)recordRef;
/**
 *  根据RecordID修改联系人信息
 *
 *  @param recordID   记录唯一ID
 *  @param firstName  姓
 *  @param lastName   名
 *  @param homeNumber 工作电话
 */
-(void)modifyPersonWithRecordID:(ABRecordID)recordID firstName:(NSString *)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber;

/**
 *  添加一条记录
 *
 *  @param firstName  名
 *  @param lastName   姓
 *  @param iPhoneName iPhone手机号
 */
-(void)addPersonWithFirstName:(NSString *)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber;

// 根据名字删除
- (void)removePersonWithName:(NSString *)personName;

// 根据名字判断是否存在
- (BOOL)isPersonWithName:(NSString *)personName;

@end


@interface LZPAddRessBookModel : NSObject

@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *prefix;                      // 前缀
@property (nonatomic, copy) NSString *suffix;                      // 后缀
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *firstNamePinYin;
@property (nonatomic, copy) NSString *lastNamePinYin;
@property (nonatomic, copy) NSString *middleNamePinYin;             //
@property (nonatomic, copy) NSString *origanization;                // 公司
@property (nonatomic, copy) NSString *job;                          // 工作
@property (nonatomic, copy) NSString *department;                   // 部门
@property (nonatomic, strong) NSDate *birthday;                     // 生日
@property (nonatomic, copy) NSString *note;                         // 备注
@property (nonatomic, strong) NSDate *firstKnown;                   // 第一次添加纪录时间
@property (nonatomic, strong) NSDate *lastKnown;                    // 最后一次修改纪录的时间
@property (nonatomic, strong) NSArray *emails;                      // 邮件
@property (nonatomic, strong) NSArray *address;                    // 地址
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSArray *IMs;
@property (nonatomic, strong) NSArray *phones;
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSData *imageData;


- (instancetype)initWith:(ABRecordRef )person;

@end