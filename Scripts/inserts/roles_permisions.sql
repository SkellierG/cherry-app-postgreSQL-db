INSERT INTO public.permissions (name) values
--sys
('sys:create:company'),
('sys:update:company'),
('sys:delete:company'),
('sys:join:company'),
--org
('org:update:company'), --company
('org:delete:company'),
('org:create:role'), --role
('org:update:role'),
('org:delete:role'),
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
((SELECT id FROM public.roles WHERE name = 'freetrial'), (SELECT id FROM public.permissions WHERE name = 'own:delete:profile'));

