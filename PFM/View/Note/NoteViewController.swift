//
//  NoteViewController.swift
//  PFM
//
//  Created by Bence Pattogato on 01/12/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Foundation
import KMPlaceholderTextView

final class NoteViewController: UIViewController, NoteViewProtocol, AlertProtocol {
    
    var presenter: NoteViewPresenterProtocol!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    func showText(_ text: String) {
        textView.text = text
    }
    
    func dismissView(completionHandler: (() -> Void)?) {
        self.dismiss(animated: true, completion: completionHandler)
    }
    
    @IBAction func deleteButtonTouched(_ sender: Any) {
        if textView.text.characters.count > 0 {
            showAlert(message: "Discard note?",
                      cancelAction: createDefaultCancelAction(),
                      otherActions: createAction(title: "Delete",
                                                 style: .destructive,
                                                 handler: { _ in
                                                    self.dismissView(completionHandler: nil)
                      }))
        } else {
            self.dismissView(completionHandler: nil)
        }
        
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        guard let text = textView.text, text.characters.count > 0 else {
            showAlert(message: "Empty note",
                      cancelAction: createAction(title: "Got it"))
            return
        }
        self.presenter.saveText(text)
    }
}
