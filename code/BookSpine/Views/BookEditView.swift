//
//  BookEditView.swift
//  BookSpine
//
//  Created by Peter Friese on 06/07/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct BookEditView: View {
  @Environment(\.presentationMode) private var presentationMode
  @StateObject var viewModel = BookViewModel()
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Book")) {
          TextField("Tile", text: $viewModel.book.title)
          TextField("Pages", value: $viewModel.book.numberOfPages, formatter: NumberFormatter())
        }
        Section(header: Text("Author")) {
          TextField("Author", text: $viewModel.book.author)
        }
      }
      .navigationBarTitle("New Book")
      .navigationBarItems(
        leading:
          Button(action: { handleCancelTapped() }) {
            Text("Cancel")
          }
        ,
        trailing:
          Button(action: { handleDoneTapped() }) {
            Text("Done")
          }
          .disabled(!viewModel.modified)
      )
    }
    
  }
  
  func handleCancelTapped() {
    dismiss()
  }
  
  func handleDoneTapped() {
    self.viewModel.handleDoneTapped()
    dismiss()
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
}

struct BookEditView_Previews: PreviewProvider {
  static var previews: some View {
    BookEditView()
  }
}
