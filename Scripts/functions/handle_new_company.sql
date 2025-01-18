-- DROP FUNCTION public.handle_new_company() CASCADE;

CREATE OR REPLACE FUNCTION public.handle_new_company()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
	copiar public.roles(id, name, company_id) donde name='owner' con sus respectivos public.permissions(id, name) obtenidos atraves de role_permissions(role_id, permission_id)
	luego remplazar company_id por el id de la companie creada recien
	insertar el nuevo rol en public.roles
  insert into public.user_roles (user_id, role_id)
  values (
    new.id del usuario que hizo el insert,
	new.pegar el id del rol creado recientemente
  );
  return new;
end;
$function$
;

-- DROP TRIGGER IF EXISTS handle_new_company_trigger ON public.companies;
CREATE TRIGGER handle_new_company_trigger
AFTER INSERT ON public.companies
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();