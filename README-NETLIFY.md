# Deploy TallerPRO on Netlify via GitHub

1) Sube este proyecto a **GitHub** (rama `main`).
2) En **Netlify**: Add new site → Import from GitHub → selecciona el repo.
   - Build command: `npm run build`
   - Publish directory: `.next`
3) Variables (Site → Settings → Environment):
   - `NEXT_PUBLIC_SUPABASE_URL` = https://<TU-PROYECTO>.supabase.co
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = <ANON KEY>
4) Cada commit a `main` dispara un **Production deploy**. PRs crean **Deploy Previews**.
