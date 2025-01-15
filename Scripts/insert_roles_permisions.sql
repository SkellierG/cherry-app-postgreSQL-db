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
('own:create:profile');
('own:update:profile'),
('own:delete:profile'),

INSERT INTO public.roles (name, company_id) values
('everyone', null),
('member', null),
('sysadmin', null),
('owner', null);