//
//  ManagerProtocol.swift
//  ClassAttendance
//
//  Created by SoolyChristina on 2018/4/13.
//  Copyright © 2018年 SoolyChristina. All rights reserved.
//

import Foundation
import WCDBSwift

public protocol ManagerProtocol {
    
    associatedtype Model: TableCodable
    associatedtype IDType
    
    func get(with ID: IDType) -> Model?
    func get(with IDs: [IDType]) -> [Model]
    func getAll() -> [Model]?
    
    func create(_ model: Model, compeletionHandler: @escaping Handler<DBError>)
    func update(_ model: Model, compeletionHandler: @escaping Handler<DBError>)
    
    func delete(_ model: Model, compeletionHandler: @escaping Handler<DBError>)
}

