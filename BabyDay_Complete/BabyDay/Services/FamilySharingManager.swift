import Foundation
import CloudKit
import UIKit

@MainActor
final class FamilySharingManager: NSObject, ObservableObject {
    static let shared = FamilySharingManager()

    private let container = CKContainer(identifier: "iCloud.com.babyday.app")

    @Published private(set) var isICloudAvailable = false

    func refreshAccountStatus() async {
        do {
            let status = try await container.accountStatus()
            isICloudAvailable = (status == .available)
        } catch {
            isICloudAvailable = false
        }
    }

    /// Creates a private CloudKit share for the baby root record.
    /// The root and child records must exist in a custom record zone.
    func prepareShare(for record: CKRecord) async throws -> CKShare {
        let share = CKShare(rootRecord: record)
        share[CKRecord.SystemFieldKey.title] = "BabyDay • \(record.recordID.recordName)" as CKRecordValue
        share.publicPermission = .none

        let database = container.privateCloudDatabase
        let operation = CKModifyRecordsOperation(recordsToSave: [record, share])
        operation.savePolicy = .ifServerRecordUnchanged

        return try await withCheckedThrowingContinuation { continuation in
            var savedShare: CKShare?
            operation.perRecordSaveBlock = { _, result in
                if case .success(let saved) = result, let share = saved as? CKShare {
                    savedShare = share
                }
            }
            operation.modifyRecordsResultBlock = { result in
                switch result {
                case .success:
                    if let savedShare {
                        continuation.resume(returning: savedShare)
                    } else {
                        continuation.resume(throwing: CKError(.partialFailure))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            database.add(operation)
        }
    }

    func shareURL(from share: CKShare) -> URL? {
        share.url
    }
}
