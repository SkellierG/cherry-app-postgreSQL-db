INSERT INTO public.permissions (name) values
--sys
('sys:create:company'),
('sys:update:company'),
('sys:delete:company'),
('sys:view:company'),
('sys:join:company'),
('sys:view:role'),
('sys:view:permission'),
--org
('org:update:company'), --company
('org:delete:company'),
('org:view:company'),
('org:create:role'), --role
('org:update:role'),
('org:delete:role'),
('org:view:role'),
('org:assign:role'),
('org:invite:member'), --member
('org:kick:member'),
--own
('own:create:profile'),
('own:update:profile'),
('own:delete:profile');

INSERT INTO public.roles (name, company_id) values
('freetrial', null),
('member', null),
('owner', null),
('sysadmin', null);


INSERT INTO public.role_permissions (role_id, permission_id) VALUES
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'sys:create:company')),
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'own:create:profile')),
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'own:update:profile')),
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'own:delete:profile')),
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'sys:join:company')),
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'sys:view:permission')),
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'org:view:role'));

INSERT INTO public.role_permissions (role_id, permission_id) VALUES
((SELECT id FROM public.roles WHERE name = 'member'), (SELECT id FROM public.permissions WHERE name = 'org:view:role')),
((SELECT id FROM public.roles WHERE name = 'member'), (SELECT id FROM public.permissions WHERE name = 'org:view:company')),
((SELECT id FROM public.roles WHERE name = 'member'), (SELECT id FROM public.permissions WHERE name = 'org:invite:member'));

INSERT INTO public.role_permissions (role_id, permission_id) VALUES
((SELECT id FROM public.roles WHERE name = 'owner'), (SELECT id FROM public.permissions WHERE name = 'org:update:company')),
((SELECT id FROM public.roles WHERE name = 'owner'), (SELECT id FROM public.permissions WHERE name = 'org:delete:company')),
--((SELECT id FROM public.roles WHERE name = 'owner'), (SELECT id FROM public.permissions WHERE name = 'own:view:company')),
((SELECT id FROM public.roles WHERE name = 'owner'), (SELECT id FROM public.permissions WHERE name = 'org:view:role'));

INSERT INTO public.role_permissions (role_id, permission_id) VALUES
((SELECT id FROM public.roles WHERE name = 'sysadmin'), (SELECT id FROM public.permissions WHERE name = 'sys:create:company')),
((SELECT id FROM public.roles WHERE name = 'sysadmin'), (SELECT id FROM public.permissions WHERE name = 'sys:update:company')),
((SELECT id FROM public.roles WHERE name = 'sysadmin'), (SELECT id FROM public.permissions WHERE name = 'sys:delete:company')),
((SELECT id FROM public.roles WHERE name = 'sysadmin'), (SELECT id FROM public.permissions WHERE name = 'sys:view:company')),
((SELECT id FROM public.roles WHERE name = 'sysadmin'), (SELECT id FROM public.permissions WHERE name = 'sys:join:company')),
((SELECT id FROM public.roles WHERE name = 'sysadmin'), (SELECT id FROM public.permissions WHERE name = 'sys:view:permission')),
((SELECT id FROM public.roles WHERE name = 'sysadmin'), (SELECT id FROM public.permissions WHERE name = 'sys:view:role'));