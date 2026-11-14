-- MIZVO database record (Supabase Postgres)
-- Purpose: a copy of the SQL that was run in the Supabase SQL Editor, in order, so the database can be rebuilt.
-- NOTE: Do NOT run this on the live database again; it is a record. The base table public.profiles
-- (id, display_name, avatar_url, created_at; read-for-signed-in and update-own policies) and the signup trigger
-- on_auth_user_created existed before these scripts and are not recreated here.
-- Last updated: 2026-11-13

-- ============================================================
-- 1. profiles: username, status, updated_at (run 2026-11-07)
-- ============================================================
alter table public.profiles
  add column if not exists username text,
  add column if not exists status text,
  add column if not exists updated_at timestamptz not null default now();

alter table public.profiles
  add constraint profiles_username_format
    check (username is null or username ~ '^[a-z0-9_]{3,20}$'),
  add constraint profiles_display_name_length
    check (display_name is null or char_length(display_name) <= 50),
  add constraint profiles_status_length
    check (status is null or char_length(status) <= 140);

create unique index if not exists profiles_username_key on public.profiles (username);

revoke all on public.profiles from anon;
revoke delete on public.profiles from authenticated;

create or replace function public.mizvo_set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.mizvo_set_updated_at();

-- ============================================================
-- 2. Signup trigger: cut the display name to 50 characters (run 2026-11-07)
-- ============================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path to ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    left(coalesce(new.raw_user_meta_data ->> 'display_name', ''), 50)
  );
  return new;
end;
$$;

-- ============================================================
-- 3. Reserved usernames (run 2026-11-08)
-- ============================================================
create or replace function public.mizvo_block_reserved_username()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.username is not null
     and current_user not in ('postgres', 'supabase_admin', 'service_role')
     and (lower(new.username) like 'mizvo%'
          or lower(new.username) = any (array[
            'admin','administrator','root','support','help','security','official',
            'staff','team','moderator','system','info','contact','noreply','owner',
            'founder','ceo','abuse','privacy','terms','api','www','about','settings',
            'login','signup'])) then
    raise exception 'That username is reserved' using errcode = '23514';
  end if;
  return new;
end;
$$;

create trigger profiles_block_reserved_username
  before insert or update of username on public.profiles
  for each row execute function public.mizvo_block_reserved_username();

-- ============================================================
-- 4. Messaging: tables, security rules, functions, realtime (run 2026-11-09)
-- ============================================================
create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  pair_key text not null unique,
  created_at timestamptz not null default now()
);

create table public.conversation_members (
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  joined_at timestamptz not null default now(),
  last_read_at timestamptz not null default now(),
  primary key (conversation_id, user_id)
);
create index conversation_members_user_idx on public.conversation_members (user_id);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  sender_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now(),
  constraint messages_body_length check (char_length(btrim(body)) between 1 and 2000)
);
create index messages_conversation_created_idx
  on public.messages (conversation_id, created_at desc);

create table public.blocks (
  blocker_id uuid not null references auth.users (id) on delete cascade,
  blocked_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  constraint blocks_not_self check (blocker_id <> blocked_id)
);

create or replace function public.mizvo_is_member(conv uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.conversation_members
    where conversation_id = conv and user_id = (select auth.uid())
  );
$$;

