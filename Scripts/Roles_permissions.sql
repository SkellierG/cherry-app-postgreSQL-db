CREATE TABLE IF NOT EXISTS public.roles (
    id SERIAL PRIMARY KEY,
    name TEXT NOT null,
    company_id UUID references public.companies(id) on delete cascade
);
-- DROP TABLE public.roles CASCADE;

CREATE TABLE IF NOT EXISTS public.permissions (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE -- Ej: "sys:create:group", "org:invite:member"
);

-- DROP TABLE public.permissions CASCADE;

CREATE TABLE IF NOT EXISTS public.role_permissions (
    role_id INT REFERENCES public.roles(id) ON DELETE CASCADE,
    permission_id INT REFERENCES public.permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);
-- DROP TABLE public.role_permissions;

CREATE TABLE IF NOT EXISTS public.user_roles (
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role_id INT REFERENCES public.roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);
-- DROP TABLE public.user_roles;

-- DROP ALL TABLES:
-- DROP TABLE public.user_roles, public.role_permissions, public.permissions, public.roles CASCADE;

-- Check if user has a role:
-- $1 is user_id, $2 permission name Ej: "sys:create:group"
--
-- SELECT EXISTS (
--     SELECT 1
--     FROM user_roles ur
--     JOIN role_permissions rp ON ur.role_id = rp.role_id
--     JOIN permissions p ON rp.permission_id = p.id
--     WHERE ur.user_id = $1 AND p.name = $2
-- );

-- Check all the permissions of a user:
-- SELECT p.name
-- FROM user_roles ur
-- JOIN role_permissions rp ON ur.role_id = rp.role_id
-- JOIN permissions p ON rp.permission_id = p.id
-- WHERE ur.user_id = $1;

-- Check all the permissions of a user for a specific company
--$3 is the company id
--SELECT p.name
--FROM user_roles ur
--JOIN role_permissions rp ON ur.role_id = rp.role_id
--JOIN permissions p ON rp.permission_id = p.id
--JOIN roles r ON ur.role_id = r.id
--WHERE ur.user_id = $1
--AND r.company_id = $3;