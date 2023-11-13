import Foundation

public protocol DefaultsStore {
    var isInitialLaunch: Bool { get set }
    var lastNoticeDate: Double { get set }
}

/*
 이런 유틸 성 공통 모듈은 자주 많은 팀에서 사용되기 때문에
 만약에 여러 개발자가 동시에 여기를 수정하게 될 일이 생기고
 PR을 Merge 시킬 때 코드 충돌이 잦을 수 있음
 
 솔리드 원칙 중에 OCP 열림/닫힘 원칙을 안지키고 있기 때문임 :(
 
 기능을 추가하기 위해서, DefaultsStore 기능을 확장하기 위해서
 객체나 모듈 자체를 수정해야 하기 때문에 확장에 열려있는게 아니라 닫혀 있음.
 
 특히 공통 모듈을 개발하고 제공할 때는 모듈이 확장에 열려 있도록,
 모듈 자체를 수정하지 않고도 기능 확장이 되도록 설계하는 것이 매우 중요함.
 */
public struct DefaultsStoreImp: DefaultsStore {
    
    public var isInitialLaunch: Bool {
        get {
            userDefaults.bool(forKey: kIsInitialLaunch)
        }
        set {
            userDefaults.set(newValue, forKey: kIsInitialLaunch)
        }
    }
    
    public var lastNoticeDate: Double {
        get {
            userDefaults.double(forKey: kLastNoticeDate)
        }
        set {
            userDefaults.set(newValue, forKey: kLastNoticeDate)
        }
    }
    
    private let userDefaults: UserDefaults
    
    private let kIsInitialLaunch = "kIsInitialLaunch"
    private let kLastNoticeDate = "kLastNoticeDate"
    
    public init(defaults: UserDefaults) {
        self.userDefaults = defaults
    }
    
}
