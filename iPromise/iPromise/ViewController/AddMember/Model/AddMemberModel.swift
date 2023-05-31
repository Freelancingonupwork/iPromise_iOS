//
//  File.swift
//  iPromise
//
//  Created by Apple on 21/03/23.
//

import SwiftyJSON
import ContactsUI

class AddMemberModel  {
    //MARK: - variable
    private unowned var controller : AddMemberVC
    var arrMembers = [JSON]()
    var arrContact = [JSON]()
    
    //MARK: -  initializer
    init(controller:AddMemberVC) {
        self.controller = controller
    }
    
}
class phoneContactModel: NSObject {

    var name: String?
    var fname : String?
    var lname : String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false

    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        fname = contact.givenName
        lname = contact.familyName
        avatarData  = contact.thumbnailImageData
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
    func match(string: String) -> Bool {
        return (name?.lowercased().contains(string.lowercased()) ?? false) || phoneNumber.contains(where: {$0 == string})
    }
    override init() {
        super.init()
    }
}

class phoneContacts {

    class func getContacts() -> [CNContact] {

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            Log.info("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                Log.info("Error fetching containers")
            }
        }
        return results
    }
}
