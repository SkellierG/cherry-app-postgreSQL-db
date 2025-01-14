--CREATE POLICY "allow_based_on_permission"
--ON some_table
--FOR SELECT USING (
--    EXISTS (
--        SELECT 1
--        FROM user_roles ur
--        JOIN role_permissions rp ON ur.role_id = rp.role_id
--        JOIN permissions p ON rp.permission_id = p.id
--        WHERE ur.user_id = auth.uid() AND p.name = 'some:permission'
--    )
--);

CREATE POLICY "allow_create_company_based_on_permission"
ON public.companies
FOR INSERT
with CHECK (
    EXISTS (
        SELECT 1
        FROM user_roles ur
        JOIN role_permissions rp ON ur.role_id = rp.role_id
        JOIN permissions p ON rp.permission_id = p.id
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid() 
          AND p.name = 'sys:create:company'
          AND r.company_id IS NULL
    )
);

