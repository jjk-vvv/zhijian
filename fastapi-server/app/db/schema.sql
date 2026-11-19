-- 「纸间」数据库结构
-- 所有时间使用 timestamptz，主键使用 uuid（users 及用户生成内容）或自增（书目）。

create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  email text not null,
  password_hash text not null,
  handle text not null unique,
  display_name text not null,
  bio text not null default '',
  avatar_color text not null default '#294b3c',
  location text not null default '',
  website text not null default '',
  is_private boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint users_handle_format check (handle ~ '^[a-z0-9_]{3,24}$')
);
create unique index if not exists users_email_lower_idx on users (lower(email));

create table if not exists books (
  id serial primary key,
  slug text not null unique,
  title text not null,
  english text not null default '',
  author text not null,
  category text not null,
  pages integer not null default 0,
  published_year integer,
  color text not null default '#3e5b48',
  ink text not null default '#eee8d5',
  art text not null default 'lake',
  subtitle text not null default '',
  tag text not null default '',
  description text not null default '',
  recommendation text not null default '',
  rating_avg numeric(3, 2) not null default 0,
  rating_count integer not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists books_category_idx on books (category);
create index if not exists books_title_idx on books (title);

create table if not exists book_tags (
  id serial primary key,
  book_id integer not null references books (id) on delete cascade,
  kind text not null check (kind in ('mood', 'pace', 'topic', 'warning')),
  name text not null,
  unique (book_id, kind, name)
);

create table if not exists user_books (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  book_id integer not null references books (id) on delete cascade,
  status text not null default 'wishlist' check (status in ('wishlist', 'reading', 'finished', 'dnf')),
  progress integer not null default 0 check (progress between 0 and 100),
  started_at timestamptz,
  finished_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, book_id)
);
create index if not exists user_books_user_status_idx on user_books (user_id, status);

create table if not exists notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  book_id integer not null references books (id) on delete cascade,
  title text not null,
  content text not null,
  type text not null default 'thought' check (type in ('thought', 'excerpt', 'review')),
  page integer,
  is_private boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists notes_user_created_idx on notes (user_id, created_at desc);

create table if not exists highlights (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  book_id integer not null references books (id) on delete cascade,
  quote text not null,
  page integer,
  note text not null default '',
  is_private boolean not null default true,
  created_at timestamptz not null default now()
);
create index if not exists highlights_user_created_idx on highlights (user_id, created_at desc);

create table if not exists reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  book_id integer not null references books (id) on delete cascade,
  rating numeric(2, 1) not null check (rating between 0.5 and 5),
  title text not null default '',
  content text not null default '',
  contains_spoilers boolean not null default false,
  likes_count integer not null default 0,
  comments_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, book_id)
);
create index if not exists reviews_book_created_idx on reviews (book_id, created_at desc);

create table if not exists review_likes (
  review_id uuid not null references reviews (id) on delete cascade,
  user_id uuid not null references users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (review_id, user_id)
);

create table if not exists comments (
  id uuid primary key default gen_random_uuid(),
  review_id uuid not null references reviews (id) on delete cascade,
  user_id uuid not null references users (id) on delete cascade,
  content text not null,
  created_at timestamptz not null default now()
);
create index if not exists comments_review_created_idx on comments (review_id, created_at);

create table if not exists reading_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  book_id integer not null references books (id) on delete cascade,
  minutes integer not null check (minutes between 1 and 1440),
  pages integer not null default 0 check (pages >= 0),
  session_date date not null default current_date,
  note text not null default '',
  created_at timestamptz not null default now()
);
create index if not exists reading_sessions_user_date_idx on reading_sessions (user_id, session_date desc);

create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  year integer not null,
  target_books integer not null default 24 check (target_books between 1 and 999),
  target_minutes integer not null default 7200 check (target_minutes between 60 and 1000000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, year)
);

create table if not exists lists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  title text not null,
  description text not null default '',
  is_public boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists lists_user_created_idx on lists (user_id, created_at desc);

create table if not exists list_items (
  id serial primary key,
  list_id uuid not null references lists (id) on delete cascade,
  book_id integer not null references books (id) on delete cascade,
  note text not null default '',
  position integer not null default 0,
  added_at timestamptz not null default now(),
  unique (list_id, book_id)
);

create table if not exists follows (
  follower_id uuid not null references users (id) on delete cascade,
  following_id uuid not null references users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (follower_id, following_id),
  constraint follows_not_self check (follower_id <> following_id)
);

create table if not exists activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  type text not null check (
    type in ('shelf_add', 'finished', 'review', 'note', 'highlight', 'list_create', 'club_join', 'goal')
  ),
  book_id integer references books (id) on delete set null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
create index if not exists activities_user_created_idx on activities (user_id, created_at desc);
create index if not exists activities_created_idx on activities (created_at desc);

create table if not exists clubs (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text not null default '',
  book_id integer references books (id) on delete set null,
  is_private boolean not null default false,
  owner_id uuid not null references users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists club_members (
  club_id uuid not null references clubs (id) on delete cascade,
  user_id uuid not null references users (id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'member')),
  joined_at timestamptz not null default now(),
  primary key (club_id, user_id)
);

create table if not exists club_posts (
  id uuid primary key default gen_random_uuid(),
  club_id uuid not null references clubs (id) on delete cascade,
  user_id uuid not null references users (id) on delete cascade,
  content text not null,
  page integer,
  created_at timestamptz not null default now()
);
create index if not exists club_posts_club_created_idx on club_posts (club_id, created_at desc);

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users (id) on delete cascade,
  type text not null check (type in ('follow', 'like', 'comment', 'club_post', 'system')),
  actor_id uuid references users (id) on delete set null,
  payload jsonb not null default '{}'::jsonb,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists notifications_user_created_idx on notifications (user_id, created_at desc);

-- ---------- 触发器 ----------

create or replace function set_updated_at() returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists users_updated_at on users;
create trigger users_updated_at before update on users
for each row execute function set_updated_at();

drop trigger if exists user_books_updated_at on user_books;
create trigger user_books_updated_at before update on user_books
for each row execute function set_updated_at();

drop trigger if exists notes_updated_at on notes;
create trigger notes_updated_at before update on notes
for each row execute function set_updated_at();

drop trigger if exists reviews_updated_at on reviews;
create trigger reviews_updated_at before update on reviews
for each row execute function set_updated_at();

drop trigger if exists goals_updated_at on goals;
create trigger goals_updated_at before update on goals
for each row execute function set_updated_at();

drop trigger if exists lists_updated_at on lists;
create trigger lists_updated_at before update on lists
for each row execute function set_updated_at();

-- 书评变化后回写书目评分聚合
create or replace function refresh_book_rating() returns trigger as $$
declare
  target_book integer;
begin
  target_book := coalesce(new.book_id, old.book_id);
  update books b
     set rating_avg = coalesce((
           select round(avg(r.rating)::numeric, 2) from reviews r where r.book_id = target_book
         ), 0),
         rating_count = (select count(*) from reviews r where r.book_id = target_book)
   where b.id = target_book;
  return null;
end;
$$ language plpgsql;

drop trigger if exists reviews_rating_aggregate on reviews;
create trigger reviews_rating_aggregate
after insert or update of rating, book_id or delete on reviews
for each row execute function refresh_book_rating();
