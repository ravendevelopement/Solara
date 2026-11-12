SOLARA — QUICK START
====================

1. Unzip this folder.
2. Open the SOLARA folder.
3. Open js/config.js.
4. Paste your Supabase publishable key into the supabaseAnonKey value.
   The Supabase Project URL is already filled in.
5. Save the file.
6. Double-click "START SOLARA.bat".
7. Your browser opens SOLARA at http://localhost:5500.

Keep the black PowerShell window open while using the website.
To stop the local website, close that window.

SUPABASE
--------
Project URL:
https://olpcbbvdynaihsckexvv.supabase.co

Key:
Use the Publishable key (starts with sb_publishable_) from Supabase.
Do NOT use the Secret key or service_role key in website code.

In Supabase → Authentication → URL Configuration:
- Set Site URL to: http://localhost:5500
- Add Redirect URL: http://localhost:5500/**

In Supabase → Authentication → Providers, make sure Email is enabled.

ACCOUNT FEATURES
----------------
- Create account with email and password.
- Log in with email and password.
- Persistent sign-in across refreshes and browser sessions.
- Log out.
- Password reset and choose-a-new-password page.

No contact email is required. No database table is required for basic
Supabase email/password authentication.

IMPORTANT
---------
This local launcher uses Windows PowerShell, which is included with Windows.
The launcher starts a local web server because browser login security does
not reliably work when opening the HTML file directly as file://.

When you publish SOLARA online later, upload the whole SOLARA folder to
your hosting provider and add your real website URL to Supabase Redirect URLs.
