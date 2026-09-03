# BabyDay — V1 Complete Source

BabyDay — “Bebeğinin her anı, hep yanında.”

## Included
- SwiftUI + SwiftData data model
- Dashboard, quick event entry, history, growth, profile
- WHO growth architecture (official tables must be supplied before medical percentiles are shown)
- Local notifications/settings
- StoreKit 2 Premium foundation (49 TL/month product configuration in StoreKit file)
- CloudKit family sharing foundation
- Onboarding and baby profile creation
- Privacy, backup, reminders and about settings
- iOS app icon, Info.plist, entitlements and Xcode project

## Final Apple setup before release
1. Open `BabyDay.xcodeproj` in Xcode on a Mac or cloud Mac.
2. Select your Apple Developer Team and enable signing.
3. Create/enable the `iCloud.com.babyday.app` CloudKit container.
4. Enable iCloud/CloudKit capability and configure sharing schema.
5. Configure App Store Connect subscription product `com.babyday.premium.monthly` at the intended 49 TL/month price.
6. Run on at least two physical devices/accounts for CloudKit sharing and notifications QA.
7. Add App Store privacy details, support URL and privacy policy URL.
8. Archive and upload to TestFlight.

The source is intentionally not presented as already App-Store-signed; Apple signing, CloudKit production configuration and App Store Connect are account-bound steps that cannot be completed without the developer account/Xcode environment.
