-- name: GetGrantHash :one
SELECT grant_hash
  FROM identity_data.realm_membership
 WHERE realm_id = $1
   AND identity_id = $2;
