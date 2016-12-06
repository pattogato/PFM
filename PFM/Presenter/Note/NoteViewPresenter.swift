//
//  NoteViewPresenter.swift
//  PFM
//
//  Created by Bence Pattogato on 01/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

final class NoteViewPresenter: NoteViewPresenterProtocol {
    
    unowned let view: NoteViewProtocol
    
    weak var delegate: InputContentSelectorDelegate?
    
    required init(view: NoteViewProtocol) {
        self.view = view
    }

    func showText(_ text: String) {
        self.view.showText(text)
    }
    
    func saveText(_ text: String) {
        self.delegate?.valueSelected(type: .note, value: text)
        self.view.dismissView(completionHandler: nil)
    }
    
    
}
