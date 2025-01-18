-- DROP POLICY IF EXISTS "allow_create_company_based_on_permission" ON public.companies;
CREATE POLICY "allow_create_company_based_on_permission"
ON public.companies
AS PERMISSIVE FOR INSERT
TO authenticated
WITH CHECK (
    authorize_permission('sys:create:company', NULL)
);

-- DROP POLICY IF EXISTS "allow_update_company_based_on_permission" ON public.companies;
CREATE POLICY "allow_update_company_based_on_permission"
ON public.companies
AS PERMISSIVE FOR UPDATE
TO authenticated
WITH CHECK (
    authorize_permission('org:update:company', id)
    OR authorize_permission('sys:update:company', NULL)
);

-- DROP POLICY IF EXISTS "allow_delete_company_based_on_permission" ON public.companies;
CREATE POLICY "allow_delete_company_based_on_permission"
ON public.companies
AS PERMISSIVE FOR DELETE
TO authenticated
USING (
    authorize_permission('org:delete:company', id)
    OR authorize_permission('sys:delete:company', NULL)
);

-- DROP POLICY IF EXISTS "allow_update_profile_based_on_permission" ON public.profiles;
CREATE POLICY "allow_update_profile_based_on_permission"
ON public.profiles
AS PERMISSIVE FOR UPDATE
TO authenticated
USING (
    (SELECT authorize_permission('sys:update:profile', NULL))
    OR (SELECT authorize_permission('own:update:profile', NULL))
);
