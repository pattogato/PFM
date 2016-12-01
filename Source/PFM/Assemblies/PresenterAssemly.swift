//
//  PresenterAssemly.swift
//  PFM
//
//  Created by Bence Pattogato on 06/11/16.
//  Copyright © 2016 Pinup. All rights reserved.
//

import Swinject

final class PresenterAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        /**
         Input presenter
         */
        container.register(InputViewPresenterProtocol.self) {
            (r, a: InputViewProtocol) in
            return InputViewPresenter(
                view: a,
                dalHelper: r.resolve(DALHelperProtocol.self)!,
                currentTransactionDataProvider: r.resolve(CurrentTransactionDataProviderProtocol.self)!,
                transactionDataProvider: r.resolve(TransactionDataProviderProtocol.self)!
            )
        }
        
        /**
         Input content presenter
         */
        container.register(InputContentPresenterProtocol.self) {
            (r, view: InputContentViewProtocol) in
            return InputContentPresenter(
                view: view
            )
        }
        
        /**
         Settings presenter
         */
        container.register(SettingsViewPresenterProtocol.self) {
            (r, view: SettingsViewProtocol) in
            return SettingsViewPresenter(
                view: view
            )
        }
        
        /**
         Charts view presenter
         */
        container.register(ChartsViewPresenterProtocol.self) {
            (r, view: ChartsViewProtocol) in
            return ChartsViewPresenter(
                view: view
            )
        }

        /**
         Swipe navigation presenter
         */
        container.register(SwipeNavigationPresenterProtocol.self) {
            (r, a: SwipeNavigationManagerDataSource) -> SwipeNavigationPresenterProtocol in
            return SwipeNavigationPresenter(
                dataSource: a
            )
        }
        
        /**
         Note presenter
         */
        container.register(NoteViewPresenterProtocol.self) {
            (r, view: NoteViewProtocol) in
            return NoteViewPresenter(
                view: view
            )
        }
    }
}
