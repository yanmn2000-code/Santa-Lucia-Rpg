-- Santa Lucia: autenticação Supabase + armazenamento privado por usuário.
-- Execute este arquivo no SQL Editor do seu projeto Supabase.
create table if not exists public.user_app_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{"characters":[],"campaigns":[],"rolls":[]}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.user_app_state enable row level security;
drop policy if exists "Users can read their own Santa Lucia state" on public.user_app_state;
create policy "Users can read their own Santa Lucia state" on public.user_app_state for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Users can insert their own Santa Lucia state" on public.user_app_state;
create policy "Users can insert their own Santa Lucia state" on public.user_app_state for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users can update their own Santa Lucia state" on public.user_app_state;
create policy "Users can update their own Santa Lucia state" on public.user_app_state for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
grant select, insert, update on public.user_app_state to authenticated;
