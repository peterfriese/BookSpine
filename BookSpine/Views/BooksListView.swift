//
//  ContentView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

let testData = [
  Book(title: "The Ultimate Hitchhiker's Guide to the Galaxy: Five Novels in One Outrageous Volume", author: "Douglas Adams", numberOfPages: 815),
  Book(title: "Changer", author: "Matt Gemmell", numberOfPages: 474),
  Book(title: "Toll", author: "Matt Gemmell", numberOfPages: 474)
]

struct BooksListView: View {
  var books = testData
  @ObservedObject var viewModel = BooksViewModel()
  
  var body: some View {
    NavigationView {
      List(viewModel.books) { book in
        VStack(alignment: .leading) {
          Text(book.title)
            .font(.headline)
          Text(book.author)
            .font(.subheadline)
          Text("\(book.numberOfPages) pages")
            .font(.subheadline)
        }
      }
      .navigationBarTitle("Books")
      .onAppear() {
        self.viewModel.fetchData()
      }
    }
  }
}

struct BooksListView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView()
  }
}
