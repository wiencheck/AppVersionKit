
import Foundation

public struct AppVersion: Codable {
    
    public let project: Project
    public let build: Int
    
    private init(project: Project, build: Int) {
        self.project = project
        self.build = build
    }
    
    public static var current: Self {
        let bundle: Bundle = .main
        guard let rawVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let rawBuild = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String,
              let build = Int(rawBuild) else {
            return .init(project: .unknown, build: NSNotFound)
        }
        let project = Project(rawVersion)
        return .init(project: project, build: build)
    }
    
}

public extension AppVersion {
    
    private(set) static var lastInstalled: Self? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "LAST_INSTALLED_APP_VERSION"),
                  let decoded = try? JSONDecoder().decode(Self.self, from: data) else {
                return nil
            }
            return decoded
        } set {
            guard let newValue = newValue,
                  let data = try? JSONEncoder().encode(newValue) else {
                UserDefaults.standard.removeObject(forKey: "LAST_INSTALLED_APP_VERSION")
                return
            }
            UserDefaults.standard.set(data, forKey: "LAST_INSTALLED_APP_VERSION")
        }
    }
    
    static func updateLastInstalledVersion() {
        lastInstalled = .current
    }
    
}

extension AppVersion: CustomStringConvertible {
    
    public var description: String {
        var project = project.description
        #if DEBUG
            project += ", build \(build)"
        #endif
        return project
    }
    
}
