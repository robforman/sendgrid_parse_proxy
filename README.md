# SendGrid Parse Proxy

## Overview

This is a simple Rails web-application that receives emails from the SendGrid Parse API,
changes all encodings to UTF-8 based on the envelope source charsets, and then forwards on to
the appropriate endpoint url.

SendGrid is looking for a response code of 200, so the app just blocks and passes back whatever
it receives from the url.

More on SendGrid Parse API:
http://docs.sendgrid.com/documentation/api/parse-api-2/


## Getting Started

1. Setup a new endpoint and point to your existing incoming SendGrid url:

```bash
$ curl -D- -d "endpoint[proxy_url]=http://example.com/sendgrid/incoming" http://localhost:3000/endpoints?auth_token=f1cbc7bd_DEV_ONLY
HTTP/1.1 302 Found 
Location: http://localhost:3000/endpoints/1
.
.
.
$
```

2. Send a test message to the endpoint's email url `/endpoints/:id/emails?auth_token=xxx` and confirm it is proxied.

```bash
$ curl -D- -d 'charsets={"subject":"ascii"}' -d 'subject=hello' http://localhost:3000/endpoints/1/emails?auth_token=f1cbc7bd_DEV_ONLY
HTTP/1.1 200 OK 
.
.
.
$
```

3. Update SendGrid Parse configuration to point at new endpoint emails url from step 2.


## Authentication

You can pass the authentication token via an HTTP header, or via the `auth_token` POST parameter.

Example of HTTP header:
```bash
curl -H "X_AUTH_TOKEN:f1cbc7bd_DEV_ONLY" http://localhost:3000/endpoints
```

Example of POST parameter:
```bash
curl http://localhost:3000/endpoints?auth_token=f1cbc7bd_DEV_ONLY
```

You can set the authentication token required by setting a variable called AUTH_TOKEN in the app's environment.

In Heroku, this would be:
```bash
$ heroku config:add AUTH_TOKEN=some_secure_token
Adding config vars and restarting app... done
  AUTH_TOKEN => some_secure_token
$
```
