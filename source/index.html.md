---
title: Stidner - Order API documentation

toc_footers:
  - <a href='https://www.stidner.com/' target='_blank'>Stidner Homepage</a>
  - <a href='https://www.stidner.com/#register-inputs' target='_blank'>Merchant Registration</a>
  - <a href='mailto:integration@stidner.com'>Ask a question (email)</a>

language_tabs:
  - json-object
  - php-sdk

search: true
---

# Order API

This document references the /order API endpoint and its contents. This API is used to create checkout orders.

Although the API may look complex because of the size of the documentation, it's actually quite straightforward to use:

1. POST a json object containing information about the purchase to the /order endpoint.
2. *If the request was invalid in some way*, the API gives an error code and message explaining what went wrong.
3. *If the request and object was valid*, the response will include a URL. This URL should be displayed in an iframe on the merchant's website. All done!

Alternatively, we offer a <a href='https://github.com/Stidner/php-sdk' target='_blank'>PHP SDK</a> if you would like to
use that to craft requests. In the future, we plan to offer plugins for various e-commerce platforms.

If you have any questions/comments about anything Stidner-related, please click the "ask a question" link in the
left-hand sidebar, and we will get back to you. Thanks!

## Flow

<a href="http://developer.stidner.com/images/orderapi.png" target="_blank"><img src="http://developer.stidner.com/images/orderapi.png"></a>

