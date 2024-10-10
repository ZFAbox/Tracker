//
//  TrackerCategoriesViewModel.swift
//  Tracker
//
//  Created by Fedor on 21.08.2024.
//

import Foundation

final class TrackerCategoriesViewModel {

    var delegate: SelectCategoryForTrackerProtocl?
    
    var isCategorySelected: Bool = false
    
    private lazy var categoryStore = TrackerCategoryStore(delegate: self)
    
    private var selectedCategory: String?
    
    private(set) var insertedTableIndexes: IndexPath? {
        didSet {
            guard let insertedTableIndexes = insertedTableIndexes else { return }
            insertedTableIndexesBinding?(insertedTableIndexes)
        }
    }
    
    var insertedTableIndexesBinding: Binding<IndexPath>?
    
    init(delegate: SelectCategoryForTrackerProtocl?) {
        self.delegate = delegate
    }
    
    func setCategory(){
        guard let selectedCategory = self.selectedCategory else {
            print("Кактегория не выбрана")
            return }
            delegate?.setSelectedCategory(selectedCategory)
            print(selectedCategory)
    }
    
    func isCategoriesEmpty() -> Bool {
        categoryStore.isEmpty()
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        categoryStore.numberOfItemsInSection(section)
    }
    
    func object(at indexPath: IndexPath) -> String {
        categoryStore.object(at: indexPath)
    }
    func count() -> Int {
        categoryStore.count()
    }
    
    func removeCategory(at indexPath: IndexPath) {
        categoryStore.removeCategory(at: indexPath)
    }
    
    func editCategory(at indexPath: IndexPath, with category: String) {
        categoryStore.editCategory(at: indexPath, with: category)
    }
    
    func saveCategory(_ category: String) {
        categoryStore.saveCategory(category)
    }
    
    func updateSelectedCategory(category: String){
        if isCategorySelected {
            selectedCategory = category
        }
    }
}

extension TrackerCategoriesViewModel: TrackerCategoryIsSelectedProtocol {
    func isCategorySelected(isCategorySelected: Bool, selectedCategory: String?) {
        self.isCategorySelected = isCategorySelected
        self.selectedCategory = selectedCategory
    }
}

extension TrackerCategoriesViewModel: TrackerCategoryStoreProtocol {
    func updateCategoryList(with insertedIndexes: IndexPath?, and deletedIndexes: IndexPath?) {
        self.insertedTableIndexes = insertedIndexes
    }
    
    
}

