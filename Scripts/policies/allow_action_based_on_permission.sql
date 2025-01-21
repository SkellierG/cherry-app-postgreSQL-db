-- DROP POLICY IF EXISTS "allow_create_company_based_on_permission" ON public.companies;
CREATE POLICY "allow_create_company_based_on_permission"
ON public.companies
AS PERMISSIVE FOR INSERT
TO authenticated
WITH CHECK (
    (SELECT authorize_permission('sys:create:company', NULL))
);

-- DROP POLICY IF EXISTS "allow_update_company_based_on_permission" ON public.companies;
CREATE POLICY "allow_update_company_based_on_permission"
ON public.companies
AS PERMISSIVE FOR UPDATE
TO authenticated
WITH CHECK (
    (SELECT authorize_permission('org:update:company', id))
    OR (SELECT authorize_permission('sys:update:company', NULL))
);

-- DROP POLICY IF EXISTS "allow_view_company_based_on_permission" ON public.companies;
CREATE POLICY "allow_view_company_based_on_permission"
ON public.companies
AS PERMISSIVE FOR SELECT
TO authenticated
USING (
    (SELECT authorize_permission('org:view:company', id))
    OR (SELECT authorize_permission('sys:view:company', NULL))
);

-- DROP POLICY IF EXISTS "allow_delete_company_based_on_permission" ON public.companies;
CREATE POLICY "allow_delete_company_based_on_permission"
ON public.companies
AS PERMISSIVE FOR DELETE
TO authenticated
USING (
    (SELECT authorize_permission('org:delete:company', id))
    OR (SELECT authorize_permission('sys:delete:company', NULL))
);

-- DROP POLICY IF EXISTS "allow_update_profile_based_on_permission" ON public.profiles;
CREATE POLICY "allow_update_profile_based_on_permission"
ON public.profiles
AS PERMISSIVE FOR UPDATE
TO authenticated
USING (
    (SELECT authorize_permission('sys:update:profile', NULL))
    OR (SELECT authorize_permission('own:update:profile', NULL)) AND ((SELECT auth.uid()) = user_id)
);

-- DROP POLICY IF EXISTS "allow_view_user_roles_based_on_permission" ON public.user_roles;
CREATE POLICY "allow_view_user_roles_based_on_permission"
ON public.user_roles
AS PERMISSIVE FOR SELECT
TO authenticated
USING (
    (SELECT authorize_permission('sys:view:roles', NULL))
    OR EXISTS (
        SELECT 1
        FROM roles r
        WHERE r.id = user_roles.role_id
          AND authorize_permission('org:view:role', r.company_id) OR r.company_id IS NULL
    )
);

-- DROP POLICY IF EXISTS "allow_view_roles_based_on_permission" ON public.roles;
CREATE POLICY "allow_view_roles_based_on_permission"
ON public.roles
AS PERMISSIVE FOR SELECT
TO authenticated
USING (
    (SELECT authorize_permission('sys:view:role', NULL))
    OR (SELECT authorize_permission('org:view:role', company_id) OR company_id IS NULL)
);

-- DROP POLICY IF EXISTS "allow_view_role_permissions_on_permission" ON public.role_permissions;
CREATE POLICY "allow_view_role_permissions_on_permission"
ON public.role_permissions
AS PERMISSIVE FOR SELECT
TO authenticated
USING (
    (SELECT authorize_permission('sys:view:role', NULL))
    OR EXISTS (
        SELECT 1
        FROM roles r
        WHERE r.id = role_permissions.role_id
          AND authorize_permission('org:view:role', r.company_id) OR r.company_id IS NULL
    )
);

-- DROP POLICY IF EXISTS "allow_view_permissions_on_permission" ON public.permissions;
CREATE POLICY "allow_view_permissions_on_permission"
ON public.permissions
AS PERMISSIVE FOR SELECT
TO authenticated
USING (
    (SELECT authorize_permission('sys:view:permission', NULL))
);

-- DROP POLICY IF EXISTS "allow_create_company_based_on_permission" ON public.companies;
-- DROP POLICY IF EXISTS "allow_update_company_based_on_permission" ON public.companies;
-- DROP POLICY IF EXISTS "allow_view_company_based_on_permission" ON public.companies;
-- DROP POLICY IF EXISTS "allow_delete_company_based_on_permission" ON public.companies;
-- DROP POLICY IF EXISTS "allow_update_profile_based_on_permission" ON public.profiles;
-- DROP POLICY IF EXISTS "allow_view_user_roles_based_on_permission" ON public.user_roles;
-- DROP POLICY IF EXISTS "allow_view_roles_based_on_permission" ON public.roles;
-- DROP POLICY IF EXISTS "allow_view_role_permissions_on_permission" ON public.role_permissions;
-- DROP POLICY IF EXISTS "allow_view_permissions_on_permission" ON public.permissions;
