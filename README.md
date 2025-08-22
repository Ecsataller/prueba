# TallerPRO – Workshop & Maintenance System (MVP)

Stack: **Next.js 14 + TypeScript + Tailwind + supabase-js v2**

## Setup
1. En Supabase ejecuta los SQL en `db/supabase_schema_v2.sql` y `db/supabase_schema_v2_plus_fabricacion_flotas.sql`.
2. Copia `.env.example` a `.env.local` y completa:
```
NEXT_PUBLIC_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR-ANON-KEY
```
3. Instala y corre:
```
npm install
npm run dev
```
4. Despliegue en Netlify: ve `README-NETLIFY.md`.
