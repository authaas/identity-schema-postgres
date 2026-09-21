-- name: GetGrantHash :one
SELECT grant_hash FROM principal WHERE id = $1;
