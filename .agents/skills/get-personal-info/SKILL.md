---
name: get-personal-info
description: Get Kerrick (the user)'s personal information
---
You can get personal information about Kerrick by following these instructions:

To get info from Google contacts (email, phone, date of birth, etc), run
```
gws people people get --params '{"resourceName": "people/me", "personFields": "names,emailAddresses,phoneNumbers,addresses,birthdays"}'
```
Use the email and phone labeled as "Preferred" unless explicitly told otherwise.

To get misc personal info from Google Docs, run:
```
tmp=$(mktemp)
gws drive files export --params '{"fileId": "1p7ucPWNGJ7O0G064UeSbkDuhbwIdoCm-x6IJAF9wLXE", "mimeType": "text/markdown"}' -o "$tmp"
cat "$tmp"
rm "$tmp"
```
This doc links to other docs that you may also want to read depending on what data you need.

To get professional history, fetch [Kerrick's resume](https://kerrickstaley.com/Kerrick%20Staley%20-%20Resume.pdf). You can also try [Kerrick's LinkedIn page](https://www.linkedin.com/in/kerrick-staley/) but it might be blocked.
