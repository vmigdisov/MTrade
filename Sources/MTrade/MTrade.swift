
import CoreData

public class MTrade {
    
    public enum Resource { case wp(String) }
    
    public static var resource: Resource?
    
    public static var managedObjectContext: NSManagedObjectContext?
    
    static public func setup(with resource: Resource, inMemory: Bool = false) {
        MTrade.resource = resource
        MTrade.managedObjectContext = PersistentController(inMemory: true).container.viewContext
    }
    
    public static func configurationError() {
        fatalError("MTrade is not configured. Use MTrade.setup(with: Entity).")
    }
    
    private init() {}
}
