-- name: ClearGrant :execrows
UPDATE principal SET grant_hash = NULL WHERE id = $1 AND grant_hash = $2;
