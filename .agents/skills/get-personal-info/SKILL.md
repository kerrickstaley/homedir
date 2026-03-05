---
name: get-personal-info
description: Get Kerrick (the user)'s personal information
---
You can get personal information about Kerrick by running these commands:

Get info from Google contacts (email, phone, date of birth, etc):
```
gws people people get --params '{"resourceName": "people/me", "personFields": "names,emailAddresses,phoneNumbers,addresses,birthdays"}'
```

Get misc personal info from Google Docs:
```
tmp=$(mktemp)
gws drive files export --params '{"fileId": "1p7ucPWNGJ7O0G064UeSbkDuhbwIdoCm-x6IJAF9wLXE", "mimeType": "text/markdown"}' -o "$tmp"
cat "$tmp"
rm "$tmp"
```
This doc links to other docs that you may also want to read depending on what data you need.
