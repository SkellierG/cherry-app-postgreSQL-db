CREATE TABLE IF NOT EXISTS invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL,
    invitation_link TEXT UNIQUE NOT NULL,
    expiration_time TIMESTAMP NOT NULL,
    max_uses INT NOT NULL DEFAULT 1,
    uses INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT now()
);

DROP TABLE public.invitations;
