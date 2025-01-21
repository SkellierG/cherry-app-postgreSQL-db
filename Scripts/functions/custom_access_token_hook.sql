-- DROP FUNCTION IF EXISTS public.custom_access_token_hook(event JSONB) CASCADE;

CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SET search_path = ''
STABLE
AS $$
DECLARE
    claims JSONB;
    roles_data JSONB;
    companies_data JSONB;
BEGIN
    claims := event->'claims';

	RAISE NOTICE 'Claims: %', claims;

    WITH role_data AS (
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
        WHERE ur.user_id = (claims->>'sub')::UUID
        GROUP BY r.id, r.name, r.company_id
    ),
    aggregated_roles AS (
        SELECT JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'id', role_id,
                'name', role_name,
                'company_id', company_id,
                'permissions', permissions
            )
        ) AS roles
        FROM role_data
    ),
    aggregated_companies AS (
        SELECT JSONB_AGG(DISTINCT company_id) AS joined_companies
        FROM role_data
    )
    SELECT 
        roles,
        joined_companies
    INTO 
        roles_data,
        companies_data
    FROM aggregated_roles, aggregated_companies;

	RAISE NOTICE 'Roles data: %', roles_data;
	RAISE NOTICE 'Companies data: %', companies_data;

    claims := JSONB_SET(claims, '{roles}', COALESCE(roles_data, '[]'::JSONB));
    claims := JSONB_SET(claims, '{joined_companies}', COALESCE(companies_data, '[]'::JSONB));

    event := JSONB_SET(event, '{claims}', claims);

    RETURN event;
END;
$$;

GRANT USAGE ON SCHEMA public TO supabase_auth_admin;
GRANT EXECUTE ON FUNCTION public.custom_access_token_hook TO supabase_auth_admin;
REVOKE EXECUTE ON FUNCTION public.custom_access_token_hook FROM authenticated, anon, public;

GRANT SELECT ON public.user_roles, public.roles, public.role_permissions, public.permissions TO supabase_auth_admin;
REVOKE SELECT ON public.user_roles, public.roles, public.role_permissions, public.permissions FROM authenticated, anon, public;