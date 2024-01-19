//
//  ChatRoomDataSource.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Combine
import UIKit

extension GPTChatRoomsViewController {
    final class ChatRoomDataSource: UITableViewDiffableDataSource<Section, Model.GPTChatRoomDTO> {
        let deleteRoomSubject: PassthroughSubject<(Model.GPTChatRoomDTO, IndexPath), Never>?
        
        init(
            tableView: UITableView,
            deleteRoomSubject: PassthroughSubject<(Model.GPTChatRoomDTO, IndexPath), Never>?,
            cellProvider: @escaping UITableViewDiffableDataSource<GPTChatRoomsViewController.Section, Model.GPTChatRoomDTO>.CellProvider
        ) {
            self.deleteRoomSubject = deleteRoomSubject
            super.init(tableView: tableView, cellProvider: cellProvider)
        }
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete, let chatRoom = self.itemIdentifier(for: indexPath) {
                deleteRoomSubject?.send((chatRoom, indexPath))
            }
        }
    }
}
