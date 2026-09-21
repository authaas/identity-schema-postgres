-- name: DeleteIdentity :execrows
DELETE FROM principal WHERE id = $1;
