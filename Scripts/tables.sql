-- DROP TABLE public.profiles;
CREATE TABLE IF NOT EXISTS public.profiles (
	id UUID DEFAULT gen_random_uuid() NOT NULL,
	user_id UUID NOT NULL UNIQUE,
	name VARCHAR(255) NULL,
	lastname VARCHAR(255) NULL,
	avatar_url TEXT NULL,
	is_profiled bool DEFAULT false NOT NULL,
	is_oauth bool DEFAULT false NOT NULL,
	updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
	created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
	CONSTRAINT profile_pk PRIMARY KEY (id, user_id),
	CONSTRAINT fk_users FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- DROP TABLE public.centro_frutal;
CREATE TABLE IF NOT EXISTS public.centro_frutal (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nivel_1 INT DEFAULT 0 NOT NULL,
    nivel_2 INT DEFAULT 0 NOT NULL,
    CONSTRAINT centro_frutal_pk PRIMARY KEY (id)
);

-- DROP TABLE public.frutos;
CREATE TABLE public.frutos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nivel_1 INT DEFAULT 0 NOT NULL,
    nivel_2 INT DEFAULT 0 NOT NULL,
    CONSTRAINT frutos_pk PRIMARY KEY (id)
);

-- DROP TABLE public.companies;
CREATE TABLE IF NOT EXISTS public.companies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name VARCHAR(100) NOT NULL,
    avatar_url TEXT,
    slogan VARCHAR(255),
    description TEXT,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,
    deleted_at timestamptz,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255),
    CONSTRAINT companies_pk PRIMARY KEY (id)
);

-- DROP TABLE public.previos;
CREATE TABLE IF NOT EXISTS public.previos (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    fecha timestamptz NOT NULL,
    CONSTRAINT previo_pk PRIMARY KEY (id)
);

-- DROP TABLE public.muestras;
CREATE TABLE public.muestras (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
    centro_frutal_id uuid NOT NULL,
    fruto_id uuid NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT muestras_pk PRIMARY KEY (id),
    CONSTRAINT fk_muestras_centro_frutal FOREIGN KEY (centro_frutal_id) REFERENCES public.centro_frutal(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_muestras_fruto FOREIGN KEY (fruto_id) REFERENCES public.frutos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- DROP TABLE public.company_previos;
CREATE TABLE IF NOT EXISTS public.company_previos (
    company_id uuid NOT NULL,
    previo_id uuid NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT company_previos_pk PRIMARY KEY (company_id, previo_id),
    CONSTRAINT fk_company_previos_company FOREIGN KEY (company_id) REFERENCES public.companies(id) ON UPDATE CASCADE,
    CONSTRAINT fk_company_previos_previo FOREIGN KEY (previo_id) REFERENCES public.previos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- DROP TABLE public.previo_muestras;
CREATE TABLE IF NOT EXISTS public.previo_muestras (
    previo_id uuid NOT NULL,
    muestra_id uuid NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT previo_muestras_pk PRIMARY KEY (previo_id, muestra_id),
    CONSTRAINT fk_previo_muestras_previo FOREIGN KEY (previo_id) REFERENCES public.previos(id) ON UPDATE CASCADE,
    CONSTRAINT fk_previo_muestras_muestra FOREIGN KEY (muestra_id) REFERENCES public.muestras(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- DROP TABLE public.centro_frutal cascade;
-- DROP TABLE public.frutos cascade;
-- DROP TABLE public.companies cascade;
-- DROP TABLE public.previos cascade;
-- DROP TABLE public.muestras cascade;
-- DROP TABLE public.company_previos cascade;
-- DROP TABLE public.previo_muestras cascade;
