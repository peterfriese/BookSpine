//
//  ContentView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BooksListView: View {
  @ObservedObject var booksRepository: BooksRepository
  
  var body: some View {
    NavigationView {
      List {
        ForEach(booksRepository.books.indexed(), id: \.1.id) { index, book in
          NavigationLink(destination: BookDetailsView(book: self.$booksRepository.books[index])) {
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
        .navigationBarTitle("Books")
      }
    }
  }
}

struct BooksListView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView(booksRepository: BooksRepository())
  }
}

extension Sequence {
  func indexed() -> Array<(offset: Int, element: Element)> {
    return Array(enumerated())
  }
}
