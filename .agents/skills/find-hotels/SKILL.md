---
name: find-hotels
description: Find hotels and Airbnb listings for a trip and compare confirmed-available options in a Google Sheet.
---

# Find hotels

When asked to find a hotel for a trip, search for every hotel and Airbnb listing in the specified area. Only include options confirmed available for the requested dates. If search coverage is incomplete, disclose the gaps rather than claiming the results are exhaustive.

Create a Google Sheet with one row per place to stay and these columns:

- Place name, linked directly to the hotel's Google Maps entry or the Airbnb listing; no separate link column.
- Cost per night in USD for the requested dates, including mandatory taxes and fees. Calculate it as the total stay cost divided by the number of nights, converting to USD using a current exchange rate when necessary. Record the exchange-rate source and date in a cell note.
- Overall guest rating on a 1–5 scale.
- Total review count: sum the Booking.com and Google Maps review counts for hotels; use the listing's review count for Airbnb.
- Google Maps guest rating (hotels only; hidden column).
- Booking.com guest rating in its original scale (hotels only; hidden column).

For Airbnb, use the listing's guest rating directly. For hotels, obtain both Google Maps and Booking.com guest ratings, divide Booking.com's 10-point rating by 2, and average it with the Google Maps rating:

`overall_rating = (google_maps_rating + booking_com_rating / 2) / 2`

Use a spreadsheet formula for the hotel overall rating. If only Google Maps is available, use its rating directly. If only Booking.com is available, use its rating divided by 2 (for example, 9 becomes 4.5). Leave the overall rating blank only when neither source rating is available. Keep missing source ratings blank; do not treat them as zero.

Sort rows by overall guest rating descending, with missing ratings last.

Keep the sheet as plain, editable cells without table outlines or outlined filter ranges.
