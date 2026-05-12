-- 树屋庭院 — Supabase 数据库 schema
-- 在 Supabase SQL Editor 中执行此文件

-- 1. 用户信息表（替代原 couples 集合）
CREATE TABLE profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role        TEXT NOT NULL CHECK (role IN ('rabbit', 'fox')),
  emoji       TEXT NOT NULL,
  name        TEXT NOT NULL,
  partner_id  UUID REFERENCES profiles(id),
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- 2. 信件
CREATE TABLE messages (
  id          BIGSERIAL PRIMARY KEY,
  from_id     UUID REFERENCES profiles(id) NOT NULL,
  to_id       UUID REFERENCES profiles(id) NOT NULL,
  content     TEXT DEFAULT '',
  image_url   TEXT DEFAULT '',
  is_read     BOOLEAN DEFAULT false,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- 3. 黑板留言
CREATE TABLE blackboard (
  id            BIGSERIAL PRIMARY KEY,
  content       TEXT NOT NULL,
  chalk_color   TEXT NOT NULL DEFAULT 'white',
  author_id     UUID REFERENCES profiles(id) NOT NULL,
  author_name   TEXT NOT NULL,
  author_emoji  TEXT NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- 4. 照片墙
CREATE TABLE photos (
  id            BIGSERIAL PRIMARY KEY,
  image_url     TEXT NOT NULL,
  uploader_id   UUID REFERENCES profiles(id) NOT NULL,
  uploader_name TEXT NOT NULL,
  comments      JSONB DEFAULT '[]',
  created_at    TIMESTAMPTZ DEFAULT now()
);

-- 5. 树洞漂流瓶
CREATE TABLE treeholes (
  id          BIGSERIAL PRIMARY KEY,
  content     TEXT NOT NULL,
  from_id     UUID REFERENCES profiles(id) NOT NULL,
  to_id       UUID REFERENCES profiles(id) NOT NULL,
  status      TEXT DEFAULT 'waiting' CHECK (status IN ('waiting', 'read', 'replied')),
  reply       TEXT DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- 6. 纪念日
CREATE TABLE anniversaries (
  id          BIGSERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  date        DATE NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- RLS 策略：认证用户可读写所有表（双人互信）
ALTER TABLE profiles      ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages      ENABLE ROW LEVEL SECURITY;
ALTER TABLE blackboard    ENABLE ROW LEVEL SECURITY;
ALTER TABLE photos        ENABLE ROW LEVEL SECURITY;
ALTER TABLE treeholes     ENABLE ROW LEVEL SECURITY;
ALTER TABLE anniversaries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "auth_all" ON profiles      FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON messages      FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON blackboard    FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON photos        FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON treeholes     FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON anniversaries FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- 建索引
CREATE INDEX idx_messages_to    ON messages(to_id, created_at DESC);
CREATE INDEX idx_messages_from  ON messages(from_id);
CREATE INDEX idx_treeholes_to   ON treeholes(to_id, status);
CREATE INDEX idx_photos_order   ON photos(created_at DESC);
CREATE INDEX idx_blackboard_ts  ON blackboard(created_at ASC);
