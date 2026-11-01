# BARAKA site: setup so Baraka can add and delete his own photos

The public site is plain files. The private page `admin.html` lets only Baraka's Google account add or delete photos and edit his words. Photos and text are stored in Supabase (free tier is enough).

## 1. Supabase project
1. Go to supabase.com, create an account and a **New project** (any name, pick a region close to Nairobi/Europe).
2. Open **SQL Editor -> New query**, paste the whole of `setup.sql`, press **Run**. This creates the tables, the photo storage, the owner-only rules (tied to barakajowi91@gmail.com), and loads the current photos.
3. Open **Project Settings -> API**. Copy the **Project URL** and the **anon public** key into `config.js`. (Never use the `service_role` key anywhere on the site.)

## 2. Google sign-in
1. In Google Cloud Console (console.cloud.google.com): create a project, then **APIs & Services -> OAuth consent screen** (External, add basic app info), then **Credentials -> Create credentials -> OAuth client ID -> Web application**.
2. Under **Authorized redirect URIs** add the one Supabase shows in **Authentication -> Providers -> Google** (it looks like `https://YOURPROJECT.supabase.co/auth/v1/callback`).
3. Paste the Google **Client ID** and **Client secret** into that Supabase Google provider page and switch it on.
4. In Supabase **Authentication -> URL Configuration**, set **Site URL** to your live address (for example `https://baraka.netlify.app`) and add `https://yourdomain/admin.html` under Redirect URLs. For testing on your computer also add `http://localhost:5500/admin.html` (or whatever address you use).

## 3. Lock it down
After Baraka has signed in once, go to **Authentication -> Sign In / Providers** and turn **off "Allow new users to sign up"**. Also leave the Email provider off. This means no one else can ever create an account. (The database rules already only accept his verified Google email, this is a second lock.)

## 4. Deploy
Upload the whole folder (`index.html`, `admin.html`, `config.js`, `images/`, `data/`) to Netlify, Vercel, Cloudflare Pages, or any static host. Baraka then opens `yoursite/admin.html` on his phone and signs in with Google.

### Run with Docker
With Docker Desktop running, start the site from this folder:

```sh
docker compose up --build
```

Open `http://localhost:8081` (admin: `http://localhost:8081/admin.html`). Add `http://localhost:8081/admin.html` to Supabase **Authentication -> URL Configuration -> Redirect URLs** to test Google sign-in locally. Stop the container with `Ctrl+C`.

The container serves the static site; Supabase remains the remote database, photo storage, and authentication service. `.env.local`, `.vercel/`, and setup-only files are excluded from the Docker build context.

## How Baraka uses it
- **Add photos:** choose a series, tap "Choose photos", pick from the phone. They are resized automatically and appear on the site at once.
- **Delete:** tap Delete on a photo, then tap again within 4 seconds to confirm.
- **Make home:** sets the big photo behind the name on the home screen.
- **Words & numbers:** edit the home line, intro text, footer note and the 1,000 / 400 figures.

## Notes
- If `config.js` is left empty the public site simply uses `data/site.json`, and the admin page shows a setup notice.
- The photos that came with the site stay in the `images/` folder. If Baraka deletes one in the admin page it disappears from the site; the file itself is only removed from storage when it was uploaded through the admin page.
- Local testing without Docker: run a static server in this folder (for example `npx serve .` or VS Code Live Server) rather than opening the file by double-click, so sign-in redirects work.
