-- A credential is a public key an authenticator created for a principal
-- during a WebAuthn registration ceremony. Register commits one beside the
-- principal it references, in one transaction; Login reads it and advances
-- its counters in the same transaction that writes the principal's grant.
--
-- The credential type is the fixed WebAuthn value "public-key" and is not
-- stored.
CREATE TABLE credential (
    -- The credential id the authenticator chose, at most 1023 bytes.
    id                           BYTEA   PRIMARY KEY CHECK (octet_length(id) <= 1023),
    principal_id                 UUID    NOT NULL REFERENCES principal(id) ON DELETE CASCADE,

    -- The COSE-encoded public key.
    public_key                   BYTEA   NOT NULL,
    sign_count                   BIGINT  NOT NULL,
    uv_initialized               BOOLEAN NOT NULL,
    transports                   TEXT[]  NOT NULL DEFAULT '{}',
    backup_eligible              BOOLEAN NOT NULL,
    backup_state                 BOOLEAN NOT NULL,

    -- The registration evidence, retained for a later attestation-trust
    -- re-evaluation.
    attestation_object           BYTEA   NOT NULL,
    attestation_client_data_json BYTEA   NOT NULL,

    -- The RP ID issued for the registration, when the operator retains it.
    rp_id                        TEXT
);

CREATE INDEX credential_principal_id ON credential (principal_id);
