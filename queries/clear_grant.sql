-- name: ClearGrant :execrows
UPDATE identity_data.realm_membership
   SET grant_hash = NULL
 WHERE realm_id = $1
   AND identity_id = $2
   AND grant_hash = $3
   AND identity_data.assumable($1, $2);
