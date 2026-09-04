import Foundation
import CloudKit
import UIKit
import Combine

@MainActor
final class FamilySharingManager: NSObject, ObservableObject {

    static let shared = FamilySharingManager()

    private let container = CKContainer(
        identifier: "iCloud.com.babyday.app"
    )

    @Published private(set) var isICloudAvailable: Bool = false

    override private init() {
        super.init()
    }

    // MARK: - iCloud Account Status

    func refreshAccountStatus() async {
        do {
            let status = try await container.accountStatus()

            switch status {
            case .available:
                isICloudAvailable = true

            default:
                isICloudAvailable = false
            }

        } catch {
            isICloudAvailable = false
        }
    }

    // MARK: - Create CloudKit Share

    /// Creates and saves a private CloudKit share
    /// for the supplied root record.
    ///
    /// The root record must belong to a custom record zone.
    func prepareShare(for record: CKRecord) async throws -> CKShare {

        let share = CKShare(rootRecord: record)

        share[CKShare.SystemFieldKey.title] =
            "BabyDay • \(record.recordID.recordName)" as CKRecordValue

        share.publicPermission = .none

        let database = container.privateCloudDatabase

        let operation = CKModifyRecordsOperation(
            recordsToSave: [record, share],
            recordIDsToDelete: nil
        )

        operation.savePolicy = .ifServerRecordUnchanged

        return try await withCheckedThrowingContinuation {
            continuation in

            var savedShare: CKShare?
            var operationError: Error?

            operation.perRecordSaveBlock = { recordID, result in

                switch result {

                case .success(let savedRecord):

                    if let saved = savedRecord as? CKShare {
                        savedShare = saved
                    }

                case .failure(let error):
                    operationError = error
                }
            }

            operation.modifyRecordsResultBlock = { result in

                switch result {

                case .success:

                    if let error = operationError {
                        continuation.resume(throwing: error)
                        return
                    }

                    if let savedShare {
                        continuation.resume(returning: savedShare)
                    } else {
                        continuation.resume(
                            throwing: CKError(.partialFailure)
                        )
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }

            database.add(operation)
        }
    }

    // MARK: - Share URL

    func shareURL(from share: CKShare) -> URL? {
        share.url
    }
}
