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
('0154c997-9903-44fa-959a-f41459ecc75b', 2);

-- Check all the permissions of a user for a specific company
SELECT p.name
FROM user_roles ur
JOIN role_permissions rp ON ur.role_id = rp.role_id
JOIN permissions p ON rp.permission_id = p.id
JOIN roles r ON ur.role_id = r.id
WHERE ur.user_id = '0154c997-9903-44fa-959a-f41459ecc75b'
AND r.company_id is null;