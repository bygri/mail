import XCTest
import Mail
import InMemoryMailClient
@testable import Vapor

class InMemoryMailClientTests: XCTestCase {
    static let allTests = [
        ("testSendEmail", testSendEmail),
        ("testSendMultipleEmails", testSendMultipleEmails),
        ("testProvider", testProvider),
    ]

    func testSendEmail() throws {
        let mailer = InMemoryMailClient.MailClient()
        let email = Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try mailer.send(email)

        XCTAssert(mailer.sentEmails.count == 1)
        XCTAssert(mailer.sentEmails[0].subject == "Email Subject")
    }

    func testSendMultipleEmails() throws {
        let mailer = InMemoryMailClient.MailClient()
        let emails = [
            Email(from: "from@email.com", to: "to@email.com", subject: "Email1", body: "Email1 body"),
            Email(from: "from@email.com", to: "to@email.com", subject: "Email2", body: "Email2 body"),
            Email(from: "from@email.com", to: "to@email.com", subject: "Email3", body: "Email3 body"),
        ]
        try mailer.send(emails)

        XCTAssert(mailer.sentEmails.count == 3)
        XCTAssert(mailer.sentEmails[0].subject == "Email1")
        XCTAssert(mailer.sentEmails[1].subject == "Email2")
        XCTAssert(mailer.sentEmails[2].subject == "Email3")
    }

    func testProvider() throws {
        let drop = try makeDroplet()
        try drop.addProvider(InMemoryMailClient.Provider.self)

        let email = Email(from: "from@email.com",
                          to: "to1@email.com", "to2@email.com",
                          subject: "Email Subject",
                          body: "Hello Email")
        let attachment = EmailAttachment(filename: "dummy.data",
                                         contentType: "dummy/data",
                                         body: [1,2,3,4,5])
        email.attachments.append(attachment)
        try drop.mailer?.send(email)
    }

}

extension InMemoryMailClientTests {
    func makeDroplet() throws -> Droplet {
        let drop = Droplet(arguments: ["/dummy/path/", "prepare"])
        try drop.runCommands()
        return drop
    }
}