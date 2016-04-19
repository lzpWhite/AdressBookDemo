//
//  LZPAddRessBookManager.m
//  AddressBookTest
//
//  Created by 刘志鹏 on 16/4/19.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//

#import "LZPAddRessBookManager.h"

@interface LZPAddRessBookManager ()

@property (nonatomic, assign) ABAddressBookRef addressBook;

@end

@implementation LZPAddRessBookManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        LZPWeak(self);
        
        self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
            if (!granted) {
                NSLog(@"未获取通讯录访问权限");
            }
            
            [weakself createAllPerson];
        });
        
    }
    return self;
}


- (void)createAllPerson
{
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        NSLog(@"为获取权限");
        return;
    }
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    NSMutableArray * allPerson = (__bridge NSMutableArray *)allPeople;
    
    if (self.getAllPerson) {
        self.getAllPerson(allPerson);
    }
    
    CFRelease(allPeople);
    
}
// 删除指定的纪录
- (void)removePersonWIthRecord:(ABRecordRef)recordRef {
    ABAddressBookRemoveRecord(self.addressBook, recordRef, NULL);
    ABAddressBookSave(self.addressBook, NULL);
}
// 根据名字删除
- (void)removePersonWithName:(NSString *)personName {
    CFStringRef personNameRef = (__bridge CFStringRef)(personName);
    CFArrayRef recordsRef = ABAddressBookCopyPeopleWithName(self.addressBook, personNameRef);
    CFIndex count = CFArrayGetCount(recordsRef);
    
    for (CFIndex i=0 ; i<count; i++) {
        ABRecordRef recordRef = CFArrayGetValueAtIndex(recordsRef, i);
        ABAddressBookRemoveRecord(self.addressBook, recordRef, NULL);
    }
    ABAddressBookSave(self.addressBook, NULL);
    CFRelease(recordsRef);
}

// 根据名字判断是否存在
- (BOOL)isPersonWithName:(NSString *)personName {
    CFStringRef personNameRef = (__bridge CFStringRef)(personName);
    CFArrayRef recordsRef = ABAddressBookCopyPeopleWithName(self.addressBook, personNameRef);
    CFIndex count = CFArrayGetCount(recordsRef);
    CFRelease(recordsRef);
    if (count>0) {
        return YES;
    }
    return NO;
}

/**
 *  添加一条记录
 *
 *  @param firstName  名
 *  @param lastName   姓
 *  @param iPhoneName iPhone手机号
 */
-(void)addPersonWithFirstName:(NSString *)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber{
    //创建一条记录
    ABRecordRef recordRef= ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), NULL);//添加名
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), NULL);//添加姓
    
    ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);//添加设置多值属性
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)(workNumber), kABWorkLabel, NULL);//添加工作电话
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    
    //添加记录
    ABAddressBookAddRecord(self.addressBook, recordRef, NULL);
    
    //保存通讯录，提交更改
    ABAddressBookSave(self.addressBook, NULL);
    //释放资源
    CFRelease(recordRef);
    CFRelease(multiValueRef);
}

/**
 *  根据RecordID修改联系人信息
 *
 *  @param recordID   记录唯一ID
 *  @param firstName  姓
 *  @param lastName   名
 *  @param homeNumber 工作电话
 */
-(void)modifyPersonWithRecordID:(ABRecordID)recordID firstName:(NSString *)firstName lastName:(NSString *)lastName workNumber:(NSString *)workNumber{
    ABRecordRef recordRef=ABAddressBookGetPersonWithRecordID(self.addressBook,recordID);
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), NULL);//添加名
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), NULL);//添加姓
    
    ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)(workNumber), kABWorkLabel, NULL);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    //保存记录，提交更改
    ABAddressBookSave(self.addressBook, NULL);
    //释放资源
    CFRelease(multiValueRef);
}

- (void)dealloc
{
    if (self.addressBook != NULL) {
        CFRelease(self.addressBook);
    }
}


@end

















@implementation LZPAddRessBookModel : NSObject

