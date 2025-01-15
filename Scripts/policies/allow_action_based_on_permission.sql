--DROP POLICY IF EXISTS "allow_create_company_based_on_permission";
CREATE POLICY "allow_create_company_based_on_permission"
ON public.companies
FOR INSERT
WITH CHECK (
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

--DROP POLICY IF EXISTS "allow_update_company_based_on_permission";
CREATE POLICY "allow_update_company_based_on_permission"
ON public.companies
FOR UPDATE
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM user_roles ur
        JOIN role_permissions rp ON ur.role_id = rp.role_id
        JOIN permissions p ON rp.permission_id = p.id
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid() 
          AND p.name = 'org:update:company'
          AND r.company_id = companies.id
    )
    OR EXISTS (
        SELECT 1
        FROM user_roles ur
        JOIN role_permissions rp ON ur.role_id = rp.role_id
        JOIN permissions p ON rp.permission_id = p.id
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
          AND p.name = 'sys:update:company'
          AND r.company_id IS NULL
    )
);

--DROP POLICY IF EXISTS "allow_delete_company_based_on_permission";
CREATE POLICY "allow_delete_company_based_on_permission"
ON public.companies
FOR DELETE
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM user_roles ur
        JOIN role_permissions rp ON ur.role_id = rp.role_id
        JOIN permissions p ON rp.permission_id = p.id
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid() 
          AND p.name = 'org:delete:company'
          AND r.company_id = companies.id
    )
    OR EXISTS (
        SELECT 1
        FROM user_roles ur
        JOIN role_permissions rp ON ur.role_id = rp.role_id
        JOIN permissions p ON rp.permission_id = p.id
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
          AND p.name = 'sys:delete:company'
          AND r.company_id IS NULL
    )
);

--DROP POLICY IF EXISTS "allow_update_profile_based_on_permission";
CREATE POLICY "allow_update_profile_based_on_permission"
ON public.profiles
FOR UPDATE
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM user_roles ur
        JOIN role_permissions rp ON ur.role_id = rp.role_id
        JOIN permissions p ON rp.permission_id = p.id
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid() 
          AND p.name = 'sys:update:profile'
          AND r.company_id IS NULL
    )
);
