-- A principal is an identity that a token's sub claim names.
--
-- No RPC creates one. Creation belongs to the flow that establishes the subject
-- as legitimate, inside that flow's atomic commit.
CREATE TABLE principal (
    id                      UUID PRIMARY KEY,
    name                    TEXT   NOT NULL DEFAULT '',
    display_name            TEXT   NOT NULL DEFAULT '',
    creation_date           BIGINT NOT NULL,
    last_authenticated_date BIGINT NOT NULL,

    -- The SHA-256 digest of the principal's outstanding grant, or NULL when
    -- none is outstanding. NULL is what makes a grant single use: clearing sets
    -- it back, and a NULL column matches no presented value.
    grant_hash              BYTEA
);
