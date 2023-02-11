import Foundation
import CoreData

extension NewsEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
    return NSFetchRequest<NewsEntity>(entityName: Constant.entityName)
  }
  @NSManaged public var content: String
  @NSManaged public var imageURL: String?
  @NSManaged public var title: String
  @NSManaged public var url: String
}

extension NewsEntity : Identifiable {
  
}
