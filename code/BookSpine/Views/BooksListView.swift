//
//  ContentView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct BooksListView: View {
    @ObservedObject var bookListVM = BookListViewModel()
    @State var presentAddBookSheet = false
    
    var body: some View {
        NavigationView {
                
            List {
                SearchView()
                
                ForEach (bookListVM.bookCellViewModels) { bookCellVM in
                    NavigationLink(destination: BookEditView(bookCellVM: bookCellVM)) {
                        BookRowViewCell(bookCellVM: bookCellVM)
                    }
                }
                .onDelete { indexSet in
                    self.bookListVM.removeBook(atOffsets: indexSet)
                }
            }
            .navigationBarTitle("Books")
            .navigationBarItems(
                // add the edit button
                leading: EditButton(),
                trailing: AddBookButton() {
                    self.presentAddBookSheet.toggle()
                })
            .onAppear() {
                print("BooksListView appears. Subscribing to data updates.")
                self.bookListVM.bookRepository.subscribe()
            }
            // by unsubscribing from the view model, we prevent updates coming in from Firestore to be reflected in the UI
            .onDisappear() {
                print("BooksListView disappears. Unsubscribing from data updates.")
                self.bookListVM.bookRepository.unsubscribe()
            }
            .sheet(isPresented: self.$presentAddBookSheet) {
                BookEditView(bookCellVM: BookCellViewModel.newBook()) { result in
                    if case .success(let book) = result {
                        self.bookListVM.addBook(book: book)
                    }
                    self.presentAddBookSheet.toggle()
                }
            }
        }
    }
}

struct BookRowViewCell: View {
    @ObservedObject var bookCellVM: BookCellViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(bookCellVM.book.title)
                .font(.headline)
            Text(bookCellVM.book.author)
                .font(.subheadline)
            Text("\(bookCellVM.book.numberOfPages) pages")
                .font(.subheadline)
        }
        .onAppear() {
            print("BookRowView appears for \(self.bookCellVM.book.title)")
        }
    }
}

struct AddBookButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: { self.action() }) {
            Image(systemName: "plus")
        }
    }
}

struct BooksListView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListView()
    }
}
