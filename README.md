A test server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

# Purpose

This server is built for learning purposes. It can be used to implement frontend side JWT Token handling.

The `token` is configured to expire after **1 Minute**, the `refreshToken` expires after **5 Minutes**.

**This is not a production ready implementation and solely serves the purpose of demonstration!**

## Running the server

```
$ dart run bin/server.dart
Server listening on port 8080
```

# Endpoints

## POST /login

Mimics a simple login call.
Since it doesn't really check against a user database, it only requires a username and no password.

### Example Request Body

```json
{
  "username": "My User"
}
```

### Example Response

```json
{
  "token": "anytoken",
  "refreshToken": "anyRefreshToken"
}
```

## POST /refresh

Receives a refresh token and returns a new set of tokens.

### Example Request Body

```json
{
  "token": "myRefreshToken"
}
```

### Example Response

```json
{
  "token": "anytoken",
  "refreshToken": "anyRefreshToken"
}
```

## GET /time

Returns the current time as an ISO 8601 string.
This endpoint requires a valid `Authorization` header to be present.
Otherwise, it returns with status code 401 Unauthorized

```
Authorization: Bearer <token>
```

### Example Response

```json 
{
  "time": "2024-09-26T12:40:53.829946"
}
```