create or replace function public.mizvo_can_send(conv uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.mizvo_is_member(conv)
    and not exists (
      select 1
      from public.conversation_members m
      join public.blocks b
        on (b.blocker_id = (select auth.uid()) and b.blocked_id = m.user_id)
        or (b.blocker_id = m.user_id and b.blocked_id = (select auth.uid()))
      where m.conversation_id = conv and m.user_id <> (select auth.uid())
    );
$$;

revoke all on function public.mizvo_is_member(uuid) from public, anon;
revoke all on function public.mizvo_can_send(uuid) from public, anon;
grant execute on function public.mizvo_is_member(uuid) to authenticated;
grant execute on function public.mizvo_can_send(uuid) to authenticated;

alter table public.conversations enable row level security;
alter table public.conversation_members enable row level security;
alter table public.messages enable row level security;
alter table public.blocks enable row level security;

create policy "Members can read their conversations"
  on public.conversations for select to authenticated
  using (public.mizvo_is_member(id));

create policy "Members can read members of their conversations"
  on public.conversation_members for select to authenticated
  using (public.mizvo_is_member(conversation_id));

create policy "Members can update their own read time"
  on public.conversation_members for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "Members can read messages"
  on public.messages for select to authenticated
  using (public.mizvo_is_member(conversation_id));

create policy "Members can send messages"
  on public.messages for insert to authenticated
  with check (sender_id = (select auth.uid()) and public.mizvo_can_send(conversation_id));

create policy "People can read their own blocks"
  on public.blocks for select to authenticated
  using (blocker_id = (select auth.uid()));

create policy "People can block"
  on public.blocks for insert to authenticated
  with check (blocker_id = (select auth.uid()));

create policy "People can unblock"
  on public.blocks for delete to authenticated
  using (blocker_id = (select auth.uid()));

revoke all on public.conversations, public.conversation_members, public.messages, public.blocks from anon;
revoke all on public.conversations, public.conversation_members, public.messages, public.blocks from authenticated;
grant select on public.conversations to authenticated;
grant select on public.conversation_members to authenticated;
grant update (last_read_at) on public.conversation_members to authenticated;
grant select, insert on public.messages to authenticated;
grant select, insert, delete on public.blocks to authenticated;

create or replace function public.start_direct_chat(other uuid)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  me uuid := (select auth.uid());
  pair text;
  conv uuid;
begin
  if me is null then
    raise exception 'Not signed in' using errcode = '28000';
  end if;
  if other is null or other = me then
    raise exception 'Invalid person' using errcode = '22023';
  end if;
  if not exists (select 1 from public.profiles where id = other) then
    raise exception 'Person not found' using errcode = '22023';
  end if;
  if exists (
    select 1 from public.blocks
    where (blocker_id = me and blocked_id = other)
       or (blocker_id = other and blocked_id = me)
  ) then
    raise exception 'Cannot start this chat' using errcode = '42501';
  end if;

  pair := least(me::text, other::text) || ':' || greatest(me::text, other::text);
  select id into conv from public.conversations where pair_key = pair;
  if conv is null then
    insert into public.conversations (pair_key) values (pair)
      on conflict (pair_key) do nothing
      returning id into conv;
    if conv is null then
      select id into conv from public.conversations where pair_key = pair;
    else
      insert into public.conversation_members (conversation_id, user_id)
        values (conv, me), (conv, other);
    end if;
  end if;
  return conv;
end;
$$;

revoke all on function public.start_direct_chat(uuid) from public, anon;
grant execute on function public.start_direct_chat(uuid) to authenticated;

create or replace function public.my_chats()
returns table (
  conversation_id uuid,
  other_user_id uuid,
  other_name text,
  other_username text,
  last_body text,
  last_at timestamptz,
  last_sender uuid,
  unread_count bigint,
  i_blocked boolean
)
language sql
stable
security invoker
set search_path = ''
as $$
  select
    c.id,
    o.user_id,
    p.display_name,
    p.username,
    lm.body,
    lm.created_at,
    lm.sender_id,
    (select count(*) from public.messages m
       where m.conversation_id = c.id
         and m.sender_id <> (select auth.uid())
         and m.created_at > mine.last_read_at),
    exists (select 1 from public.blocks b
              where b.blocker_id = (select auth.uid()) and b.blocked_id = o.user_id)
  from public.conversations c
  join public.conversation_members mine
    on mine.conversation_id = c.id and mine.user_id = (select auth.uid())
  join public.conversation_members o
    on o.conversation_id = c.id and o.user_id <> (select auth.uid())
  join public.profiles p on p.id = o.user_id
  left join lateral (
    select m2.body, m2.created_at, m2.sender_id
    from public.messages m2
    where m2.conversation_id = c.id
    order by m2.created_at desc
    limit 1
  ) lm on true
  order by coalesce(lm.created_at, c.created_at) desc;
$$;

revoke all on function public.my_chats() from public, anon;
grant execute on function public.my_chats() to authenticated;

do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    alter publication supabase_realtime add table public.messages;
  else
    raise notice 'Publication supabase_realtime was not found';
  end if;
end $$;

-- ============================================================
-- 5. Messaging fixes after review (run 2026-11-09)
--    Clients can no longer set created_at; "read" time uses the server clock.
-- ============================================================
revoke insert on public.messages from authenticated;
grant insert (conversation_id, sender_id, body) on public.messages to authenticated;

revoke insert on public.blocks from authenticated;
grant insert (blocker_id, blocked_id) on public.blocks to authenticated;

create or replace function public.mark_chat_read(conv uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  update public.conversation_members
  set last_read_at = now()
  where conversation_id = conv and user_id = (select auth.uid());
$$;

revoke all on function public.mark_chat_read(uuid) from public, anon;
grant execute on function public.mark_chat_read(uuid) to authenticated;


-- ============================================================
-- 6. Rate limits on messages and new chats (run 2026-11-13; rolled-back test passed:
--    burst blocked after 10 messages, new-chat limit blocked)
--    Limits: 10 messages per 10 seconds and 600 per hour per sender; 20 new chats per hour per person.
-- ============================================================
alter table public.conversations
  add column if not exists created_by uuid references auth.users (id) on delete set null;

create index if not exists messages_sender_created_idx
  on public.messages (sender_id, created_at desc);
create index if not exists conversations_creator_created_idx
  on public.conversations (created_by, created_at desc);

create or replace function public.mizvo_limit_messages()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  burst int;
  hourly int;
begin
  select count(*) into burst from public.messages
    where sender_id = new.sender_id and created_at > now() - interval '10 seconds';
  if burst >= 10 then
    raise exception 'Too many messages' using errcode = '54000';
  end if;
  select count(*) into hourly from public.messages
    where sender_id = new.sender_id and created_at > now() - interval '1 hour';
  if hourly >= 600 then
    raise exception 'Too many messages' using errcode = '54000';
  end if;
  return new;
end;
$$;

create trigger messages_limit_rate
  before insert on public.messages
  for each row execute function public.mizvo_limit_messages();

create or replace function public.start_direct_chat(other uuid)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  me uuid := (select auth.uid());
  pair text;
  conv uuid;
begin
  if me is null then
    raise exception 'Not signed in' using errcode = '28000';
  end if;
  if other is null or other = me then
    raise exception 'Invalid person' using errcode = '22023';
  end if;
  if not exists (select 1 from public.profiles where id = other) then
    raise exception 'Person not found' using errcode = '22023';
  end if;
  if exists (
    select 1 from public.blocks
    where (blocker_id = me and blocked_id = other)
       or (blocker_id = other and blocked_id = me)
  ) then
    raise exception 'Cannot start this chat' using errcode = '42501';
  end if;

  pair := least(me::text, other::text) || ':' || greatest(me::text, other::text);
  select id into conv from public.conversations where pair_key = pair;
  if conv is null then
    if (select count(*) from public.conversations
          where created_by = me and created_at > now() - interval '1 hour') >= 20 then
      raise exception 'Too many new chats' using errcode = '54000';
    end if;
    insert into public.conversations (pair_key, created_by) values (pair, me)
      on conflict (pair_key) do nothing
      returning id into conv;
    if conv is null then
      select id into conv from public.conversations where pair_key = pair;
    else
      insert into public.conversation_members (conversation_id, user_id)
        values (conv, me), (conv, other);
    end if;
  end if;
  return conv;
end;
$$;
