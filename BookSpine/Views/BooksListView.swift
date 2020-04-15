//
//  ContentView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BooksListView: View {
  @ObservedObject var booksRepository: BaseBookRepository
  
  var body: some View {
    NavigationView {
      List(booksRepository.books) { book in
        BookRowView(book)
      }
      .navigationBarTitle("Books")
      .onAppear() {
        self.booksRepository.fetchData()
      }
    }
  }
}

struct BookRowView: View {
  var book: Book
  
  init(_ book: Book) {
    self.book = book
  }
  
  var body: some View {
    HStack(alignment: .top) {
      Image(systemName: "book")
        .resizable()
        .frame(width: 60, height: 60)
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text(book.author)
          .font(.subheadline)
        Text("\(book.numberOfPages) pages")
          .font(.subheadline)
      }
    }
  }
}

struct BooksListView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView(booksRepository: TestDataBooksRepository())
  }
}
