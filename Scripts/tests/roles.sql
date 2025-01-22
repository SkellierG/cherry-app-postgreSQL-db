select id,name
FROM permissions 
WHERE name LIKE '%sys%';

insert into public.role_permissions (role_id, permission_id) values
(2, 11), -- everyone
(2, 3),
(2, 7),
(2, 8),
(2, 9),
(2, 10);

--TEST
SELECT id FROM auth.users where email = 'benja314gonzalez@gmail.com'
insert into public.user_roles (user_id, role_id) values
('f1ab3c92-52e8-4cc7-a198-0bd96e7d69cc', (SELECT id FROM public.roles WHERE name = 'freetrial'));

-- Check all the permissions of a user for a specific company
SELECT p.name
FROM user_roles ur
JOIN role_permissions rp ON ur.role_id = rp.role_id
JOIN permissions p ON rp.permission_id = p.id
JOIN roles r ON ur.role_id = r.id
WHERE ur.user_id = 'f1ab3c92-52e8-4cc7-a198-0bd96e7d69cc'
AND r.company_id is null;

SELECT
    r.id AS role_id,
    r.name AS role_name,
    r.company_id,
    COALESCE(
        ARRAY_AGG(p.name ORDER BY p.name),
        ARRAY[]::TEXT[]
    ) AS permissions
FROM public.user_roles ur
INNER JOIN public.roles r ON ur.role_id = r.id
LEFT JOIN public.role_permissions rp ON r.id = rp.role_id
LEFT JOIN public.permissions p ON rp.permission_id = p.id
WHERE ur.user_id = 'f1ab3c92-52e8-4cc7-a198-0bd96e7d69cc'::UUID
GROUP BY r.id, r.name, r.company_id

SELECT public.custom_access_token_hook(
    '{"claims": {
  "aal": "aal1",
  "amr": [
    {
      "method": "oauth",
      "timestamp": 1737159791
    }
  ],
  "app_metadata": {
    "provider": "google",
    "providers": [
      "google"
    ]
  },
  "aud": [
    "authenticated"
  ],
  "email": "benja314gonzalez@gmail.com",
  "exp": 1737163391,
  "iat": 1737159791,
  "is_anonymous": false,
  "iss": "https://caoduwcuvrdckoqbrcsd.supabase.co/auth/v1",
  "phone": "",
  "role": "authenticated",
  "session_id": "e4adce7d-d98a-43e1-a094-bfe92ad38558",
  "sub": "f1ab3c92-52e8-4cc7-a198-0bd96e7d69cc",
  "user_metadata": {
    "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocJTiR2G06YTOzj_haLp1XxW5umS6k1xY0-Tq9xR0WkNoS9Zgw0=s96-c",
    "email": "benja314gonzalez@gmail.com",
    "email_verified": true,
    "full_name": "Benjamín González",
    "iss": "https://accounts.google.com",
    "name": "Benjamín González",
    "phone_verified": false,
    "picture": "https://lh3.googleusercontent.com/a/ACg8ocJTiR2G06YTOzj_haLp1XxW5umS6k1xY0-Tq9xR0WkNoS9Zgw0=s96-c",
    "provider_id": "111404345366080633260",
    "sub": "111404345366080633260"
  }
}}'::JSONB
);

SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name IN ('roles');

 SELECT * 
FROM public.user_roles ur
INNER JOIN public.roles r ON ur.role_id = r.id
WHERE ur.user_id = 'f1ab3c92-52e8-4cc7-a198-0bd96e7d69cc';

SELECT *
FROM public.role_permissions rp
INNER JOIN public.permissions p ON rp.permission_id = p.id
WHERE rp.role_id IN (
    SELECT role_id 
    FROM public.user_roles 
    WHERE user_id = 'f1ab3c92-52e8-4cc7-a198-0bd96e7d69cc'
);

SELECT *
FROM pg_roles

SET ROLE supabase_auth_admin;
RESET ROLE;
SET ROLE postgres;

SELECT current_setting('request.jwt.claim.user_id');
