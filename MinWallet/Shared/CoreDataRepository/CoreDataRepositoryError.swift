// CoreDataRepositoryError.swift
// CoreDataRepository
//
//
// MIT License
//
// Copyright © 2023 Andrew Roan

import Foundation

public enum CoreDataRepositoryError: Error, Equatable, Hashable {
    case failedToGetObjectIdFromUrl(URL)
    case propertyDoesNotMatchEntity
    case fetchedObjectFailedToCastToExpectedType
    case fetchedObjectIsFlaggedAsDeleted
    case coreData(NSError)

    public var localizedDescription: String {
        switch self {
        case .failedToGetObjectIdFromUrl:
            return "No NSManagedObjectID found that correlates to the provided URL."
        case .propertyDoesNotMatchEntity:
            return "There is a mismatch between a provided NSPropertyDescrption's entity and a NSEntityDescription. "
                + "When a property description is provided, it must match any related entity descriptions."
        case .fetchedObjectFailedToCastToExpectedType:
            return "The object corresponding to the provided NSManagedObjectID is an incorrect Entity or "
                + "NSManagedObject subtype. It failed to cast to the requested type."
        case .fetchedObjectIsFlaggedAsDeleted:
            return "The object corresponding to the provided NSManagedObjectID is deleted and cannot be fetched."
        case let .coreData(error):
            return error.localizedDescription
        }
    }
}

extension CoreDataRepositoryError: CustomNSError {
    public static let errorDomain: String = "CoreDataRepository"

    public var errorCode: Int {
        switch self {
        case .failedToGetObjectIdFromUrl:
            return 1
        case .propertyDoesNotMatchEntity:
            return 2
        case .fetchedObjectFailedToCastToExpectedType:
            return 3
        case .fetchedObjectIsFlaggedAsDeleted:
            return 4
        case .coreData:
            return 5
        }
    }

    public static let urlUserInfoKey: String = "ObjectIdUrl"

    public var errorUserInfo: [String: Any] {
        switch self {
        case let .failedToGetObjectIdFromUrl(url):
            return [Self.urlUserInfoKey: url]
        case .propertyDoesNotMatchEntity:
            return [:]
        case .fetchedObjectFailedToCastToExpectedType:
            return [:]
        case .fetchedObjectIsFlaggedAsDeleted:
            return [:]
        case let .coreData(error):
            return error.userInfo
        }
    }
}
