-- DROP FUNCTION public.handle_new_user() CASCADE;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.profiles (user_id, name, lastname, avatar_url)
  values (
    new.id,
    split_part(new.raw_user_meta_data->>'full_name', ' ', 1),
    nullif(split_part(new.raw_user_meta_data->>'full_name', ' ', 2), ''),
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$function$
;

-- DROP TRIGGER IF EXISTS handle_new_user_some_table ON auth.some_table;
--CREATE TRIGGER handle_new_user_some_table
--AFTER INSERT ON auth.some_table
--FOR EACH ROW
--EXECUTE FUNCTION public.handle_new_user();

-- DROP TRIGGER IF EXISTS handle_new_user_trigger ON auth.users;
CREATE TRIGGER handle_new_user_trigger
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_user();

