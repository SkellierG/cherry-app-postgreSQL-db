-- DROP FUNCTION IF EXISTS public.authorize_permission() CASCADE;

CREATE OR REPLACE FUNCTION public.authorize_permission(
  requested_permission TEXT,
  company_id UUID DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
  user_roles JSONB;
  role JSONB;
  permissions JSONB;
  joined_companies JSONB;
  role_id UUID;
  company_id_role UUID;
  is_global BOOLEAN;
  found_permission BOOLEAN := FALSE;
BEGIN
  SELECT
    (auth.jwt() -> 'roles')::JSONB,
    (auth.jwt() -> 'joined_companies')::JSONB
  INTO
    user_roles, joined_companies;

  FOR role IN SELECT * FROM jsonb_array_elements(user_roles) LOOP
    company_id_role := (role ->> 'company_id')::UUID;

    is_global := (company_id IS NULL);

    IF NOT is_global AND company_id_role = company_id THEN
      permissions := role -> 'permissions';
      IF requested_permission = ANY (SELECT jsonb_array_elements_text(permissions)) THEN
        found_permission := TRUE;
        EXIT;
      END IF;
    ELSIF is_global AND company_id_role IS NULL THEN
      permissions := role -> 'permissions';
      IF requested_permission = ANY (SELECT jsonb_array_elements_text(permissions)) THEN
        found_permission := TRUE;
        EXIT;
      END IF;
    END IF;
  END LOOP;

  RETURN found_permission;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = '';
