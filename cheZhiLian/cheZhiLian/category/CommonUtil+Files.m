//
//  CommonFiles.m
//  Nightclub
//
//  Created by 赵 伟 on 13-11-27.
//  Copyright (c) 2013年 赵伟. All rights reserved.
//

#import "CommonUtil+Files.h"

@implementation CommonUtil (Files)

/****************** 关于文件管理方法 <S> ******************/

// 检查本地文件是否存在
+ (BOOL)isfileExistsAtPath:(NSString *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

// 读取本地“FileDocuments”目录下的文件
+ (NSString *)readFileOfFileDocuments:(NSString *)filename {
    // 指向文件目录
    NSString *plistFilePath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileDocuments"];
    
    // 文件路径
    NSString *filePath= [plistFilePath stringByAppendingPathComponent:filename];
    // 文件存在判断
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // 读取文件
        return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    } else {
        return @"";
    }
}

// 保存字符串到本地“FileDocuments”目录
+ (void)saveStringToLocal:(NSString *)string toFileName:(NSString *)filename {
    // 指向文件目录
    NSString *plistFilePath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileDocuments"];
    
    // 判断目录是否存在,不存在创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:plistFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 文件路径
    NSString *filePath= [plistFilePath stringByAppendingPathComponent:filename];
    [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil]; //写入文件
}

// 删除本地“FileDocuments”目录下的文件
+ (void)deleteAllFileOfFileDocuments {
    [self deleteAllFileOfFileDocuments:nil];
}

// 删除本地“FileDocuments”目录下的指定类型文件
+ (void)deleteAllFileOfFileDocuments:(NSString *)fileExtension {
    if ([fileExtension isEqualToString:@""]) fileExtension = nil;
    
    // 指向文件目录
    NSString *plistFilePath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileDocuments"];
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:plistFilePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if (fileExtension) {
            if ([[filename pathExtension] isEqualToString:fileExtension]) {     // 从路径的最后一个组成部分中提取其扩展名
                [[NSFileManager defaultManager] removeItemAtPath:[plistFilePath stringByAppendingPathComponent:filename] error:NULL];
            }
        }else {
            [[NSFileManager defaultManager] removeItemAtPath:[plistFilePath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

// 保存任意数据到本地“FileDocuments”目录
+ (void)saveDataToLocal:(id)data toFileName:(NSString *)filename {
    // 指向文件目录
    NSString *plistFilePath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FileDocuments"];
    
    // 判断目录是否存在,不存在创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:plistFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 文件保持路径
    NSString *filePath= [plistFilePath stringByAppendingPathComponent:filename];
    [data writeToFile:filePath atomically:YES];     //写入文件
}

// 创建文件到指定位置
+ (void)createFileForObject:(id)object toSubDirectorys:(NSString *)subDirectory toFileName:(NSString *)fileName {
    // 数据/文件名 检查
    if (!object || !fileName) return;
    
    // Documents目录地址
    NSString *documentsPath = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    /*
     // 第二种写法 获取Documents目录路径
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsPath = [paths objectAtIndex:0]; //获取完整路径
     */
    
    // 文件目录路径
    NSString *plistFilePath = documentsPath;
    
    // 判断中间文件夹目录
    if (subDirectory && ![subDirectory isEqualToString:@""]) {
        plistFilePath = [NSString stringWithFormat:@"%@/%@",documentsPath,subDirectory];     // 获取子文件夹路径
    }
    
    // 判断目录是否存在,不存在创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:plistFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 取得文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",plistFilePath,fileName];
    // 写入文件
    [object writeToFile:filePath atomically:YES];
    /*
     // 第二种写法 创建文件
     [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
     */
    
    
    // 对文件重命名//移动文件
    //    NSString *pathPng = [self getFilePathOfDocumentDirectory:@"123.png" subDirectoryName:@"lianxr"];
    //    NSString *newPath = [self getFilePathOfDocumentDirectory:@"头像.png" subDirectoryName:@"lianxr"];
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:pathPng]) {
    //        if ([[NSFileManager defaultManager] moveItemAtPath:pathPng toPath:newPath error:nil] != YES){
    //            NSLog(@"Unable to move file");
    //        }
    //    }
    
    //    // 删除文件
    //    if ([[NSFileManager defaultManager] removeItemAtPath:newPath error:nil] != YES) {
    //        NSLog(@"Unable to delete file");
    //    }
    
    //    // 获得文件的属性
    //    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:newPath error:nil];
    //    if (fileAttributes != nil) {
    //        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];                  // 获取文件的字节大小
    //        NSString *fileOwner = [fileAttributes objectForKey:NSFileCreationDate];         // 文件创建日期
    //        NSString *creationDate = [fileAttributes objectForKey:NSFileOwnerAccountName];  // 文件所有者
    //        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];     // 获取文件的修改时间
    //
    //        NSLog(@"字节大小: %qi bytes", [fileSize unsignedLongLongValue]);
    //        NSLog(@"创建日期: %@", creationDate);
    //        NSLog(@"所有者名: %@", fileOwner);
    //        NSLog(@"修改时间: %@", fileModDate);
    //    }
}

// 获取指定文件名、指定目录的本地路径
+ (NSString *)getFilePath:(NSString *)fileName toSubDirectorys:(NSString *)subDirectory {
    // Documents目录地址
    NSString *documentsPath = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    
    // 文件目录路径
    NSString *plistFilePath = documentsPath;
    
    // 判断中间文件夹目录
    if (subDirectory && ![subDirectory isEqualToString:@""]) {
        plistFilePath = [NSString stringWithFormat:@"%@/%@",documentsPath,subDirectory];     // 获取子文件夹路径
    }
    
    // 取得文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",plistFilePath,fileName];
    return filePath;
}

// 根据指定路径获取文件大小
+ (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (CGFloat)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

// 删除本地图片缓存文件
+ (void)deleteImageOfDataCache {
    // 获取Caches目录路径的方法       ---缓存目录
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [cachesPaths objectAtIndex:0];
    // 获取“DataCache”的目标路径
    NSString *diskCachePath = [cachesDir stringByAppendingPathComponent:@"DataCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        if ([[attrs fileModificationDate] compare:expirationDate]==NSOrderedAscending)
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

@end
