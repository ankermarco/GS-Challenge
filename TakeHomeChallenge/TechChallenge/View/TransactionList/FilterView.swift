import SwiftUI

// Create this simple struct to hold the view data
// So that is the CategoryModel is changed
// We dont need to change the view
// We just need to fix this struct

struct FilterViewData {
    let categoryModel: CategoryModel
}

struct FilterView: View {
    let viewData: FilterViewData
    let onTap: (Category?) -> Void
    
    var body: some View {
        Button {
            onTap(viewData.categoryModel.category)
        } label: {
            Text(viewData.categoryModel.title)
                .font(.title2)
                .fontWeight(.bold)
        }
        .buttonStyle(RoundedButtonStyle(backgroundColor: viewData.categoryModel.color))
    }
}

#if DEBUG
struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(viewData: FilterViewData(categoryModel: .init(category: .entertainment))) { _ in
        }.previewLayout(.sizeThatFits)
        
        FilterView(viewData: FilterViewData(categoryModel: .init(category: .food))) { _ in
        }.previewLayout(.sizeThatFits)
    }
}
#endif
