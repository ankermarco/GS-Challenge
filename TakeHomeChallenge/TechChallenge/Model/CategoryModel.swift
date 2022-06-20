import Foundation

struct CategoryModel: Identifiable {
    let id: UUID = UUID()
    let category: Category?
    
    init(category: Category? = nil) {
        self.category = category
    }
}
