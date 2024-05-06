//
//  SDNotificationModel.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 06.05.2024.
//

import SwiftData

@Model
final class SDNotificationModel {
    @Attribute(.unique)
    var _id         : String
    var _title      : String
    var _date       : String
    var _message    : String?
    var _productID  : String
    var _receiverID : String
    var _creatorID  : String

    init(
        _id: String,
        _title: String,
        _date: String,
        _message: String? = nil,
        _productID: String,
        _receiverID: String,
        _creatorID: String
    ) {
        self._id = _id
        self._title = _title
        self._date = _date
        self._message = _message
        self._productID = _productID
        self._receiverID = _receiverID
        self._creatorID = _creatorID
    }
}

// MARK: - SDModelable

extension SDNotificationModel: SDModelable {
    typealias FBModelType = FBNotification

    convenience init(fbModel: FBModelType) {
        self.init(
            _id: fbModel.id,
            _title: fbModel.title,
            _date: fbModel.date,
            _message: fbModel.message,
            _productID: fbModel.productID,
            _receiverID: fbModel.receiverID,
            _creatorID: fbModel.creatorID
        )
    }
}

// MARK: - Mapper

extension SDNotificationModel {

    var mapper: FBNotification {
        FBNotification(
            id: _id,
            title: _title,
            date: _date,
            message: _message,
            productID: _productID,
            receiverID: _receiverID,
            creatorID: _creatorID
        )
    }
}
