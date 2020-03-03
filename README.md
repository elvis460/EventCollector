# Getting Started

* Ruby version: 2.5.4

* Rails version: 6.0.2.1


### Install required ruby gems

bundle the ruby gems

```
$ bundle install
```

may need to install dependencies

```
$ yarn install
```

## The website is working now.

```
$ rails s
```

# Running the tests

```
$ rspec
```

# Events API

## Without any params

### Request ###

`GET /events`

### Headers ###


### Params ###

None

### Response ###

**Code:** `200 (OK)` **Content:** `JSON`

```json
{
  "events": {
    "03.03.2020": [
      {
        "id": 1167,
        "held_at": "2020-03-03T00:00:00.000Z",
        "title": "Fasten your seatbelts. It's going to be a bumpy night.",
        "img_url": "http://mcculloughborer.com/laurie",
        "link": "http://parkerkertzmann.co/reggie.gibson",
        "extract_from": "gorki",
        "created_at": "2020-03-03T14:57:17.278Z",
        "updated_at": "2020-03-03T14:57:17.278Z"
      }
    ],
   "04.03.2020": [
      {
        "id": 1169,
        "held_at": "2020-03-04T00:00:00.000Z",
        "title": "You talking to me?",
        "img_url": "http://feeney.com/vito",
        "link": "http://satterfield.org/brooks.rolfson",
        "extract_from": "berghain",
        "created_at": "2020-03-03T14:57:17.283Z",
        "updated_at": "2020-03-03T14:57:17.283Z"
      }
    ]
  },
  "date_list": ["03.03.2020", "04.03.2020"]
}
```


## Query with date

### Request ###

`GET /events`

### Headers ###


### Params ###

```json
{
  "date_filter": "03.03.2020"
}
```

### Response ###

**Code:** `200 (OK)` **Content:** `JSON`

```json
{
  "events": {
    "03.03.2020": [
      {
        "id": 1167,
        "held_at": "2020-03-03T00:00:00.000Z",
        "title": "Fasten your seatbelts. It's going to be a bumpy night.",
        "img_url": "http://mcculloughborer.com/laurie",
        "link": "http://parkerkertzmann.co/reggie.gibson",
        "extract_from": "gorki",
        "created_at": "2020-03-03T14:57:17.278Z",
        "updated_at": "2020-03-03T14:57:17.278Z"
      }
    ]
  },
  "date_list": ["03.03.2020"]
}
```

## Query with web resource

### Request ###

`GET /events`

### Headers ###


### Params ###

```json
{
  "extract_filter": "gorki"
}
```

### Response ###

**Code:** `200 (OK)` **Content:** `JSON`

```json
{
  "events": {
    "03.03.2020": [
      {
        "id": 1167,
        "held_at": "2020-03-03T00:00:00.000Z",
        "title": "Fasten your seatbelts. It's going to be a bumpy night.",
        "img_url": "http://mcculloughborer.com/laurie",
        "link": "http://parkerkertzmann.co/reggie.gibson",
        "extract_from": "gorki",
        "created_at": "2020-03-03T14:57:17.278Z",
        "updated_at": "2020-03-03T14:57:17.278Z"
      }
    ],
   "04.03.2020": [
      {
        "id": 1169,
        "held_at": "2020-03-04T00:00:00.000Z",
        "title": "You talking to me?",
        "img_url": "http://feeney.com/vito",
        "link": "http://satterfield.org/brooks.rolfson",
        "extract_from": "gorki",
        "created_at": "2020-03-03T14:57:17.283Z",
        "updated_at": "2020-03-03T14:57:17.283Z"
      }
    ]
  },
  "date_list": ["03.03.2020", "04.03.2020"]
}
```

## Query with keyword

### Request ###

`GET /events`

### Headers ###


### Params ###

```json
{
  "query": "talking"
}
```

### Response ###

**Code:** `200 (OK)` **Content:** `JSON`

```json
{
  "events": {
   "04.03.2020": [
      {
        "id": 1169,
        "held_at": "2020-03-04T00:00:00.000Z",
        "title": "You talking to me?",
        "img_url": "http://feeney.com/vito",
        "link": "http://satterfield.org/brooks.rolfson",
        "extract_from": "gorki",
        "created_at": "2020-03-03T14:57:17.283Z",
        "updated_at": "2020-03-03T14:57:17.283Z"
      }
    ]
  },
  "date_list": ["04.03.2020"]
}
```