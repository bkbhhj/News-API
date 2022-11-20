import UIKit
import CoreData

final class CoreDataManager {
    //MARK: - Properties
    var news: [NewsEntity] = []
    static let shared = CoreDataManager()
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "News_API")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    lazy var viewContext = persistentContainer.viewContext
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK: - Save news functions
     func saveNews(News: News) {
         let saveNews = NewsEntity(context: viewContext)
         saveNews.title = News.title
         saveNews.url = News.url
         saveNews.content = News.content ?? "nsdj"
         saveNews.imageURL = News.urlToImage ?? "smd"
         do {
             try? viewContext.save()
             print("sucsees save news")
         }
         saveContext()
     }
    //MARK: - Load news functions
     func loadNews(onComplete:@escaping([NewsEntity])-> ()){
        let request: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
        do {
            news = try viewContext.fetch(request)
            onComplete(news)
            print("sucsees load news")
        } catch  {
            print("error fetching data from context")
        }
        
    }
    //MARK: - Remove news functions
     func removeNews(at indexPath:Int) {
        viewContext.delete(news[indexPath])
        do {
           try viewContext.save()
        } catch let error {
            print("Error deleting - \(error.localizedDescription)")
        }
    }
}
