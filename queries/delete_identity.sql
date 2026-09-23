-- name: DeleteIdentity :execrows
DELETE FROM identity_data.identity WHERE id = $1;
