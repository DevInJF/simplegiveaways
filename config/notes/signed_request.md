# facebook signed_request

* If you have authenticated the app, we get everything.
* If you have liked the page, we get everything except the oauth token.
* If you haven't liked the page and haven't authenticated, we get your like status.

## unauthenticated + has not liked

**Page**

  * ID

**User**

  * Like Status
  * Admin Status
  * Minimum Age (13, 18, or 21)
  * Country
  * Locale

```
{
    "algorithm" => "HMAC-SHA256",
    "issued_at" => 1389509207,
         "page" => {
           "id" => "114471088710683",
        "liked" => false,
        "admin" => false
    },
         "user" => {
        "country" => "us",
         "locale" => "en_US",
            "age" => {
            "min" => 21
        }
    }
}
```
## unauthenticated + has liked

**Page**

  * ID

**User**

  * Like Status
  * Admin Status
  * Minimum Age (13, 18, or 21)
  * Country
  * Locale

```
{
    "algorithm" => "HMAC-SHA256",
    "issued_at" => 1389509951,
         "page" => {
           "id" => "114471088710683",
        "liked" => true,
        "admin" => false
    },
         "user" => {
        "country" => "us",
         "locale" => "en_US",
            "age" => {
            "min" => 21
        }
    }
}
```

## authenticated + has liked

**Page**

  * ID

**User**

  * ID
  * OAuth Token
    * Issue Time
    * Expiration Time
    * Algorithm
  * Like Status
  * Admin Status
  * Minimum Age (13, 18, or 21)
  * Country
  * Locale

```
{
      "algorithm" => "HMAC-SHA256",
        "expires" => 1389517200,
      "issued_at" => 1389510091,
    "oauth_token" => "CAAGI0bcFu0UBAI4dK6AbzhWW0AgImf4qZBHJZA1DDS93OVCZCloLRjQLdsG3Ko12xIoqZA5CBeZAFR4jMTMsXt8tCMYmEqk0l8hRIQbF8vohTIJZAwQdAilmVsl3LOPcrWAANrc9hStLfpa9yFHQcz90CIq7ZBoc2ttvoTGtzZApZAhARfEuq5nuXfsPdAYqROYz0utVpzaKc3AZDZD",
           "page" => {
           "id" => "114471088710683",
        "liked" => true,
        "admin" => true
    },
           "user" => {
        "country" => "us",
         "locale" => "en_US",
            "age" => {
            "min" => 21
        }
    },
        "user_id" => "100001756977871"
}
```

## authenticated + has not liked

**Page**

  * ID

**User**

  * ID
  * OAuth Token
    * Issue Time
    * Expiration Time
    * Algorithm
  * Like Status
  * Admin Status
  * Minimum Age (13, 18, or 21)
  * Country
  * Locale

```
{
      "algorithm" => "HMAC-SHA256",
        "expires" => 1389517200,
      "issued_at" => 1389510249,
    "oauth_token" => "CAAGI0bcFu0UBABdnhotkBU4dXoc3bLcZCBZBPtDZCUBqYswzZA3AspIoejMfpn2IZCZBoEf1foVtZBqgykukAfUDUbkmir6iZAKYCsUh3mIkxzEfiL24RPZBZCfageIhErfVPIkRLqo8Y4HFFSSD3VUqmO7GQ6E6B0zkafaImF3kJ6ZBqWdklN9KLOErBX7Bhmj3uqTSGA6Ruu5bgZDZD",
           "page" => {
           "id" => "114471088710683",
        "liked" => false,
        "admin" => true
    },
           "user" => {
        "country" => "us",
         "locale" => "en_US",
            "age" => {
            "min" => 21
        }
    },
        "user_id" => "100001756977871"
}
```
