//
//  NoteViewPresenterProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 01/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol NoteViewPresenterProtocol {
    init(view: NoteViewProtocol)
    
    var delegate: InputContentSelectorDelegate? { get set }
    
    func showText(_ text: String)
    func saveText(_ text: String)
}
