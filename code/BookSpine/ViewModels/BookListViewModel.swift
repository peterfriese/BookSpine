//
//  BookViewModel.swift
//  BookSpine
//
//  Created by Peter Friese on 09/06/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import Combine
import Firebase

class BookListViewModel: ObservableObject {
    @Published var bookRepository = BookRepository()
    @Published var bookCellViewModels = [BookCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bookRepository.$books.map { books in
            books.map { book in
                BookCellViewModel(book: book)
            }
        }
        .assign(to: \.bookCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func removeBook(atOffsets indexSet: IndexSet) {
        let viewModels = indexSet.lazy.map { self.bookCellViewModels[$0] }
        viewModels.forEach { bookCellViewModel in
            bookRepository.removeBook(bookCellViewModel.book)
        }
    }
    
    func addBook(book: Book) {
        bookRepository.addBook(book)
    }
    
    func searchBook(book: Book) {
        bookRepository.searchBook()
    }
}
