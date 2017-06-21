# SendGrid Provider for Vapor

![Swift](http://img.shields.io/badge/swift-3.1-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-2.0-brightgreen.svg)
[![CircleCI](https://circleci.com/gh/vapor-community/sendgrid-provider.svg?style=shield)](https://circleci.com/gh/vapor-community/sendgrid-provider)

Adds a mail backend for SendGrid to the Vapor web framework. Send simple emails,
or leverage the full capabilities of SendGrid's V3 API.

## Setup
Add the dependency to Package.swift:

```swift
.Package(url: "https://github.com/vapor-community/sendgrid-provider.git", majorVersion: 2)
```

Add a configuration file named `sendgrid.json` with the following format:

```JSON
{
    "apiKey": "SG.YOUR_API_KEY"
}
```

Register the provider with the configuration system:

```swift
import SendGridProvider

extension Config {
    /// Configure providers
    private func setupProviders() throws {
        ...
        try addProvider(SendGridProvider.Provider.self)
    }
}
```

And finally, change the Droplet's mail implementation by editing `droplet.json`:

```js
{
  "mail": "sendgrid",
  // other configuration keys redacted for brevity
}
```

## Sending simple emails

SendGrid can act as a drop-in replacement for Vapor's built-in SMTP support.
Simply make use of `drop.mail`:

```swift
import SMTP

let email = Email(from: …, to: …, subject: …, body: …)
try drop.mail.send(email)
```

Don't forget to `import SMTP` if you need to work with `Email` or
`EmailAddress` objects.

## Sending complex emails

Use the `SendGridEmail` class to fully configure your email, including open
and click tracking, templating, and multiple recipients.

```swift
import SendGridProvider

if let sendgrid = drop.mail as? SendGrid {
  let email = SendGridEmail(…)
  try sendgrid.send(email)
}
```
