import Foundation
import ObjectMapper

public
    extension Mapper
{
    /// Maps a JSON object to an array of model objects, returning an empty array if the input is nil or NSNull.
    /// - Parameter JSONObject: The JSON object to map.
    /// - Returns: An array of mapped objects, or an empty array if the input is nil or NSNull.
    func gk_mapArrayOrNull(JSONObject: Any?) -> [N]? {
        guard JSONObject != nil, !(JSONObject is NSNull)
        else { return [] }
        
        return mapArray(JSONObject: JSONObject)
    }
    
    /// Maps JSON data to an object of type `N`.
    /// - Parameter JSONData: The JSON data to be deserialized and mapped.
    /// - Returns: An instance of type `N` if deserialization and mapping succeed; otherwise, nil.
    func gk_map(JSONData: Data) -> N? {
        if let JSON = (try? JSONSerialization.jsonObject(with: JSONData, options: [])) as? [String: Any] {
            return map(JSON: JSON)
        }
        
        return nil
    }
}

public
    class GKMapFromJSONToType<T>: TransformType
{
    public typealias Object = T
    public typealias JSON = Any
    
    private let fromJSON: (Any?) -> T?
    
    public init(fromJSON: @escaping (Any?) -> T?) {
        self.fromJSON = fromJSON
    }
    
    /// Transforms a JSON value into the target type using the provided conversion closure.
    /// - Parameter value: The JSON value to be transformed.
    /// - Returns: The transformed value of type `T`, or `nil` if conversion fails.
    open func transformFromJSON(_ value: Any?) -> T? {
        return fromJSON(value)
    }
    
    /// Returns the provided value without transformation.
    /// - Parameter value: The value to be converted to JSON.
    /// - Returns: The value as-is, suitable for JSON serialization.
    open func transformToJSON(_ value: T?) -> JSON? {
        return value
    }
}

public let GKMapFromJSONToDouble = GKMapFromJSONToType<Double>(fromJSON: gk_getDoubleForValue)
public let GKMapFromJSONToInt = GKMapFromJSONToType<Int>(fromJSON: gk_getIntForValue)
public let GKMapFromJSONToString = GKMapFromJSONToType<String>(fromJSON: gk_getStringForValue)
public let GKMapFromJSONToBool = GKMapFromJSONToType<Bool>(fromJSON: gk_getBoolForValue)

public
    class GKMapBetweenJSONAndType<J, T>: TransformType
{
    public typealias Object = T
    public typealias JSON = J
    
    private let fromJSON: (Any?) -> T?
    private let toJSON: (T?) -> J?
    
    public init(fromJSON: @escaping (Any?) -> T?, toJSON: @escaping (T?) -> J?) {
        self.fromJSON = fromJSON
        self.toJSON = toJSON
    }
    
    /// Transforms a JSON value into the target type using the provided conversion closure.
    /// - Parameter value: The JSON value to be transformed.
    /// - Returns: The transformed value of type `T`, or `nil` if conversion fails.
    open func transformFromJSON(_ value: Any?) -> T? {
        return fromJSON(value)
    }
    
    /// Transforms a value of type `T` to its JSON representation of type `J`.
    /// - Parameter value: The value to be transformed.
    /// - Returns: The JSON representation of the value, or nil if the transformation fails.
    open func transformToJSON(_ value: T?) -> J? {
        return toJSON(value)
    }
}


/// Converts the input value to a `Double` if possible.
/// - Parameter input: The value to convert, which may be an `Int`, `Double`, or `String`.
/// - Returns: The converted `Double` value, or `nil` if conversion is not possible.
public func gk_getDoubleForValue(_ input: Any?) -> Double? {
    switch input {
    case let value as Int:
        return Double(value)
    case let value as Double:
        return value
    case let value as String:
        return value.gkDoubleValue
    default:
        return nil
    }
}

/// Converts the input to an `Int` if possible.
/// - Parameter input: The value to convert, which may be an `Int`, `Double`, or `String`.
/// - Returns: The integer representation of the input, or `nil` if conversion is not possible.
public func gk_getIntForValue(_ input: Any?) -> Int? {
    switch input {
    case let value as Int:
        return value
    case let value as Double:
        return Int(value)
    case let value as String:
        return value.gkIntValue
    default:
        return nil
    }
}

/// Converts the input value to a `String` if it is an `Int64`, `Int`, `Double`, or `String`.
/// - Parameter input: The value to convert.
/// - Returns: The string representation of the input, or `nil` if the input is not a supported type.
public func gk_getStringForValue(_ input: Any?) -> String? {
    switch input {
    case let value as Int64:
        return String(value)
    case let value as Int:
        return String(value)
    case let value as Double:
        return String(value)
    case let value as String:
        return value
    default:
        return nil
    }
}

/// Converts the input value to a `Bool` if possible.
/// 
/// Accepts `Bool`, `Int`, `Double`, or `String` types. For numeric types, zero is `false` and nonzero is `true`. For strings, empty string, "0", or "false" (case-insensitive) are `false`; all other values are `true`.
/// - Parameter input: The value to convert.
/// - Returns: The corresponding `Bool` value, or `nil` if conversion is not possible.
public func gk_getBoolForValue(_ input: Any?) -> Bool? {
    switch input {
    case let value as Bool:
        return value
    case let value as Int:
        return !(value == 0)
    case let value as Double:
        return !(value == 0)
    case let value as String:
        return !(value == "" || value == "0" || value.lowercased() == "false")
    default:
        return nil
    }
}

/// Converts the input to a latitude value as a `Double`, clamped between -90 and 90.
/// - Parameter input: The value to convert, which may be a number or string.
/// - Returns: The latitude as a `Double` within the valid range, or `nil` if the input is blank or invalid.
public func gk_getLatitudeForValue(_ input: Any?) -> Double? {
    guard let jsonString = gk_getStringForValue(input),
        !jsonString.isBlank,
        let latValue = gk_getDoubleForValue(input)
    else {
        return nil
    }
    return max(-90.0, min(latValue, 90.0))
}

/// Converts the input to a longitude value as a `Double` within the range -180 to 180.
/// - Parameter input: The value to convert, which may be a number or string.
/// - Returns: The longitude as a `Double` if the input is valid and within range; otherwise, `nil`.
public func gk_getLongitudeForValue(_ input: Any?) -> Double? {
    guard let jsonString = gk_getStringForValue(input),
        !jsonString.isBlank,
        let lngValue = gk_getDoubleForValue(input)
    else {
        return nil
    }
    return max(-180.0, min(lngValue, 180.0))
}

extension String {
    public var gkFloatValue: Float {
        return (self as NSString).floatValue
    }
    
    public var gkIntValue: Int {
        return (self as NSString).integerValue
    }
    
    public var gkDoubleValue: Double {
        return (self as NSString).doubleValue
    }
}
