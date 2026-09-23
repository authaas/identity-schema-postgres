-- name: SetValidity :execrows
UPDATE identity_data.realm_membership
   SET nbf = $3,
       exp = $4
 WHERE realm_id = $1
   AND identity_id = $2;
