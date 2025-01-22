-- DROP FUNCTION public.handle_new_company() CASCADE;

CREATE OR REPLACE FUNCTION public.handle_new_company()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO public
AS $function$
DECLARE
    owner_role_id int;
    new_role_id int;
    user_id uuid;
BEGIN
    -- Verificar que el rol "owner" global existe
    SELECT id INTO owner_role_id
    FROM public.roles
    WHERE name = 'owner' AND company_id IS NULL;

    IF owner_role_id IS NULL THEN
        RAISE EXCEPTION '"owner" global role not found';
    END IF;

    -- Obtener el user_id desde el JWT
    BEGIN
        user_id := ( auth.jwt()->>'sub' )::uuid;
    EXCEPTION WHEN invalid_text_representation THEN
        RAISE EXCEPTION 'Invalid UUID in request.jwt.claim.sub: %',
                        ( auth.jwt()->>'sub' );
    END;

    -- Crear un nuevo rol "owner" para la compañía
    INSERT INTO public.roles (name, company_id)
    VALUES ('owner', NEW.id)
    RETURNING id INTO new_role_id;

    -- Copiar permisos del rol "owner" global al nuevo rol
    INSERT INTO public.role_permissions (role_id, permission_id)
    SELECT new_role_id, permission_id
    FROM public.role_permissions
    WHERE role_id = owner_role_id;

    -- Asignar el nuevo rol "owner" al usuario actual
    INSERT INTO public.user_roles (user_id, role_id)
    VALUES (user_id, new_role_id);

    RETURN NEW;
END;
$function$
;

-- DROP TRIGGER IF EXISTS handle_new_company_trigger ON public.companies;
CREATE TRIGGER handle_new_company_trigger
AFTER INSERT ON public.companies
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_company();
