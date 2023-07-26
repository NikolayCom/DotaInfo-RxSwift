import Foundation
import Core

public struct Hero: Decodable {
    public let id: Int
    public let name: String
    public let localizedName: String
    public let primaryAttr: String
    public let roles: [String]
    
    public let image: String
    public let icon: String
    
    public let baseHealth: Int
    public let baseHealthRegen: Float
    public let baseMana: Int
    
    public let baseStrenght: Int
    public let strenghtGain: Float
    public let baseAgility: Int
    public let agilityGain: Float
    public let baseIntelligence: Int
    public let intelligenceGain: Float
    
    public let moveSpeed: Int
    
    public let dayVision: Int
    public let nightVision: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case roles
        case image = "img"
        case icon
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseMana = "base_mana"
        case moveSpeed = "move_speed"
        case dayVision = "day_vision"
        case nightVision = "night_vision"
        case baseStrenght = "base_str"
        case baseAgility = "base_agi"
        case baseIntelligence = "base_int"
        case strenghtGain = "str_gain"
        case agilityGain = "agi_gain"
        case intelligenceGain = "int_gain"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let baseUrl = Configuration.shared.baseUrl
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.localizedName = try container.decode(String.self, forKey: .localizedName)
        self.primaryAttr = try container.decode(String.self, forKey: .primaryAttr)
        self.roles = try container.decode([String].self, forKey: .roles)
        
        self.image = try baseUrl + container.decode(String.self, forKey: .image)
        self.icon = try baseUrl + container.decode(String.self, forKey: .icon)
        
        self.baseHealth = try container.decode(Int.self, forKey: .baseHealth)
        self.baseHealthRegen = try container.decode(Float.self, forKey: .baseHealthRegen)
        self.baseMana = try container.decode(Int.self, forKey: .baseMana)
        self.baseStrenght = try container.decode(Int.self, forKey: .baseStrenght)
        self.baseAgility = try container.decode(Int.self, forKey: .baseAgility)
        self.baseIntelligence = try container.decode(Int.self, forKey: .baseIntelligence)
        self.strenghtGain = try container.decode(Float.self, forKey: .strenghtGain)
        self.agilityGain = try container.decode(Float.self, forKey: .agilityGain)
        self.intelligenceGain = try container.decode(Float.self, forKey: .intelligenceGain)
        
        self.moveSpeed = try container.decode(Int.self, forKey: .moveSpeed)
        self.dayVision = try container.decode(Int.self, forKey: .dayVision)
        self.nightVision = try container.decode(Int.self, forKey: .nightVision)
    }
}
