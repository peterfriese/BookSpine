//
//  SearchView.swift
//  BookSpine
//
//  Created by Chris Bearden on 8/15/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var bookListVM = BookListViewModel()
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("search book", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        self.bookListVM.bookRepository.searchBook(searchText)
                    })
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton  {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding()
            
            ForEach(bookListVM.bookRepository.books.filter {$0.title.hasPrefix(searchText) || searchText == ""}, id:\.id) { searchText in
                Text(searchText.title)
            }
            .resignKeyboardOnDragGesture()
        }
        .font(.subheadline)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}


