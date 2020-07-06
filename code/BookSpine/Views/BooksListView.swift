//
//  ContentView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BooksListView: View {
  @State private var presentAddNewBookSheet = false
  @ObservedObject var viewModel = BooksViewModel()

  var body: some View {
    NavigationView {
      List {
        ForEach (viewModel.books) { book in
          BookRowView(book: book)
        }
      }
      .navigationBarTitle("Books")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(action: { presentAddNewBookSheet.toggle() }, label: {
            Image(systemName: "plus")
          })
        }
      }
      .onAppear() {
        self.viewModel.subscribe()
      }
      .onDisappear() {
        self.viewModel.unsubscribe()
      }
      .sheet(isPresented: $presentAddNewBookSheet) {
        BookEditView()
      }
    }
  }
}

struct BookRowView: View {
  var book: Book
  var body: some View {
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

struct BooksListView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView()
  }
}
