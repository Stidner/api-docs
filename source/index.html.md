---
title: Stidner - Order API documentation

toc_footers:
  - <a href='http://stidner.com/'>About Stidner</a>
  - <a href='http://stidner.com/'>Request an API key</a>

language_tabs:
  - json-object
  - php-sdk

search: true
---

# Order API

This document references the /order API endpoint and its contents, which developers can use to create checkout orders.

Note: we offer a [PHP SDK](https://github.com/Stidner/php-sdk) if you would like to use that to craft requests instead.
<br />
Some parts in this document assumes that you will be using the API directly (without the SDK), but most of the
information is still relevant. In addition, you can change the language-tab on the right-hand sidebar to "php-sdk" for
the PHP SDK examples, instead of the typical JSON objects.
<br />
Additionally, you can read the auto-generated (phpDocumentor) docs [here](http://developer.stidner.com/phpdoc/).


## Request

```json-object
POST /v1/order HTTP/1.1
Host: api.stidner.com
Authorization: Basic
Content-Type: application/json

{
    "merchant_reference1": "Reference123",
    "merchant_reference2": "Reference321",
    "purchase_country": "SE",
    "purchase_currency": "SEK",
    "locale": "se_sv",
    "total_price_excluding_tax": 151000,
    "total_tax_amount": 42750,
    "total_price_including_tax": 193750,
    "billing_address": {
        "type": "person",
        "first_name": "Sven",
        "family_name": "Andersson",
        "title": "Mr",
        "phone": "+46851972000",
        "email": "email@example.com",
        "addressLine": "Drottninggatan 75",
        "addressLine2": "LGH 1102",
        "postalCode": "46133",
        "city": "Trollhättan",
        "region": "Västra Götalands Län",
        "countryCode": "SE"
    },
    "items":
    [
        {
            "type": "digital",
            "artno": "123456",
            "sku": "5205-250SE",
            "name": "World of Warcraft: The Burning Crusade Collectors edition",
            "description": "Latest game",
            "weight": 130,
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
            "artno": "654321",
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
            "artno": "654321",
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
    ->setTotalPriceExcludingTax(66000)
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
    ->setTotalPriceExcludingTax(171000)
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

The API can be directly accessed by POSTing to https://api.stidner.com/v1/order.

Header requirements (non-SDK users):

- "Authorization": must be BasicAuth. If you're not using the SDK, it will most likely be a base64-encoded string,
consisting of "USER-ID:API-KEY". You will receive these credentials from Stidner after sign-up.

- "Content-Type": should always be an application/json object.

Request body (non-SDK users):

- Body contents should be only a properly-formatted json object. An example object is shown to the right in the
json-object language-tab, and the full options can be seen [later in the documentation](#order-object).


## Response

```json-object
HTTP/1.1 200 OK
Content-Type: application/json

{
    "status": 200,
    "message": "OK",
    "data": {
        "order_id": "NmI5M2U2MTMtNDA1MC00NjdhLTk3ZDItY2YxZjVjZWM4ZjM1",
        "iframe_url": "https://complete.stidner.com/order/NmI5M2U2MTMtNDA1MC00NjdhLTk3ZDItY2YxZjVjZWM4ZjM1",
        "merchant_reference1": "Reference123",
        "merchant_reference2": "Reference321",
        "purchase_country": "SE",
        "purchase_currency": "SEK",
        "locale": "se_sv",
        "total_price_including_tax": 193750,
        "total_price_excluding_tax": 151000,
        "total_tax_amount": 42750,
        "status": "purchase_incomplete",
        "billing_address": {
            "type": "person",
            "business_name": null,
            "first_name": "Sven",
            "family_name": "Andersson",
            "title": "mr",
            "phone": "+46851972000",
            "email": "email@example.com",
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
            "email": "email@example.com",
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
        "created_date": "2016-06-29 14:52:11",
        "completed_date": "",
        "updated_date": "2016-06-29 14:52:11",
        "comment": "",
        "items":
        [
            {
                "sku": "5205-250SE",
                "artno": "123456",
                "name": "World of Warcraft: The Burning Crusade Collectors edition",
                "type": "digital",
                "description": "Latest game",
                "total_price_excluding_tax": 66000,
                "total_tax_amount": 16500,
                "total_price_including_tax": 82500,
                "weight": 130,
                "quantity": 1,
                "quantity_unit": "pcs",
                "unit_price": 66000,
                "image_url": "https://example.com/game.jpg",
                "tax_rate": 2500,
                "refunded": 0
            },
            {
                "sku": "5205-250SE",
                "artno": "654321",
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
                "refunded": 0
            },
            {
                "sku": "",
                "artno": "654321",
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

For non-SDK users, here is an example of the response you should get after sending
the request shown above. The HTTP status code has a few results:

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

This particular object will be the "main object" in your request, which contains all other
strings and objects which will be sent to the order API.

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| order\_id | String | Read-Only| The unique order ID, max 255 characters. This is created by our API, and you should always use it if it has been set.
| iframe_url | String | Read-Only | This URL should be opened in an iframe if it has been set. This URL is typically a link to Stidner Complete's checkout page.
| merchant\_reference1, merchant\_reference2 | String | Optional | Optional internal order IDs, max 255 characters.
| purchase\_country | String | Required | The ISO 3166-1 alpha-2 (two character) country code of the customer.<br><br>*Example: "SE" for Sweden.*
| purchase\_currency | String | Required | The ISO 4217 (three character) currency code of the customer.<br><br>*Example: "SEK" for Swedish kronor.*
| locale | String | Required | The locale of the customer.<br><br>*Example: "se\_sv" for a Swedish IP visiting your page using the Swedish language.*
| total\_price\_excluding\_tax, total\_price\_including\_tax, total\_tax\_amount | Integer | Required | Price calculation of entire order. These values should include cents/ören (with an implicit decimal).<br><br>*Example for an order worth 150 SEK before tax, being 187.5 SEK after 25% VAT:*<br>`"total_price_excluding_tax": 15000,`<br>`"total_tax_amount": 3750,`<br>`"total_price_including_tax": 18750`
| status | String | Read-Only| A read-only response given by the API, showing status of order. Possible values: `"purchase_incomplete"` (default), `"purchase_complete"`, and `"purchase_refunded"`.
| billing\_address | [address](#address-subobject) Object | Optional | An optional subobject of the customer's billing/shipping info. Use this if you wish to supply some pre-supplied customer info; otherwise the API will do this for you. Please read [address Subobject](#address-subobject) for more information.
| shipping\_address | [address](#address-subobject) Object | Read-Only| A read-only response from the API. This contains the customer's shipping information which we fetched ourselves. This has the same structure as the billing-object. Please read [address Subobject](#address-subobject) for more information.
| items | Array of [item](#item-subobject) Object | Required | This subobject contains an array of objects, with one object for each item being sold to the customer. Please read [item Subobject](#item-subobject) for more information.
| merchant\_urls | [URLs](#urls-subobject) Object | Required | Callback URLs for various merchant-page URLs. Please read [URLs Object](#urls-subobject) for more information.
| options | [options](#options-subobject) Object | Optional | Optional checkout design options. Please read [options Subobject](#options-subobject) for more information.
| shipping\_countries | Array of strings | Optional | A list of countries which you may send your products to.<br><br>*Example for shipping within Scandinavia and Finland:* `shipping_countries: {"FI", "SE", "NO", "DK"}`
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
    ->setTotalPriceExcludingTax(66000)
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

This is the "item" subobject, which basically is an array of items
in a customer's order, and various related values. For example, if a
customer bought 3 of the same coffee mug, and one bag of coffee from
your store, you would use this object twice in the main "order" items
array. Values:

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

All of the items in this object are strings of URLs. These URLs should
link to various pages of your web-shop. Values:

| Key name | Type | R/O/C | Description |
|---|---|---|---|
| terms | String | Required | HTTP/HTTPS URL to the merchant's terms and conditions page.
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

All of the items in this object are strings of CSS hex colors (eg #FFFFFF).
All of these are 100% optional, but feel free to use them if you wish to
customize the checkout design. Acceptable values:

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

This section references the discount system and how it all connects.
There are two parts in this process:

1. [Stidner Checkout's request](#stidner-checkout-39-s-request), and
2. [Merchant's response](#merchant-39-s-response)


As a reminder, this is a callback for the discount process; you do not need to use it if you
are not using `urls.discount` in the order API.


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

This object is sent from Stidner's servers to the web-shop's discount URL.
To make discounting very flexible, we have chosen to have the shop-owner
manage their own discounts, through their own endpoint.

To reiterate, you will **not** be crafting this first object as a
merchant. This object will be sent from the Stidner Checkout page when a
customer enters a discount code. As a merchant, you simply read this
request (which will be sent to the previously configured "discount" URL,
which was set in the [Order API](#order-api)), and then respond in the format
defined in the [response section](#merchant-39-s-response).

Additionally, the merchant endpoint Stidner Checkout will be sending to:

- must be using HTTPS, and

- must accept requests only with the shared BasicAuth token
(as a reminder, you used it to POST to the [Order API](#order-api)).


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
    "description": "Save 100 SEK on all orders more than 500 SEK.",
    "artno": "discount_100530",
    "amount": "10000"
}
```

As said above, this is the merchant's part to handle; all the
converting, processing, etc is in your hands. Stidner Checkout will
simply take the amount returned here, and internally subtract it from the order's
total cost.

If the discount code was successful, your system should send back
everything it received in the above POST, plus adding on the
following:

1.  An article number for the discount,
2.  the name and description of the discount code, and
3.  how much currency to subtract from the order.

> Example response (**DENIAL**):

```http
HTTP/1.1 412 Precondition Failed
Content-Type: application/json

{
    "order_id": "ZWU2Mjc0NmYtMDRiMy00ZFOZLTgzNWYtZDU5MGJmZjJmNjQ0",
    "discount_code": "100KR-SALE",
    "description": "Code only applies to orders of more than 500 SEK."
}
```

If the discount code is denied for some reason, the server should send
back only:

1. The order\_id,
2. the given discount\_code, and
3. a description of why it failed.

Additionally, the HTTP response code should be *anything except*
HTTP 200; we suggest using HTTP 412.


| Key name | Type | R/O/C | Description |
|---|---|---|---|
| order\_id | String | Read-Only| The unique order ID. This should always be the existing ID previously generated by the /order API.
| discount\_code | String | Read-Only| The discount code that a customer is trying to apply.
| merchant\_reference1, merchant\_reference2 | String | Optional | Optional internal reference IDs.
| name, description | String | Required | A name and description of what the discount is for. This will be shown on various customer and merchant pages, so proper (non-"internal") descriptions and names are important, as to reduce any possible confusion! The description should be set to a customer-friendly error message if the discount code is denied; see above denial for an example.
| artno | String | Required | Article number for internal system.
| amount | Integer | Required | This should be how much to subtract from the order. This should be in basic units (meaning 100 SEK becomes '10000', 5 EUR is '500', etc).

