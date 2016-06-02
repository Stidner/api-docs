---
title: Stidner -- Order API documentation

toc_footers:
  - <a href='http://stidner.com/'>About Stidner</a>
  - <a href='http://stidner.com/'>Request an API key</a>

search: true
---

# Order API

This document references the /order API endpoint and its contents, which developers can use to create checkout orders.

Note: we offer a [PHP SDK](https://github.com/Stidner/php-sdk) if you would like to use that to craft requests instead.


## Request

> **You must use both HTTPS and BasicAuth when posting to this API.**

```http
POST /v1/order HTTP/1.1
Host: api.stidner.com
Authorization: Basic
Content-Type: application/json
```
```json
{
    "purchase_country": "SE",
    "purchase_currency": "SEK",
    "locale": "se_sv",
    "total_price_excluding_tax": 171000,
    "total_tax_amount": 42750,
    "total_price_including_tax": 213750,
    "billing_address": {
        "first_name": "Sven",
        "family_name": "Andersson",
        "title": "Mr",
        "street_address": "Drottninggatan 75",
        "postal_code": "461 33",
        "region": "Västra Götalands Län",
        "country": "SE"
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
            "image_url": "http://test.test"
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
            "image_url": "http://test.test"
        }
    ],
    "merchant_urls": {
        "terms": "https://example.com",
        "checkout": "https://example.com",
        "confirmation": "https://example.com",
        "push": "https://example.com"
    },
    "options": {
        "color_background": "#ffffff"
    }
}
```

This is an example request which should be POSTed to api.stidner.com/v1/order using HTTPS and BasicAuth.

For headers:

- Authorization will be using BasicAuth; it will be a base64-encoded string, which consists of "USER-ID:API-KEY".
You will receive these credentials after you sign up.

- The Content-Type should also always be an application/json object.

For the request body:

- Body should be just a properly-formatted json object. An example object is shown to the right, and the full
options are shown [later in the documentation](#main-quot-order-quot-object).


## Response

```http
HTTP/1.1 200 OK
Content-Type: application/json
```
```json
{
    "status": 200,
    "message": "OK",
    "data": {
        "order_id": "ZWU2Mjc0NmYtMDRiMy00ZFOZLTgzNWYtZDU5MGJmZjJmNjQ0",
        "purchase_country": "SE",
        "purchase_currency": "SEK",
        "locale": "se_sv",
        "status": "",
        "total_price_excluding_tax": "171000",
        "total_tax_amount": "42750",
        "total_price_including_tax": "213750",
        "billing_address": {
            "first_name": "Sven",
            "family_name": "Andersson",
            "street_address": "Drottninggatan 75",
            "postal_code": "461 33",
            "region": "Västra Götalands Län",
            "country": "SE"
        },
        "items":
        [
            {
                "type": "digital",
                "artno": "123456",
                "sku": "5205-250SE",
                "name": "World of Warcraft: The Burning Crusade Collectors edition",
                "description": "Latest game",
                "weight": "130",
                "quantity": "1",
                "quantity_unit": "pcs",
                "unit_price": "66000",
                "tax_rate": "2500",
                "total_price_excluding_tax": "66000",
                "total_tax_amount": "16500",
                "total_price_including_tax": "82500",
                "image_url": "https://example.com/game.jpg"
            },
            {
                "type": "physical",
                "artno": "654321",
                "sku": "5205-250SE",
                "name": "Golden shoes",
                "description": "These shoes are made of gold",
                "weight": "130",
                "quantity": "1",
                "quantity_unit": "pcs",
                "unit_price": "105000",
                "tax_rate": "2500",
                "total_price_excluding_tax": "105000",
                "total_tax_amount": "26250",
                "total_price_including_tax": "131250",
                "image_url": "https://example.com/goldshoes.jpg"
            }
        ],
        "merchant_urls": {
            "terms": "https://example.com",
            "checkout": "https://example.com",
            "confirmation": "https://example.com",
            "push": "https://example.com"
        },
        "options": {
            "color_background": "#ffffff"
        }
    }
}
```

Here is an example of the response you should get when sending the POST shown above.

The HTTP status code has a few results:

- 200 OK: all is fine, order is created.
- 401 Unauthorized: your Authorization header is invalid or missing.
- 412 Precondition Failed: validation failed on some variable in the json object; the "details" object in response will give more information.


# Main "order" object

These following tables describe all the objects which will be sent in your
json-formatted POST request to the /order API.

This particular object should be the "main object", which contains all other
strings and objects which will be sent to the order API.


| Key name              | Type      | R/O/C    | Description                      |
|-----------------------|-----------|----------|----------------------------------|
| order\_id             | String    | Read-Only| The unique order ID, max 255 characters. This is created by our API, and you should always use it if it has been set.
| purchase\_country     | String    | Required | The ISO 3166-1 alpha-2 (two character) country code of the customer. *Example: "SE" for Sweden.*
| purchase\_currency    | String    | Required | The ISO 4217 (three character) currency code of the customer. *Example: "SEK" for Swedish kronor.*                         |
| locale                | String    | Required | The locale of the customer. *Example: "se\_sv" for a Swedish IP visiting your page using the Swedish language.*
| status                | String    | Read-Only| A read-only response given by the API, showing status of order. Possible values: `"example1"`, `"TODO"`, `"example3"`, `"example4"`, `"example5"`, and `"example6"`.
| billing\_address      | Object    | Optional | An optional subobject array of the customer's billing/shipping info. Use this if you wish to supply some pre-supplied customer info; otherwise the API will do this for you. Please read [Billing Subobject](#billing-subobject) for more information.
| shipping\_address     | Object    | Read-Only| A read-only response from the API. This contains the customer's shipping information which we fetched ourselves. This has the same structure as the billing-object.
| total\_price\_excluding\_tax, total\_price\_including\_tax, total\_tax\_amount | Integer   | Required | Price calculation of entire order. These values should include cents/ören (with an implicit decimal). *Example for an order worth 150 SEK before tax, being 187.5 SEK after 25% VAT:* `"total_price_excluding_tax": 15000,` `"total_tax_amount": 3750,` `"total_price_including_tax": 18750`
| items                 | Array of objects | Required | This subobject contains an array of objects, with one object for each item being sold to the customer. Please read [Resource Subobject](#resource-subobject) for more information.
| comment               | String    | Optional | Set a comment on an order.
| customer              | Object    | Conditional | Include some customer-related information. Only needed if selling to a business. Please read [Customer Subobject](#customer-subobject) for more information.
| merchant\_urls        | Object    | Required | Callback URLs for various merchant-page URLs. Please read [Merchant Object](#merchant-subobject) for more information.
| merchant\_reference1, merchant\_reference2  | String    | Optional | Optional internal order IDs.
| created\_date, completed\_date, updated\_date | Datetime (String) | Read-Only| Read-only response. Gives the datetime the order was created/completed/updated. Formatted as ISO 8601 datetime strings.
| options               | Object    | Optional | Optional checkout design options. Please read [Options Subobject](#options-subobject) for more information.
| shipping\_countries   | Array of strings | Optional | A list of countries which you may send your products to. *Example for shipping within Scandinavia and Finland:* `shipping_countries: {"FI", "SE", "NO", "DK"}`                   |
| free\_shipping        | Boolean   | Optional | Set to True to offer free shipping for the customer. If unset, this will default to False.


## Billing Subobject

| Key name              | Type      | R/O/C    | Description                      |
|-----------------------|-----------|----------|----------------------------------|
| business\_name        | String    | Optional | Customer's business name, if they are buying as a business. ```json { "hi": 2 }```
| first\_name           | String    | Optional | Customer's first name.
| family\_name          | String    | Optional | Customer's last name.
| title                 | String    | Optional | Title of customer. (Mr, Mrs, Dr, etc)
| street\_address       | String    | Optional | Street address of customer, first line. *Example: "Drottninggatan 57"*
| street\_address2      | String    | Optional | Street address of customer, second line. *Example: "LGH 1102"*
| postal\_code          | String    | Optional | Customer's postal code. *Example: "46132"*
| city                  | String    | Optional | Customer's city.
| region                | String    | Optional | Customer's region or state. *Example: "Västra Götalands län"*
| phone                 | String    | Optional | Customer's phone number, including country code. *Example: "|4672922xxxx"*
| country               | String    | Optional | The ISO 3166-1 alpha-2 (two character) country code of the customer. *Example: "SE" for Sweden.*
| email                 | String    | Optional | Customer's email address.


## Resource Subobject

This is the resource object, which basically describes one type of item
in a customer's order, and various related values. For example, if a
customer bought 3 of the same coffee mug, and one bag of coffee from
your store, you would use this object twice in the main "order" items
array. Values:

| Key name              | Type      | R/O/C    | Description                      |
|-----------------------|-----------|----------|----------------------------------|
| type                  | String    | Required | The "type of item" this object is. Acceptable values: "physical" (items you will eventually ship), "digital" (non-physical items, such as a software license key), "fee" (various fees, such as a shipping expense), and "discount" (store promotions, such as a sale code).
| artno                 | String    | Required | Article number in the internal system.
| sku                   | String    | Optional | The SKU of the item.
| name                  | String    | Required | The name of the product.
| description           | String    | Optional | The description of the product.
| weight                | Integer   | Conditional | Weight of product, in grams. Will be rounded to the nearest tenth. Only used if the "type" of item is "physical". *Example: an item of 10,5kg would be set as '1050'.*
| quantity              | Integer   | Required | Quantity of item.
| quantity\_unit        | String    | Conditional | Unit to describe quantity. Only used when &lt;TODO&gt;. *Example: "kg", "pcs", etc.*
| unit\_price           | Integer   | Required | How much each unit costs. This will be in minor units, excluding tax. *Example: if one unit of an item you're selling is worth 40 SEK before tax, you would use '4000' here.*
| tax\_rate             | Integer   | Required | The tax rate of this item. Written like most numbers in this API: no decimals, but to the 10th place. *Example: in Sweden, the standard VAT rate is 25%, so the request is most likely going to be:* `"tax_rate": 2500`
| total\_price\_excluding\_tax, total\_price\_including\_tax, total\_tax\_amount | Integer   | Required | This object's price calculations. These values should include cents/ören (with an implicit decimal). Basically the same thing as the main order calculation, but containing only this item's values. *Example: one customer buys 3 of the same coffee mug. 40 SEK is the value of each mug, giving 120 SEK total before tax. Given the VAT rate of 25%, 30 SEK is added in tax. So the finalized values become:* `"total_price_excluding_tax": 12000,` `"total_tax_amount": 3000,` `"total_price_including_tax": 15000`
| image\_url            | String    | Optional | URL to a picture of this item.


## Customer Subobject

This object only needs to be initialized if you are selling to a business.

| Key name              | Type      | R/O/C    | Description                      |
|-----------------------|-----------|----------|----------------------------------|
| email                 | String    | Optional | The customer's email address.
| phone                 | String    | Optional | The customer's phone number.
| type                  | String    | Required | Despite being "required", this does not need to be set, unless you're setting an "orgno" as well. (This will be set internally to "person", meaning a private customer. If you set an orgno, this should be set explicitly to "business").
| orgno                 | String    | Conditional | The customer's organization number. This should only be used if "type" is set to "business".


## Merchant-URLs Subobject

All of the items in this object are strings of URLs. These URLs should
link to various pages of your webshop. Values:

| Key name              | Type      | R/O/C    | Description                      |
|-----------------------|-----------|----------|----------------------------------|
| terms                 | String    | Required | URL to the merchant's terms and conditions page.
| checkout              | String    | Required | URL to the merchant's checkout page.
| confirmation          | String    | Required | URL to the merchant's confirmation page.
| push                  | String    | Optional | URL to the merchant push endpoint. If used, this will be an endpoint on the merchant's server which can receive an optional push of the final order status. This will be a json object with basically the same keys and structures as the initial POST's response. If this feature is used, the URL must be HTTPS. *As a reminder, if you want to view the formatting:* send a GET to api.stidner.com/v1/order/\$order\_id, with \$order\_id being the order's ID.
| discount              | String    | Optional | URL to the merchant's discount page. This is used during checkout to get the value and validity of any discount code provided by the customer. This **must** be set if you are wishing to offer any kinds of discount codes with our discount process. Please read [Discount Callback](discount.html) for more information and requirements.


## Options Subobject

All of the items in this object are strings of CSS hex colors. All of
these are 100% optional, but feel free to use them if you wish to
customize the checkout design. Acceptable values:

| Key name              | Type      | R/O/C    | Description                      |
|-----------------------|-----------|----------|----------------------------------|
| color\_button         | String    | Optional | Color to fill the checkout buttons with.                   | color\_button\_text   | String    | Optional | Color of the characters in the buttons on the checkout pages.
| color\_checkbox       | String    | Optional | Color to fill checkboxes with.
| color\_checkbox\_checkmarks | String    | Optional | Color of any checkmarks in checkboxes.
| color\_header         | String    | Optional | Color of header texts.
| color\_link           | String    | Optional | Color of links.
| color\_background     | String    | Optional | Background coloring. *Example: for a white background, send:* `"color_background": "#ffffff"`


