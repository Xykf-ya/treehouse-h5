# 树屋庭院 — H5 网页部署指南

两个人的秘密空间。🐰 🦊

## 第一步：Supabase 建项目

1. 打开 [supabase.com](https://supabase.com)，注册/登录
2. 点「New project」，填好名字，设一个你能记住的 Database Password
3. 等项目创建完成（约 2 分钟）

## 第二步：建数据库表

1. 左侧菜单 → SQL Editor
2. 点「New query」
3. 把 `supabase/schema.sql` 里的内容全部粘贴进去
4. 点右下角「Run」执行

## 第三步：关掉邮箱确认

1. 左侧菜单 → Authentication → Settings
2. 把「Confirm email」关掉（取消勾选）
3. 往下翻到「Enable email confirmations」，确保是关的
4. 点页面底部的「Save」

## 第四步：创建两个用户

1. 左侧菜单 → Authentication → Users
2. 点「Add user」→「Create new user」
3. Email 填 `bunny@treehouse.local`，Password 小兔子自己设
4. 点「Create user」
5. 同样再创建一个：Email 填 `fox@treehouse.local`，Password 小狐狸自己设

## 第五步：绑定两人关系

1. 左侧菜单 → SQL Editor → New query
2. 复制下面的 SQL，替换尖括号里的 UUID：

```sql
INSERT INTO profiles (id, role, emoji, name, partner_id)
VALUES
  ('<小兔子UUID>', 'rabbit', '🐰', '小兔子', '<小狐狸UUID>'),
  ('<小狐狸UUID>', 'fox', '🦊', '小狐狸', '<小兔子UUID>');
```

> 怎么找到 UUID：左侧菜单 → Authentication → Users，点用户那一行，在右侧详情里复制 ID。

3. 点「Run」

## 第六步：建存储桶

1. 左侧菜单 → Storage
2. 点「New bucket」→ 名字填 `photos` → 勾选「Public bucket」→ 创建
3. 同样再建一个 `letters`
4. 对每个 bucket：点进去 → Policies → 点「New policy」
5. 选「For full customization」→ 策略名随便，Allowed operation 勾 SELECT 和 INSERT → 保存

## 第七步：获取 API 密钥

1. 左侧菜单 → Settings → API
2. 复制「Project URL」和「anon public key」
3. 打开 `index.html`，找到这两行（约第 962 行）：
   ```
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
4. 替换成你刚复制的值

## 第八步：部署到 Vercel

1. 打开 [vercel.com](https://vercel.com)，用 GitHub 账号登录
2. 点「New Project」
3. 把整个 `treehouse-h5` 文件夹拖到上传区域
4. 点「Deploy」
5. 等几十秒，拿到网址（类似 `treehouse.vercel.app`）

## 使用

- 两人各自用手机浏览器打开网址
- 小兔子选🐰，输入自己的密码
- 小狐狸选🦊，输入自己的密码
- 进入庭院后，点击各个区域探索

---

有问题看 Supabase 的报错信息，大部分问题都在 SQL 没执行对或 UUID 填错了。
