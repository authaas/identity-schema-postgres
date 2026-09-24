CREATE SCHEMA identity_data;

-- An identity identifies a token's sub claim. It exists once, independently of
-- any realm it belongs to.
CREATE TABLE identity_data.identity (
    id            UUID   PRIMARY KEY,
    creation_date BIGINT NOT NULL
);

-- A membership is an identity's standing in one realm: the name it goes by
-- there, when it joined, when it last authenticated, and its outstanding
-- grant. An identity holds one membership per realm it belongs to.
CREATE TABLE identity_data.realm_membership (
    identity_id             UUID    NOT NULL REFERENCES identity_data.identity (id) ON DELETE CASCADE,
    realm_id                UUID    NOT NULL REFERENCES realm_data.realm (id) ON DELETE CASCADE,

    name                    TEXT    NOT NULL DEFAULT '',
    display_name            TEXT    NOT NULL DEFAULT '',
    creation_date           BIGINT  NOT NULL,
    last_authenticated_date BIGINT  NOT NULL,

    -- The SHA-256 digest of the membership's outstanding grant, or NULL when
    -- none is outstanding. NULL is what makes a grant single use: clearing sets
    -- it back, and a NULL column matches no presented value.
    grant_hash              BYTEA,

    -- Whether a credential may reference this membership. False for a group
    -- and for a machine identity, which authenticate by assumption.
    credentialable          BOOLEAN NOT NULL,

    PRIMARY KEY (realm_id, identity_id),

    -- The target of credential's foreign key, which pins credentialable to
    -- true on its side.
    UNIQUE (realm_id, identity_id, credentialable)
);

CREATE INDEX realm_membership_identity_id ON identity_data.realm_membership (identity_id);

-- A group is an identity that other identities in its realm belong to, and
-- whose identity a member may assume. Both columns name a membership in the
-- row's realm, so a group never holds a member from another realm.
CREATE TABLE identity_data.group_membership (
    realm_id           UUID NOT NULL,
    group_identity_id  UUID NOT NULL,
    member_identity_id UUID NOT NULL,

    PRIMARY KEY (realm_id, group_identity_id, member_identity_id),

    FOREIGN KEY (realm_id, group_identity_id)
        REFERENCES identity_data.realm_membership (realm_id, identity_id) ON DELETE CASCADE,
    FOREIGN KEY (realm_id, member_identity_id)
        REFERENCES identity_data.realm_membership (realm_id, identity_id) ON DELETE CASCADE,

    CHECK (group_identity_id <> member_identity_id)
);

CREATE INDEX group_membership_member ON identity_data.group_membership (realm_id, member_identity_id);

-- Taking on a membership: its grant becomes the digest presented and its last
-- authenticated date advances. Answers whether the membership exists.
--
-- Every path that concludes in a grant calls this, composed into the statement
-- that performs whatever else that path commits, so the two land together.
CREATE FUNCTION identity_data.assume(realm UUID, identity UUID, digest BYTEA, at BIGINT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE identity_data.realm_membership
       SET grant_hash = digest,
           last_authenticated_date = at
     WHERE realm_membership.realm_id = realm
       AND realm_membership.identity_id = identity;

    RETURN FOUND;
END;
$$;