1. Customer proceeds to Merchant's checkout page.
2. Merchant sends order information as a json-formatted POST request to Stidner's API.
3. Stidner returns the same data with added values. One of these values is "iframe_url"
4. This iframe_url value should be sent to Customer.
5. Customer's browser loads Stidner's iframe URL inside the Merchant's checkout page.
6. Stidner sends static resources such as HTML and JavaScript to the Customer's browser.
7. Customer proceeds through Stidner's checkout.
8. On the checkout, the Customer can supply a discount code. If this code is given, Stidner will send this discount code to the Merchant's discount endpoint.
9. Merchant will validate this code. If the code supplied is valid, return the given discount; if the code is invalid, return error message.
10. Purchase is complete, and the checkout will trigger a browser redirect to supplied Merchant URL.
11. Customer's browser loads this confirmation URL (from redirect).
12. Merchant's server will fetch order data from Stidner for given checkout ID.
13. Stidner returns given order information (which includes order status, shipping address, payment method used, etc)
14. Merchant will includes the iframe URL (found in #13) to the Customer on their confirmation page.
15. Customer's browser requests Stidner's receipt page, which was supplied by #14.
16. Stidner sends the receipt page, showing that the purchase has been completed.

## Request

```json-object
POST /v1/order HTTP/1.1
Host: api.stidner.com
Authorization: Basic
Content-Type: application/json

{
    "merchant_reference1": "ref1",
    "merchant_reference2": "ref2",
    "purchase_country": "SE",
    "purchase_currency": "SEK",
    "locale": "se_sv",
    "total_price_excluding_tax": 151000,
    "total_tax_amount": 42750,
    "total_price_including_tax": 193750,
    "shipment_countries": ["DK", "SE"],
    "billing_address": {
        "type": "person",
        "first_name": "Sven",
        "family_name": "Andersson",
        "title": "mr",
        "phone": "+46851972000",
        "email": "svenandersson@example.com",
        "addressLine": "Drottninggatan 75",
        "addressLine2": "LGH 1102",
        "postalCode": "46133",
        "city": "Trollhättan",
        "region": "Västra Götalands Län",
        "countryCode": "SE"
    },
    "items": [
        {
            "type": "digital",
            "artno": "160830",
            "sku": "8000-660SE",
            "name": "World of Warcraft: Legion",
            "description": "Digital download",
            "quantity": 1,
            "quantity_unit": "pcs",
            "unit_price": 66000,
            "tax_rate": 2500,
            "total_price_excluding_tax": 66000,
            "total_tax_amount": 16500,
            "total_price_including_tax": 82500,
            "image_url": "https://example.com/game.jpg"
        },
        {
            "type": "physical",
            "artno": "220333",
            "sku": "5205-250SE",
            "name": "Golden shoes",
            "description": "These shoes are made of gold",
            "weight": 130,
            "quantity": 1,
            "quantity_unit": "pcs",
            "unit_price": 105000,
            "tax_rate": 2500,
            "total_price_excluding_tax": 105000,
            "total_tax_amount": 26250,
            "total_price_including_tax": 131250,
            "image_url": "https://example.com/goldshoes.jpg"
        },
        {
            "type": "discount",
            "artno": "REA200",
            "name": "Store Credit",
            "quantity": 1,
            "quantity_unit": "pcs",
            "unit_price": 20000,
            "tax_rate": 0,
            "total_price_excluding_tax": 20000,
            "total_tax_amount": 0,
            "total_price_including_tax": 20000
        }
    ],
    "merchant_urls": {
        "terms": "http://example.com/terms_of_service.html",
        "checkout": "http://example.com/checkout.php",
        "confirmation": "http://example.com/confirmation.php"
    },
    "options": {
        "color_background": "#ffffff"
    }
}
```
```php-sdk
<?php
// Include the composer autoloads, or whatever way you prefer.
require_once 'vendor/autoload.php';

// Initiate an API handle with the login credentials.
$api_handle = new \Stidner\Api(USER_ID_NUMBER, 'API_KEY');


// Set the merchant URLs.
// - Terms, Checkout, and Confirmation are required, and can be HTTP.
// - Push and Discount are optional, but must be HTTPS.
$merchant = new \Stidner\Model\Merchant();
$merchant->setTerms('http://example.com/terms_of_service.html')
    ->setCheckout('http://example.com/checkout.php')
    ->setConfirmation('http://example.com/confirmation.php')
    ->setPush(null)
    ->setDiscount(null);


// Optional: customize display elements on checkout.
// If you don't want to customize, you don't even need this initialized.
$options = new \Stidner\Model\Order\Options();
$options->setColorButton(null)
    ->setColorButtonText(null)
    ->setColorCheckbox(null)
    ->setColorCheckboxCheckmarks(null)
    ->setColorHeader(null)
    ->setColorLink(null)
    ->setColorBackground(null);


// Make billing address object.
$billingAddress = new \Stidner\Model\Address();
$billingAddress->setType('person')
    ->setBusinessName(null)// Do NOT use if setType("person")!
    ->setFirstName('Sven')
    ->setFamilyName('Andersson')
    ->setTitle('Mr')
    ->setAddressLine('Drottninggatan 75')
    ->setAddressLine2('LGH 1102')
    ->setPostalCode('46133')
    ->setCity('Trollhättan')
    ->setRegion('Västra Götalands Län')
    ->setPhone('+46851972000')
    ->setEmail('email@example.com')
    ->setCountryCode('SE');


// Add items. Each unique item in the order should have an unique ID or index.
$item[1] = new \Stidner\Model\Order\Item();
$item[1]->setType('digital')
    ->setArtno("123456")
    ->setSku("5205-250SE")
    ->setName('World of Warcraft: The Burning Crusade Collectors edition')
    ->setDescription("Latest game")
    ->setWeight(null)
    ->setQuantity(1)
    ->setQuantityUnit('pcs')
    ->setUnitPrice(66000)
    ->setTaxRate(2500)
    ->setTotalPriceExcludingTax(66000)// Note: can use calculateItemPrice() here instead.
    ->setTotalPriceIncludingTax(82500)
    ->setTotalTaxAmount(16500)
    ->setImageUrl("https://example.com/game.jpg");

// One more unique item (again, using a unique variable or index).
$item[2] = new \Stidner\Model\Order\Item();
$item[2]->setType('physical')
    ->setArtno("654321")
    ->setSku("5205-250SE")
    ->setName('Golden shoes')
    ->setDescription("These shoes are made of gold")
    ->setWeight(1300)
    ->setQuantity(1)
    ->setQuantityUnit('pcs')
    ->setUnitPrice(105000)
    ->setTaxRate(2500)
    ->setTotalPriceExcludingTax(105000)
    ->setTotalPriceIncludingTax(131250)
    ->setTotalTaxAmount(26250)
    ->setImageUrl("https://example.com/goldshoes.jpg");


// Bundle it all together now...
// Make the main order object, and add everything to it!
$order = new \Stidner\Model\Order();
$order->setMerchantReference1(null)
    ->setMerchantReference2(null)
    ->setPurchaseCountry("SE")
    ->setPurchaseCurrency("SEK")
    ->setLocale("sv_se")
    ->setTotalPriceExcludingTax(171000)// Note: can use calculateTotalPrices() here instead.
    ->setTotalPriceIncludingTax(213750)
    ->setTotalTaxAmount(42750)
    ->setBillingAddress($billingAddress) // Don't forget to add all the objects!
    ->addItem($item[1])
    ->addItem($item[2])
    ->setMerchantUrls($merchant)
    ->setOptions($options);


// Now send it off!
try {
    $request = $api_handle->createOrder($order);

    // Get Stidner Checkout's URL, which is in the $request object
    $iframeUrl = $request->getIframeUrl();

    // then load that URL in an iframe. Style it however fits best!
    echo "<iframe src='$iframeUrl' width='75%' height='75%'></iframe>";
} catch (\Stidner\ApiException $e) {
    print $e;
} catch (\Stidner\Api\ResponseException $e) {
    print $e;
}
?>
```

The API can be directly accessed by POSTing to https://api.stidner.com/v1/order, with the following requirements:

- Header "Authorization": must be BasicAuth. If you're not using the SDK, it will most likely be a base64-encoded string,
consisting of "USER-ID:API-KEY". You will receive these credentials from Stidner after sign-up.

- Header "Content-Type": should always be an application/json object.

- Body contents: should be only a properly-formatted json object. An example object is shown to the right in the
json-object language-tab, and the full options can be seen [later in the documentation](#order-object).


## Response

```json-object
HTTP/1.1 200 OK
Content-Type: application/json

{
    "status": 200,
    "message": "OK",
    "data": {
        "order_id": "NWM4MDI5ZWItZGM0MS00ZDQ5LWE1OWYtMmQ0NmU5MzEzZGY3",
        "iframe_url": "https://complete.stidner.com/order/NWM4MDI5ZWItZGM0MS00ZDQ5LWE1OWYtMmQ0NmU5MzEzZGY3",
        "merchant_reference1": "ref1",
        "merchant_reference2": "ref2",
        "purchase_country": "SE",
        "purchase_currency": "SEK",
        "locale": "se_sv",
        "total_price_including_tax": 193750,
        "total_price_excluding_tax": 151000,
        "total_tax_amount": 42750,
        "status": "purchase_incomplete",
        "shipment_status": "choosing_provider",
        "shipment_carrier": null,
        "shipment_product": null,
        "shipment_countries": ["DK", "SE"],
        "billing_address": {
            "type": "person",
            "business_name": null,
            "first_name": "Sven",
            "family_name": "Andersson",
            "title": "mr",
            "phone": "+46851972000",
            "email": "svenandersson@example.com",
            "addressLine": "Drottninggatan 75",
            "addressLine2": "LGH 1102",
            "postalCode": "46133",
            "city": "Trollhättan",
            "region": "Västra Götalands Län",
            "countryCode": "SE"
        },
        "shipping_address": {
            "type": "person",
            "business_name": null,
            "first_name": "Sven",
            "family_name": "Andersson",
            "title": "mr",
            "phone": "+46851972000",
            "email": "svenandersson@example.com",
            "addressLine": "Drottninggatan 75",
            "addressLine2": "LGH 1102",
            "postalCode": "46133",
            "city": "Trollhättan",
            "region": "Västra Götalands Län",
            "countryCode": "SE"
        },
        "merchant_urls": {
            "terms": "http://example.com/terms_of_service.html",
            "checkout": "http://example.com/checkout.php",
            "confirmation": "http://example.com/confirmation.php",
            "push": null,
            "discount": null
        },
        "created_date": "2016-07-26 13:01:26",
        "completed_date": "",
        "updated_date": "2016-07-26 13:01:26",
        "comment": "",
        "items": [
            {
                "sku": "8000-660SE",
                "artno": "160830",
                "name": "World of Warcraft: Legion",
                "type": "digital",
                "description": "Digital download",
                "total_price_excluding_tax": 66000,
                "total_tax_amount": 16500,
                "total_price_including_tax": 82500,
                "weight": null,
                "quantity": 1,
                "quantity_unit": "pcs",
                "unit_price": 66000,
                "image_url": "https://example.com/game.jpg",
                "tax_rate": 2500,
                "returned": 0,
                "refunded": 0
            },
            {
                "sku": "5205-250SE",
                "artno": "220333",
                "name": "Golden shoes",
                "type": "physical",
                "description": "These shoes are made of gold",
                "total_price_excluding_tax": 105000,
                "total_tax_amount": 26250,
                "total_price_including_tax": 131250,
                "weight": 130,
                "quantity": 1,
                "quantity_unit": "pcs",
                "unit_price": 105000,
                "image_url": "https://example.com/goldshoes.jpg",
                "tax_rate": 2500,
                "returned": 0,
                "refunded": 0
            },
            {
                "sku": "",
                "artno": "REA200",
                "name": "Store Credit",
                "type": "discount",
                "description": null,
                "total_price_excluding_tax": 20000,
                "total_tax_amount": 0,
                "total_price_including_tax": 20000,
                "weight": null,
                "quantity": 1,
                "quantity_unit": "pcs",
                "unit_price": 20000,
                "image_url": null,
                "tax_rate": 0,
                "returned": 0,
                "refunded": 0
            }
        ]
    }
}
```
```php-sdk
<?php
// You shouldn't need to see/handle the API response manually with the PHP SDK,
//  but you can of course var_dump($request) to see the object in testing.
//
// These two lines (previously shown in the example request) is the only handling
//  required for basic operation of the PHP SDK: loading the iframe_url.

$iframeUrl = $request->getIframeUrl();
echo "<iframe src='$iframeUrl' width='75%' height='75%'></iframe>";
?>
```

The response from the API will be a json object containing your inputs, and a few read-only items. One of these
read-only items is "iframe_url", which is the Stidner Complete checkout URL; this URL should be displayed in an iframe
on the merchant's checkout page.

The HTTP response code will be one of the following:

- 200 OK: all is fine, order is created.
- 401 Unauthorized: your Authorization header is invalid or missing.
- 412 Precondition Failed: validation failed on some variable in the json object; the "details" object in response will give more information.


# Order object

```php-sdk
<?php
// This creates the main order object, which will be sent to the API.
// Remember to include all the subobjects!

$order = new \Stidner\Model\Order();
$order->setMerchantReference1(null)
    ->setMerchantReference2(null)
    ->setPurchaseCountry('SE')
    ->setPurchaseCurrency('SEK')
    ->setLocale('sv_se')
    ->setTotalPriceExcludingTax(171000)
    ->setTotalPriceIncludingTax(213750)
    ->setTotalTaxAmount(42750)
    ->setBillingAddress($billingAddress)
    ->addItem($item[1])
    ->addItem($item[2])
    ->setMerchantUrls($merchant)
    ->setOptions($options);
?>
```

These following tables describe all the objects which will be sent in your
json-formatted POST request to the /order API.

This object will be the "main object" in your request, containing everything else which will be sent to the order API.

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| order\_id | String | Read-Only| The unique order ID, max 255 characters. This is created by our API, and you should always use it if it has been set.
| iframe\_url | String | Read-Only | This URL should be opened in an iframe if it has been set. This URL is typically a link to Stidner Complete's checkout page.
| merchant\_reference1, merchant\_reference2 | String | Optional | Optional internal order IDs, max 255 characters.
| purchase\_country | String | Required | The ISO 3166-1 alpha-2 (two character) country code of the customer.<br><br>*Example: "SE" for Sweden.*
| purchase\_currency | String | Required | The ISO 4217 (three character) currency code of the customer.<br><br>*Example: "SEK" for Swedish kronor.*
| locale | String | Required | The locale of the customer.<br><br>*Example: "se\_sv" for a Swedish IP visiting your page using the Swedish language.*
| total\_price\_excluding\_tax, total\_price\_including\_tax, total\_tax\_amount | Integer | Required | Price calculation of entire order. These values should include cents/ören (with an implicit decimal).<br><br>*Example for an order worth 150 SEK before tax, being 187.5 SEK after 25% VAT:*<br>`"total_price_excluding_tax": 15000,`<br>`"total_tax_amount": 3750,`<br>`"total_price_including_tax": 18750`
| status | String | Read-Only| A read-only response given by the API, showing status of order. Possible results: `"purchase_incomplete"` (default), `"purchase_complete"`, and `"purchase_refunded"`.
| shipment\_status | String | Read-Only| Shows the shipment status of an order. Possible results: `"choosing_provider"` (default), `"pending"`, and `"shipped"`.
| shipment\_carrier | String | Read-Only| Shows the selected shipping company. For example: `"dhl"`, `"bring"`, etc.
| shipment\_product | String | Read-Only| Shows what shipping service is being used. For example, `"PICKUP_PARCEL"` is the PickUp Parcel service from Bring.
| shipment\_countries | Array of strings | Optional | A list of countries which you may send your products to.<br><br>*Example for shipping within Scandinavia and Finland:* `shipment_countries: [ "FI", "SE", "NO", "DK" ]`
| billing\_address | [address](#address-subobject) Object | Optional | An optional subobject of the customer's billing/shipping info. Use this if you wish to supply some pre-supplied customer info; otherwise the API will do this for you. Please read [address Subobject](#address-subobject) for more information.
| shipping\_address | [address](#address-subobject) Object | Read-Only| A read-only response from the API. This contains the customer's shipping information which we fetched ourselves. This has the same structure as the billing-object. Please read [address Subobject](#address-subobject) for more information.
| items | Array of [item](#item-subobject) Object | Required | This subobject contains an array of objects, with one object for each item being sold to the customer. Please read [item Subobject](#item-subobject) for more information.
| merchant\_urls | [URLs](#urls-subobject) Object | Required | Callback URLs for various merchant-page URLs. Please read [URLs Object](#urls-subobject) for more information.
| options | [options](#options-subobject) Object | Optional | Optional checkout design options. Please read [options Subobject](#options-subobject) for more information.
| created\_date, completed\_date, updated\_date | Datetime (String) | Read-Only| Read-only response. Gives the datetime the order was created/completed/updated. Formatted as ISO 8601 datetime strings.
| comment | String | Optional | Set a comment on an order.
| free\_shipping | Boolean | Optional | Set to True to offer free shipping for the customer. If unset, this will default to False.


## address Subobject

```php-sdk
<?php
// Make the optional billing address object.

$billingAddress = new \Stidner\Model\Address();
$billingAddress->setType('person')
    ->setBusinessName(null)// Do NOT use if setType("person")!
    ->setFirstName('Sven')
    ->setFamilyName('Andersson')
    ->setTitle('Mr')
    ->setAddressLine('Drottninggatan 75')
    ->setAddressLine2('LGH 1102')
    ->setPostalCode('46133')
    ->setCity('Trollhättan')
    ->setRegion('Västra Götalands Län')
    ->setPhone('+46851972000')
    ->setEmail('email@example.com')
    ->setCountryCode('SE');
?>
```

This object can be set using the key "billing_address", but it is not required.

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| type | String | Required | Must be set to either `"person"` (private customers) or `"business"` (if selling to a business).
| business_name | String | Conditional | Customer's business name, if they are buying as a business. Max 100 characters.
| first\_name | String | Conditional | Customer's first name. Max 100 characters.
| family\_name | String | Conditional | Customer's last name. Max 100 characters.
| title | String | Optional | Title of customer. (Mr, Mrs, Dr, etc)
| addressLine | String | Required | Street address of customer, first line. Max 100 characters.<br><br>*Example: "Drottninggatan 57"*
| addressLine2 | String | Optional | Street address of customer, second line. Max 100 characters.<br><br>*Example: "LGH 1102"*
| postalCode | String | Required | Customer's postal code.<br><br>*Example: "46132"*
| city | String | Required | Customer's city.
| region | String | Required | Customer's region or state.<br><br>*Example: "Västra Götalands län"*
| phone | String | Required | Customer's phone number, including country code.<br><br>*Example: "+46851972000"*
| email | String | Required | Customer's email address.
| countryCode | String | Required | The ISO 3166-1 alpha-2 (two character) country code of the customer.<br><br>*Example: "SE" for Sweden.*


## item Subobject

```php-sdk
<?php
// Add items. Each unique item in the order should have an unique ID or index.
$item[1] = new \Stidner\Model\Order\Item();
$item[1]->setType('digital')
    ->setArtno('123456')
    ->setSku('5205-250SE')
    ->setName('World of Warcraft: The Burning Crusade Collectors edition')
    ->setDescription('Latest game')
    ->setWeight(null)
    ->setQuantity(1)
    ->setQuantityUnit('pcs')
    ->setUnitPrice(66000)
    ->setTaxRate(2500)
    ->setTotalPriceExcludingTax(66000)//Note: can use calculateItemPrice() here.
    ->setTotalPriceIncludingTax(82500)
    ->setTotalTaxAmount(16500)
    ->setImageUrl('https://example.com/game.jpg');

// One more unique item (again, using a unique variable or index).
$item[2] = new \Stidner\Model\Order\Item();
$item[2]->setType('physical')
    ->setArtno('654321')
    ->setSku('5205-250SE')
    ->setName('Golden shoes')
    ->setDescription('These shoes are made of gold')
    ->setWeight(1300)
    ->setQuantity(1)
    ->setQuantityUnit('pcs')
    ->setUnitPrice(105000)
    ->setTaxRate(2500)
    ->setTotalPriceExcludingTax(105000)
    ->setTotalPriceIncludingTax(131250)
    ->setTotalTaxAmount(26250)
    ->setImageUrl('https://example.com/goldshoes.jpg');
?>
```

This is the "item" subobject, which basically is an array of items in a customer's order, and various related values.

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| type | String | Required | The "type of item" this object is.<br><br>Acceptable values: `"physical"` (items you will eventually ship), `"digital"` (non-physical items, such as a software license key), `"fee"` (various fees, such as a shipping expense), and `"discount"` (store promotions, such as a sale code).
| artno | String | Required | Article number in the internal system.
| sku | String | Optional | The SKU of the item.
| name | String | Required | The name of the product.
| description | String | Optional | The description of the product.
| weight | Integer | Conditional | Needed when type is set to "physical". Weight of product, in grams. Will be rounded to the nearest tenth.<br><br>*Example: an item of 10,5kg would be set as '1050'.*
| quantity | Integer | Required | Quantity of item.
| quantity\_unit | String | Required | Unit to describe quantity. <br><br>Acceptable values: `"pcs"`, `"metre"`, `"m3"`, or `"kg"`.
| unit\_price | Integer | Required | How much each unit costs. This will be in minor units, excluding tax.<br><br>*Example: if one unit of an item you're selling is worth 40 SEK before tax, you would use '4000' here.*
| tax\_rate | Integer | Required | The tax rate of this item. Written like most numbers in this API: no decimals, but to the 10th place.<br><br>*Example: in Sweden, the standard VAT rate is 25%, so the request is most likely going to be:* `"tax_rate": 2500`
| total\_price\_excluding\_tax, total\_price\_including\_tax, total\_tax\_amount | Integer | Required | This object's price calculations. These values should include cents/ören (with an implicit decimal). Basically the same thing as the main order calculation, but containing only this item's values.<br><br>*Example: one customer buys 3 of the same coffee mug. 40 SEK is the value of each mug, giving 120 SEK total before tax. Given the VAT rate of 25%, 30 SEK is added in tax. So the finalized values become:* `"total_price_excluding_tax": 12000,` `"total_tax_amount": 3000,` `"total_price_including_tax": 15000`
| image\_url | String | Optional | URL to a picture of this item. Max 2000 characters.


## urls Subobject

```php-sdk
<?php
// Set the merchant URLs.
// - Terms, Checkout, and Confirmation are required, and can be HTTP/HTTPS.
// - Push and Discount are optional, but must be HTTPS.

$merchant = new \Stidner\Model\Merchant();
$merchant->setTerms('http://example.com/terms_of_service.html')
    ->setCheckout('http://example.com/checkout.php')
    ->setConfirmation('http://example.com/confirmation.php')
    ->setPush(null)
    ->setDiscount(null);
?>
```

All of the items in this object are strings, which should be URLs. These URLs should link to various pages of the
merchant's web-shop.

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| terms | String | Required | HTTP/HTTPS URL to the merchant's Terms and Conditions page.
| checkout | String | Required | HTTP/HTTPS URL to the merchant's checkout page.
| confirmation | String | Required | HTTP/HTTPS URL to the merchant's confirmation page.
| push | String | Optional | HTTPS-only URL to the merchant push endpoint. If used, this will be an endpoint on the merchant's server which can receive an optional push of the final order status. This will be a json object with basically the same keys and structures as the initial POST's response. If this feature is used, the URL must be HTTPS. *As a reminder, if you want to view the formatting:* send a GET to https://api.stidner.com/v1/order/$order\_id, with "$order\_id" being the order's ID.
| discount | String | Optional | HTTPS-only URL to the merchant's discount page. This is used during checkout to get the value and validity of any discount code provided by the customer. This **must** be set if you are wishing to offer any kinds of discount codes with our discount process. Please read [Discount Callback](#discount-callback) for more information and requirements.


## options Subobject

```php-sdk
<?php
// Optional: customize display elements on checkout.
// If you don't want to customize, you don't even need this initialized.

$options = new \Stidner\Model\Order\Options();
$options->setColorButton(null)
    ->setColorButtonText(null)
    ->setColorCheckbox(null)
    ->setColorCheckboxCheckmarks(null)
    ->setColorHeader(null)
    ->setColorLink(null)
    ->setColorBackground(null);
?>
```

All of the items in this object are strings of CSS hex colors (eg #FFFFFF). These are all optional, and only need to be
used if the merchant wishes to customize Stidner's checkout design. Acceptable values:

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| color\_button | String | Optional | Color to fill the checkout buttons with.
| color\_button\_text | String | Optional | Color of the characters in the buttons on the checkout pages.
| color\_checkbox | String | Optional | Color to fill checkboxes with.
| color\_checkbox\_checkmarks | String | Optional | Color of any checkmarks in checkboxes.
| color\_header | String | Optional | Color of header texts.
| color\_link | String | Optional | Color of links.
| color\_background | String | Optional | Background coloring.<br><br>*Example for a white background:* `"color_background": "#ffffff"`


# Discount Callback

This section references the *optional* discount system and how it all connects. There are two parts in this process:

1. [Stidner Checkout's request](#stidner-checkout-39-s-request), and
2. [Merchant's response](#merchant-39-s-response)

As a merchant, you have a URL set up which will accept a POST from Stidner's servers containing a json object, and
your response should be another json object showing if the discount code entered was valid or not.

Again, this is a callback for the discount process; you do not need to use it if you are not setting `urls.discount` in
the order API, and/or if you will not be offering discount codes in the checkout.


## Stidner Checkout's request

> Example request:

```http
POST /discounts HTTP/1.1
Host: merchant.example.com
Authorization: Basic
Content-Type: application/json

{
    "order_id": "ZWU2Mjc0NmYtMDRiMy00ZFOZLTgzNWYtZDU5MGJmZjJmNjQ0",
    "discount_code": "100KR-SALE"
}
```

This object is sent from Stidner's servers to the merchant's configured discount URL. To make discounting very flexible,
merchants will manage their own discounts through their own endpoint.

To reiterate, merchants will **not** be crafting this request. This request will be sent to the merchant's server
from Stidner's checkout page when a customer tries to enter a discount code. The merchant will simply read this
request (which will be sent to the previously configured `urls.discount` endpoint), and will respond in the format
defined in the [response section](#merchant-39-s-response).

Additionally, the merchant endpoint Stidner Checkout will be sending to:

- must be using HTTPS, and
- must only accept requests using your BasicAuth token (which was used to create the order in the first place).


| Key name | Type | R/O/C | Description |
|---|---|---|---|
| order_id | String | Required | The unique order ID. This should always be the existing ID generated by the /order API.
| discount_code | String | Required | The discount code that a customer is trying to apply.
| merchant_reference1, merchant_reference2 | String | Optional | Optional internal reference IDs.


## Merchant's response

> Example response (**SUCCESS**):

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "order_id": "ZWU2Mjc0NmYtMDRiMy00ZFOZLTgzNWYtZDU5MGJmZjJmNjQ0",
    "discount_code": "100KR-SALE",
    "name": "100kr sale!",
    "description": "Save 100 SEK on all orders of more than 500 SEK.",
    "artno": "discount_100530",
    "amount": "10000"
}
```

As said above, this is the merchant's part to handle; all the converting, processing, etc is for the merchant to do.
Stidner Checkout will just take the amount returned here, and internally subtract it from the order's total cost.
<br/><br/>

*If the discount code was valid*, the merchant's system should send back everything it received in the previous POST,
and add on the following:

1. An article number for the discount code,
2. the name and description of the discount code, and
3. how much currency to subtract from the order.

> Example response (**DENIAL**):

```http
HTTP/1.1 412 Precondition Failed
Content-Type: application/json

{
    "order_id": "ZWU2Mjc0NmYtMDRiMy00ZFOZLTgzNWYtZDU5MGJmZjJmNjQ0",
    "discount_code": "100KR-SALE",
    "description": "Code applies only to orders of more than 500 SEK."
}
```
<br/>

*If the discount code is invalid*, the merchant's system should send back only:

1. The order\_id,
2. the given discount\_code, and
3. a description of why it failed.
4. HTTP response code 412 (but anything other than 200 should be fine)
<br/><br/>

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| order\_id | String | Read-Only| The unique order ID. This should always be the existing ID previously generated by the /order API.
| discount\_code | String | Read-Only| The discount code that a customer is trying to apply.
| merchant\_reference1, merchant\_reference2 | String | Optional | Optional internal reference IDs.
| name, description | String | Required | A name and description of what the discount is for. This will be shown on various customer and merchant pages, so proper (non-"internal") descriptions and names are important, as to reduce any possible confusion! The description should be set to a customer-friendly error message if the discount code is denied; see above denial for an example.
| artno | String | Required | Article number for internal system.
| amount | Integer | Required | This should be how much to subtract from the order. This should be in basic units (meaning 100 SEK becomes '10000', 5 EUR is '500', etc).



# Questions/Comments

We hope this documentation was useful and answered any questions regarding the Stidner Complete API! But documentation
doesn't always answer everything, so please feel free to get in contact with us via
<a href='mailto:integration@stidner.com'>email</a>. Thank you!
