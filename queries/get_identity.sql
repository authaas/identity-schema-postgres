-- name: GetIdentity :one
SELECT *
  FROM principal
 WHERE id = $1;
