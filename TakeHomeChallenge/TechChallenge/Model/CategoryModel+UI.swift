import SwiftUI

extension CategoryModel {
    var title: String {
        category?.rawValue ?? "all"
    }
    
    var color: Color {
        category?.color ?? .black
    }
}
