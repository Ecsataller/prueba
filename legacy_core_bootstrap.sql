-- legacy_core_bootstrap.sql
-- Crea las tablas "legado" que tu app original usa (para que luego puedas ejecutar los scripts v2).
-- Ejecuta esto SOLO si en tu proyecto NO existen estas tablas.
-- Requiere la extensión pgcrypto para gen_random_uuid()

create extension if not exists pgcrypto;

-- ===== 1) Catálogos base =====
create table if not exists public.users (
  id uuid not null default gen_random_uuid(),
  username text not null default '',
  password text default '',
  role text,
  constraint users_pkey primary key (id)
);

create table if not exists public.departamentos (
  nombre text not null,
  descripcion text,
  id uuid not null default gen_random_uuid(),
  constraint departamentos_pkey primary key (id)
);

create table if not exists public.solicitantes (
  id uuid not null default gen_random_uuid(),
  nombre text not null,
  contacto text,
  constraint solicitantes_pkey primary key (id)
);

create table if not exists public.tipos_mantenimiento (
  nombre text not null,
  costoHora numeric,
  id uuid not null default gen_random_uuid(),
  constraint tipos_mantenimiento_pkey primary key (id)
);

create table if not exists public.mano_obra (
  id uuid not null default gen_random_uuid(),
  nombre text not null,
  costo_hora numeric,
  unidad text,
  constraint mano_obra_pkey primary key (id)
);

create table if not exists public.maquinaria (
  id uuid not null default gen_random_uuid(),
  nombre text not null,
  costo_hora numeric,
  constraint maquinaria_pkey primary key (id)
);

create table if not exists public.materiales (
  id uuid not null default gen_random_uuid(),
  nombre text not null,
  unidad text,
  costo_unitario numeric,
  constraint materiales_pkey primary key (id)
);

create table if not exists public.tecnicos (
  nombre text not null,
  id uuid not null default gen_random_uuid(),
  especialidad text,
  constraint tecnicos_pkey primary key (id)
);

create table if not exists public."Repuestos" (
  id uuid not null default gen_random_uuid(),
  repuestos text,
  descripcion text,
  equipo text,
  tipoEquipo text,
  sistema text,
  codigoInterno text,
  ubicacion text,
  imagenURL text,
  activo boolean,
  constraint "Repuestos_pkey" primary key (id)
);

-- ===== 2) Nucleares =====
create table if not exists public.actividades (
  id uuid not null default gen_random_uuid(),
  nombre text not null,
  departamentoId uuid default gen_random_uuid(),
  solicitanteId uuid default gen_random_uuid(),
  tipoId uuid default gen_random_uuid(),
  coordinadorId uuid default gen_random_uuid(),
  fechaSolicitud date,
  fechaInicio date,
  fechaFin date,
  prioridad text not null,
  estado text,
  progreso smallint,
  fechaEntrega date,
  tecnicoId uuid default gen_random_uuid(),
  comentarios text,
  vistoporcoordinador boolean default false,
  constraint actividades_pkey primary key (id),
  constraint actividades_tipoId_fkey foreign key (tipoId) references public.tipos_mantenimiento(id),
  constraint actividades_solicitanteId_fkey foreign key (solicitanteId) references public.solicitantes(id),
  constraint actividades_coordinadorId_fkey foreign key (coordinadorId) references public.users(id),
  constraint actividades_departamentoId_fkey foreign key (departamentoId) references public.departamentos(id)
);

create table if not exists public.actividad_recursos (
  actividadid uuid default gen_random_uuid(),
  tipo text check (tipo = any (array['materiales','mano_obra','maquinaria'])),
  recursoid uuid default gen_random_uuid(),
  cantidad numeric,
  costounitario numeric,
  id uuid not null default gen_random_uuid(),
  personas integer,
  constraint actividad_recursos_pkey primary key (id),
  constraint actividad_recursos_actividadid_fkey foreign key (actividadid) references public.actividades(id)
);

create table if not exists public.actividad_repuestos (
  id bigint generated always as identity not null,
  actividadid uuid not null default gen_random_uuid(),
  repuestoid uuid default gen_random_uuid(),
  cantidad numeric,
  fechaAsignaci timestamp without time zone,
  comentario text,
  constraint actividad_repuestos_pkey primary key (id),
  constraint actividad_repuestos_repuestoid_fkey foreign key (repuestoid) references public."Repuestos"(id),
  constraint actividad_repuestos_actividadid_fkey foreign key (actividadid) references public.actividades(id)
);

create table if not exists public.presupuestos (
  id uuid not null default gen_random_uuid(),
  actividadid uuid not null default gen_random_uuid() unique,
  totalcosto numeric not null check (totalcosto >= 0),
  fecha date not null default current_date,
  constraint presupuestos_pkey primary key (id),
  constraint presupuestos_actividadid_fkey foreign key (actividadid) references public.actividades(id)
);

-- ===== 3) Índices sugeridos =====
create index if not exists idx_actividades_departamento on public.actividades(departamentoId);
create index if not exists idx_actividades_estado on public.actividades(estado);
create index if not exists idx_ar_actividad on public.actividad_recursos(actividadid);
create index if not exists idx_arep_actividad on public.actividad_repuestos(actividadid);
