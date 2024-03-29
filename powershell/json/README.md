# Expand-JsonFile
This small script is able to resolve cross property reference.

### Example
Into the data folder there are three json files:

- [customers.json](data/customers.json) contains a set of customers
- [products.json](data/products.json) contains a set of products
- [orders](data/orders.json) contains a set of orders


The *orders.json* has some properties (product and customer) needs to be calculated by evaluate a reference expression:

```json
// orders.json
[
    {
        "created":"2022-10-15T09:00:00",
        "product":"[data/products(pid=1).title]",
        "quantity":1,
        "customer":"[data/customers(cid=3).name]",
        "notes":"this is a note"
    },
    {
        "created":"2022-10-15T10:00:00",
        "product":"[data/products(pid=2).title]",
        "quantity":2,
        "customer":"[data/customers(cid=3).name]",
        "notes":"this is a note2"
    }
]
```

The function **Expand-JsonFile** evaluates the reference expressions into orders.json file and produce a new file:

```powershell
import-module -name .\ADMjson.psm1 -Force

Expand-JsonFile -SourceFile data/orders.json -TargetFile data/orders_expanded.json
```

The result json file contains property values:

```json
// orders_expanded.json
[
    {
        "created": "2022-10-15T09:00:00",
        "product": "xbox",
        "quantity": 1,
        "customer": "Paperino",
        "notes": "this is a note"
    },
    {
        "created": "2022-10-15T10:00:00",
        "product": "playstation",
        "quantity": 2,
        "customer": "Paperino",
        "notes": "this is a note2"
    }
]
```