- (instancetype)initWith:(ABRecordRef)person
{
    
    if (self = [super init])
        {
            
            _recordId = ABRecordGetRecordID(person);
            //读取firstname
            _personName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            if(_personName.length==0) {
                _personName = @"";
            }
            
            //读取lastname
            _lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            if(_lastName.length==0)
            {
                _lastName = @"";
            }
            //读取middlename
            _middleName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
            if(_middleName == 0) {
                _middleName = @"";
            }
                
            //读取prefix前缀
            _prefix = (__bridge NSString *)ABRecordCopyValue(person, kABPersonPrefixProperty);
            if(_prefix.length == 0)
            {
                _prefix = @"";
            }
            //读取suffix后缀
            _suffix = (__bridge NSString *)ABRecordCopyValue(person, kABPersonSuffixProperty);
            if(_suffix.length == 0)
            {
                _suffix = @"";
            }
            //读取nickname呢称
            _nickName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonNicknameProperty);
            if(_nickName.length == 0)
            {
                _nickName = @"";
            }
            //读取firstname拼音音标
            _firstNamePinYin = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
            if (_firstNamePinYin.length == 0) {
                _firstNamePinYin = @"";
            }
            //读取lastname拼音音标
            _lastNamePinYin =
            
            _lastNamePinYin = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
            if(_lastNamePinYin.length == 0)
            {
                _lastNamePinYin = @"";
            }
            
            //读取middlename拼音音标
            _middleNamePinYin = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
            if(_middleNamePinYin.length == 0)
            {
                _middleNamePinYin = @"";
            }
            //读取organization公司
            _origanization = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
            if(_origanization.length == 0)
            {
                _origanization = @"";
            }
            //读取jobtitle工作
            _job = (__bridge NSString *)ABRecordCopyValue(person, kABPersonJobTitleProperty);
            if(_job.length == 0){
                _job = @"";
            }
            //读取department部门
            
            _department = (__bridge NSString *)ABRecordCopyValue(person, kABPersonDepartmentProperty);
            if(_department.length == 0) {
                _department = @"";
            }
            //读取birthday生日
            _birthday = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonBirthdayProperty);
            //读取note备忘录
            _note = (__bridge NSString *)ABRecordCopyValue(person, kABPersonNoteProperty);
            if(_note.length == 0)
            {
                _note = @"";
            }
            //第一次添加该条记录的时间
            _firstKnown = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonCreationDateProperty);
            
            //最后一次修改該条记录的时间
            _lastKnown = (__bridge NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
            
            
            NSMutableArray *array = [NSMutableArray array];
            
            //获取email多值
            ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
            CFIndex emailcount = ABMultiValueGetCount(email);
            for (CFIndex x = 0; x < emailcount; x++)
            {
                //获取email Label
                NSString* emailLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
                if (emailLabel.length == 0) {
                    emailLabel = @"";
                }
                //获取email值
                NSString* emailContent = (__bridge NSString *)ABMultiValueCopyValueAtIndex(email, x);
                if (emailContent.length == 0) {
                    emailContent = @"";
                }
                
                [array addObject:@{emailLabel:emailContent}];
            }
            
            _emails = array;
            
            
            array = [NSMutableArray array];
            //读取地址多值
            ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
            CFIndex count = ABMultiValueGetCount(address);
            
            for(CFIndex j = 0; j < count; j++)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                //获取地址Label
                NSString* addressLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(address, j);
                if (addressLabel.length>0 ) {
                    [dict setObject:addressLabel forKey:@"address"];
                }
                //获取該label下的地址6属性
                NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
                NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
                if(country.length > 0)
                {
                   [dict setObject:country forKey:@"country"];
                }
                NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
                if(city.length > 0) {
                    [dict setObject:city forKey:@"city"];
                }
                
                NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
                if(state.length > 0) {
                    [dict setObject:state forKey:@"state"];
                }
                NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
                if(street.length > 0) {
                    [dict setObject:street forKey:@"street"];
                }
                NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
                if(zip.length > 0)
                {
                    [dict setObject:zip forKey:@"zip"];
                }
                NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
                if(coutntrycode.length > 0)
                {
                    [dict setObject:coutntrycode forKey:@"coutntrycode"];
                }
            }
            
            _address = array;
            
            
            
            array = [NSMutableArray array];
            //获取dates多值
            ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
            CFIndex datescount = ABMultiValueGetCount(dates);
            for (CFIndex y = 0; y < datescount; y++)
            {
                //获取dates Label
                NSString* datesLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
                if (datesLabel.length==0) {
                    datesLabel = @"";
                }
                //获取dates值
                NSDate* datesContent = (__bridge NSDate *)ABMultiValueCopyValueAtIndex(dates, y);
                if (datesContent) {
                    [array addObject:@{datesLabel:datesContent}];
                }
                
            }
            
            _dates = array;
            
            //获取kind值
            CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
            if (recordType == kABPersonKindOrganization) {
                // it's a company
                NSLog(@"it's a company\n");
            } else {
                // it's a person, resource, or room
                NSLog(@"it's a person, resource, or room\n");
            }
            
            array = [NSMutableArray array];
            //获取IM多值
            ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
            for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
            {
                //获取IM Label
                NSString* instantMessageLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(instantMessage, l);
                if (instantMessageLabel.length == 0) {
                    instantMessageLabel = @"";
                }
                //获取該label下的2属性
                NSDictionary* instantMessageContent =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
                NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
                if(username.length == 0) {
                    username = @"";
                }
                
                NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
                if(service.length == 0) {
                    service = @"";
                }
                
                [array addObject:@{instantMessageLabel:instantMessageContent,@"username":username,@"service":service}];
                    
            }
            _IMs = array;
            
            
            array = [NSMutableArray array];
            //读取电话多值
            ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for (int k = 0; k<ABMultiValueGetCount(phone); k++)
            {
                //获取电话Label
                NSString * personPhoneLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
                if (personPhoneLabel.length == 0) {
                    personPhoneLabel = @"";
                }
                //获取該Label下的电话值
                NSString * personPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, k);
                if (personPhone.length == 0) {
                    personPhone = @"";
                }
                
                [array addObject:@{personPhoneLabel:personPhone}];
            }
            
            _phones = array;
            array = [NSMutableArray array];
            //获取URL多值
            ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
            for (int m = 0; m < ABMultiValueGetCount(url); m++)
            {
                //获取电话Label
                NSString * urlLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
                if (urlLabel.length == 0) {
                    urlLabel = @"";
                }
                //获取該Label下的电话值
                NSString * urlContent = (__bridge NSString *)ABMultiValueCopyValueAtIndex(url,m);
                if (urlContent.length == 0) {
                    urlContent = @"";
                }
                
                [array addObject:@{urlLabel:urlContent}];
            }
            
            _urls = array;
            
            //读取照片
            _imageData = (__bridge NSData*)ABPersonCopyImageData(person);
            
    }
    
    return self;
}

@end

