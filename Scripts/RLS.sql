alter table public.profiles enable row level security;
alter table public.companies enable row level security;
alter table public.company_previos enable row level security;
alter table public.previos enable row level security;
alter table public.previo_muestras enable row level security;
alter table public.muestras enable row level security;
alter table public.centro_frutal enable row level security;
alter table public.frutos enable row level security;
alter table public.roles enable row level security;
alter table public.role_permissions enable row level security;
alter table public.permissions enable row level security;
alter table public.user_roles enable row level security;

-- Policy for table public.user_roles
CREATE POLICY "supabase_auth_admin_user_roles"
ON public.user_roles
FOR SELECT
USING (current_user = 'supabase_auth_admin');

-- Policy for table public.roles
CREATE POLICY "supabase_auth_admin_roles"
ON public.roles
FOR SELECT
USING (current_user = 'supabase_auth_admin');

-- Policy for table public.role_permissions
CREATE POLICY "supabase_auth_admin_role_permissions"
ON public.role_permissions
FOR SELECT
USING (current_user = 'supabase_auth_admin');

-- Policy for table public.permissions
CREATE POLICY "supabase_auth_admin_permissions"
ON public.permissions
FOR SELECT
USING (current_user = 'supabase_auth_admin');

-- Policy for table public.companies
CREATE POLICY "supabase_auth_admin_companies"
ON public.companies
FOR SELECT
USING (current_user = 'supabase_auth_admin');

-- Grant permissions to supabase_auth_admin
GRANT ALL ON public.user_roles TO supabase_auth_admin;
GRANT ALL ON public.roles TO supabase_auth_admin;
GRANT ALL ON public.role_permissions TO supabase_auth_admin;
GRANT ALL ON public.permissions TO supabase_auth_admin;
GRANT ALL ON public.companies TO supabase_auth_admin;