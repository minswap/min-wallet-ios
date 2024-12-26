import Foundation
import CoreData
import CoreDataRepository


@objc(Token)
final class TokenEntity: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var tokenName: String
    @NSManaged var currencySymbol: String
    @NSManaged var ticker: String
    @NSManaged var project: String?
    @NSManaged var decimals: Int64
    @NSManaged var isVerified: Bool
}


extension TokenEntity: RepositoryManagedModel {
    typealias Unmanaged = Token

    func create(from unmanaged: Token) {
        id = UUID()
        tokenName = unmanaged.tokenName
        currencySymbol = unmanaged.currencySymbol
        ticker = unmanaged.ticker
        project = unmanaged.project
        decimals = Int64(unmanaged.decimals)
        isVerified = unmanaged.isVerified
    }


    var asUnmanaged: Token {
        Token()
            .with {
                $0.tokenName = tokenName
                $0.currencySymbol = currencySymbol
                $0.ticker = ticker
                $0.project = project ?? ""
                $0.decimals = Int(decimals)
                $0.isVerified = isVerified
                $0.url = objectID.uriRepresentation()

            }
    }

    func update(from unmanaged: Token) {
        id = UUID()
        tokenName = unmanaged.tokenName
        currencySymbol = unmanaged.currencySymbol
        ticker = unmanaged.ticker
        project = unmanaged.project
        decimals = Int64(unmanaged.decimals)
        isVerified = unmanaged.isVerified
    }

    static func fetchRequest() -> NSFetchRequest<TokenEntity> {
        let request = NSFetchRequest<TokenEntity>(entityName: tableName)
        return request
    }
}

extension TokenEntity {
    static var tableName: String {
        "Token"
    }
}


extension Token: UnmanagedModel {
    var managedRepoUrl: URL? {
        get { url }
        set(newValue) { url = newValue }
    }

    func asRepoManaged(in context: NSManagedObjectContext) -> TokenEntity {
        TokenEntity(context: context)
            .then {
                $0.id = UUID()
                $0.tokenName = tokenName
                $0.currencySymbol = currencySymbol
                $0.ticker = ticker
                $0.project = project
                $0.decimals = Int64(decimals)
                $0.isVerified = isVerified
            }
    }
}
