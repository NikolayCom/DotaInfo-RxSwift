import Foundation

public struct Configuration {
    private enum Constants {
        enum PlistKeys {}
    }

    // MARK: Public

    public static var shared = Configuration.readConfig()

    public var baseUrl: String {
        "https://api.opendota.com"
    }

    public var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    // MARK: Private methods

    private static func readConfig() -> Configuration {
        var config = Configuration()

        return config
    }
}
