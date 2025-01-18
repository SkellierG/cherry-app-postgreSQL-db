-- DROP FUNCTION public.update_modified_column() cascade;

CREATE OR REPLACE FUNCTION public.update_modified_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$function$
;

-- DROP TRIGGER IF EXISTS update_modified_column_some_table ON public.some_table;
--CREATE TRIGGER update_modified_column_trigger
--BEFORE UPDATE ON public.some_table
--FOR EACH ROW
--EXECUTE FUNCTION public.update_modified_column();

-- DROP TRIGGER IF EXISTS update_modified_column_profiles ON public.profiles;
CREATE TRIGGER update_modified_column_profiles
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.update_modified_column();

-- DROP TRIGGER IF EXISTS update_modified_column_companies ON public.companies;
CREATE TRIGGER update_modified_column_companies
BEFORE UPDATE ON public.companies
FOR EACH ROW
EXECUTE FUNCTION public.update_modified_column();