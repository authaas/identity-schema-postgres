-- name: GetIdentity :one
-- The two creation dates carry their own names because both tables call theirs
-- creation_date.
SELECT identity.creation_date AS identity_creation_date,
       realm_membership.name,
       realm_membership.display_name,
       realm_membership.creation_date AS membership_creation_date,
       realm_membership.last_authenticated_date,
       realm_membership.grant_hash,
       realm_membership.credentialable,
       realm_membership.nbf,
       realm_membership.exp
  FROM identity_data.realm_membership
  JOIN identity_data.identity
    ON identity.id = realm_membership.identity_id
 WHERE realm_membership.realm_id = $1
   AND realm_membership.identity_id = $2;
