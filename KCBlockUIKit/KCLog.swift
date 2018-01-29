//
//  KCLog.swift
//  WishClound
//
//  Created by karsa on 2018/1/29.
//  Copyright © 2018年 bugu. All rights reserved.
//

import Foundation

public let KCLogContentChanged_Notification = "KCLogContentChanged_Notification"

public class KCLogManager {
    public  static let share = KCLogManager()
    
    private var logs : [KCLog] = []
    
    public func addLog(log : KCLog) {
        logs.insert(log, at: 0)
        NotificationCenter.default.post(name: NSNotification.Name.init(KCLogContentChanged_Notification),
                                        object: nil)
    }
    
    public func clearAll() {
        logs.removeAll()        
        NotificationCenter.default.post(name: NSNotification.Name.init(KCLogContentChanged_Notification),
                                        object: nil)
    }
    
    public func filterLog(with tags : [String]) -> [KCLog] {
        return logs.flatMap({ (log) -> KCLog? in
            for tag in tags {
                if log.tags.contains(tag) {
                    return log
                }
            }
            return nil
        })
    }
}

public class KCLog {
    public class KCLogItem {
        var content : String
        var otherInfo : Any? = nil
        
        init(with log : String) {
            self.content = log
        }
    }
    
    public var tags                : [String]
    public var mainKey             : String?               = nil
    private var logContent  : [String:[KCLogItem]]
    
    public init(with tags : [String]? = nil) {
        self.tags = tags ?? [String]()
        self.logContent = [String:[KCLogItem]]()
    }
    
    public func addLogContent(with key : String,
                              value : KCLogItem) {
        var values = [KCLogItem]()
        if let tmpValues = self.logContent[key] {
            values.append(contentsOf: tmpValues)
        }
        values.append(value)
        self.logContent[key] = values
        
        NotificationCenter.default.post(name: NSNotification.Name.init(KCLogContentChanged_Notification),
                                        object: nil)
    }
    
    public func allLogContent() -> [String: [KCLogItem]] {
        return logContent
    }
    
    public func logsWithKey(key : String) -> [KCLogItem]? {
        if let values = allLogContent()[key] {
            return values
        }
        return nil
    }
    
    public func logsContentWithKey(key : String) -> [String]? {
        if let values = allLogContent()[key] {
            return values.flatMap({ (item) -> String? in
                return item.content
            })
        }
        return nil
    }
    
    public func mainLog() -> [String]? {
        if let key = mainKey {
            return logsContentWithKey(key: key)
        }
        return logContent.values.first?.flatMap({ (item) -> String? in
            return item.content
        })
    }
}

extension KCLogManager {
    public static let httpTagKey = "http"
    
    public static func addHttpRequestLog() -> KCLog {
        let log = KCLog(with: [httpTagKey])
        log.mainKey = KCLog.httpUrlKey
        KCLogManager.share.addLog(log: log)
        return log
    }
    
    public static func httpRequestLogs() -> [KCLog] {
        return KCLogManager.share.filterLog(with: [httpTagKey])
    }
}

extension KCLog {
    public static let httpUrlKey = "Url"
    public static let httpRequestParameterKey = "Parameter"
    public static let httpRequestHeaderKey = "Header"
    public static let httpResponseKey = "Response"
    
   
    
    public func logUrl(with urlStr : String) {
        addLogContent(with: KCLog.httpUrlKey, value: KCLog.KCLogItem.init(with: urlStr))
    }
    
    public func url() -> String? {
        return logsContentWithKey(key: KCLog.httpUrlKey)?.first
    }
    
    public func logHeader(with str : String) {
        addLogContent(with: KCLog.httpRequestHeaderKey, value: KCLog.KCLogItem.init(with: str))
    }
    
    public func header() -> [String]? {
        return logsContentWithKey(key: KCLog.httpRequestHeaderKey)
    }
    
    public func logParameter(with str : String) {
        addLogContent(with: KCLog.httpRequestParameterKey, value: KCLog.KCLogItem.init(with: str))
    }
    
    public func parameter() -> [String]? {
        return logsContentWithKey(key: KCLog.httpRequestParameterKey)
    }
    
    public func logResponse(with str : String) {
        addLogContent(with: KCLog.httpResponseKey, value: KCLog.KCLogItem.init(with: str))
    }
    
    public func response() -> [String]? {
        return logsContentWithKey(key: KCLog.httpUrlKey)
    }
}
