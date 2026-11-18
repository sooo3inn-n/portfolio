-- 포트폴리오 방명록 테이블
-- Supabase 대시보드 > SQL Editor 에 붙여넣고 Run 하세요.

create table if not exists public.guestbook (
  id          bigint generated always as identity primary key,
  name        text not null check (char_length(btrim(name)) between 1 and 20),
  message     text not null check (char_length(btrim(message)) between 1 and 300),
  created_at  timestamptz not null default now()
);

-- 행 단위 보안: 방문자는 읽기와 새 글 쓰기만 가능 (수정·삭제 불가)
alter table public.guestbook enable row level security;

drop policy if exists "guestbook_read" on public.guestbook;
create policy "guestbook_read" on public.guestbook
  for select to anon, authenticated using (true);

drop policy if exists "guestbook_insert" on public.guestbook;
create policy "guestbook_insert" on public.guestbook
  for insert to anon, authenticated with check (true);

-- 방문자가 id·created_at 을 임의로 넣지 못하게 쓰기 권한을 두 컬럼으로 제한
revoke insert, update, delete on public.guestbook from anon, authenticated;
grant select on public.guestbook to anon, authenticated;
grant insert (name, message) on public.guestbook to anon, authenticated;

-- 글 삭제는 대시보드 > Table Editor 에서 직접 하세요.
