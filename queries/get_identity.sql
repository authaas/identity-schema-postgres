-- name: GetIdentity :one
SELECT id, name, display_name, creation_date, last_authenticated_date, grant_hash
  FROM principal
 WHERE id = $1;
