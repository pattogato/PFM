//
//  NoteViewProtocol.swift
//  PFM
//
//  Created by Bence Pattogato on 01/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation

protocol NoteViewProtocol: class {
    
    func showText(_ text: String)
    var presenter: NoteViewPresenterProtocol! { get set }
    
    func dismissView(completionHandler: (() -> Void)?)
}
