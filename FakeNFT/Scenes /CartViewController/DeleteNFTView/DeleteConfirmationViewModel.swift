//
//  DeleteConfirmationViewModel.swift
//  FakeNFT
//
//  Created by Владислав Усачев on 01.11.2024.
//

import Foundation

final class DeleteConfirmationViewModel {
    // Обозреваемые свойства для данных на экране
    let nftImageURL: Observable<URL?>
    let warningText: Observable<String>
    let deleteButtonTitle: Observable<String>
    let cancelButtonTitle: Observable<String>
    
    // Переменная для хранения ID
    private let nftId: String
    
    // Колбэки для действий
    var onDeleteConfirmed: ((String) -> Void)?
    var onCancel: (() -> Void)?
    
    init(nftId: String, nftImageURL: URL?, warningText: String, deleteButtonTitle: String, cancelButtonTitle: String) {
        self.nftId = nftId
        self.nftImageURL = Observable(nftImageURL)
        self.warningText = Observable(warningText)
        self.deleteButtonTitle = Observable(deleteButtonTitle)
        self.cancelButtonTitle = Observable(cancelButtonTitle)
    }
    
    func confirmDelete() {
        onDeleteConfirmed?(nftId)
    }
    
    func cancelDelete() {
        onCancel?()
    }
}
