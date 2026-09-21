# identity-schema-postgres

The identity's PostgreSQL schema, and the statements the identity data service
runs against it.

## Layout

```text
migrations/   versioned pairs, 000n_*.up.sql and 000n_*.down.sql, applied in order
queries/      one statement per file, named for the data RPC it serves
```

Nothing under `migrations/` is edited once it has been applied anywhere; a
change to an applied migration is a new pair.

## Applying

```bash
migrate -path migrations -database "$DATABASE_URL" up
```

The published `migrate/migrate` image runs exactly that.

## Generating

This repository holds SQL only. Each language binding is generated in its own
repository from a tag of this one: `identity-operations-postgres-pgx-go` runs
sqlc over `migrations/` and `queries/`.
