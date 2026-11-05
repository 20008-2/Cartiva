# CARTIVA Flutter starter

This is a free, beginner-friendly Flutter starter for the CARTIVA shopping app.

## Is Flutter free?
Yes. Flutter and the Dart language are free and open source. You do not need to pay Flutter to write or test this app. Other services may charge fees (for example, payment processing, hosting, supplier platforms, or publishing on an app store).

## What is included
- CARTIVA home/shop screen
- Sample dropshipping products and cart
- Separate affiliate/Partner Deals section
- About page with CARTIVA brand wording
- Demo checkout notice (no real payment is collected)

## Important before launch
This is a front-end starter, not a complete online store. It does NOT yet:
- take real payments
- save customer accounts or orders
- connect to suppliers or place supplier orders
- calculate shipping or taxes
- open affiliate tracking links
- provide admin product management

Do not accept customer payments until secure checkout, order handling, delivery, refunds and privacy protections are implemented and tested.

## Run the app
On a computer with Flutter installed:
1. Install Flutter from the official Flutter documentation.
2. Extract this ZIP.
3. Open a terminal in the `cartiva_flutter` folder.
4. Run `flutter pub get`
5. Run `flutter run`

On an Android phone only, editing and building Flutter projects is less straightforward. You can keep this ZIP on your phone, but you may need a computer or a compatible cloud development environment to compile and install the APK.

## Customise sample products
Edit the `products` list in `lib/main.dart`. Replace sample names, descriptions, prices and image URLs. For affiliate products, add a real approved affiliate URL and change the Partner link button so it opens that URL.
