# Caching
I set NGNIX to do the caching for the application this can be seen in the nginx.conf file in the Cloud Hosting directory (https://github.com/aldent95/Nwen304-Team12/blob/master/docs/Cloud%20Hosting/nginx.conf). The server sets all the assets to all be cached except(html,css and js etc) the images as the are set as URL resources so caching was not possible.

I tested this by using curl with -I which grabs the headers.
```
$ curl -I https://nwen304group12.zsys.eu
HTTP/1.1 200 OK
Cache-Control: max-age=max, private, must-revalidate
Content-Type: text/html; charset=utf-8
Date: Sun, 26 Jun 2016 11:38:47 GMT
ETag: W/"41508b045fe8d58d1e7311b4a7ae1742"
Server: nginx/1.10.0 + Phusion Passenger 5.0.28
Set-Cookie: request_method=HEAD; path=/
Set-Cookie: _Nwen304-Team12_session=Qy9VcTBpWXFKcjdRVDJSTkJycXpyMFJ1YTIzaFZjcEM4N0V3VFUzR0E4OEZwaXZEQW96eS9NdGo5OHJNQllvTEpDMUZuV2Y3UGNLMjROWk5PT3Y4ekdPeUljZHc0akpjY1lCekg5eWdFYjRZaE9HVjNqNW1welZaSFVrZW9LLzgrVC9wUTJldlRKZGVJemJDR1ZsZ0RBPT0tLVJGM2RZL0dOMWpXYWZxUHFBTGlzY0E9PQ%3D%3D--ec431e8ce864387a49b2890cd03468c3a4d75ec9; path=/; expires=Sun, 26 Jun 2016 12:08:47 -0000; HttpOnly
Status: 200 OK
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Powered-By: Phusion Passenger 5.0.28
X-Request-Id: 67f11128-257b-414f-9670-b0f36a2f6d67
X-Runtime: 0.003513
X-XSS-Protection: 1; mode=block
Connection: keep-alive
```
