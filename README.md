# auth migrations

The schema for the `authentication` database, which the authentication system's
services share.

A service does not map one to one with a table. `register.md` commits a
principal and a credential record together, with the credential's reference to
the principal as a stored constraint, and a foreign key cannot span databases —
so the service boundary is not a database boundary, and the schema belongs to
none of them.

## Layout

Versioned SQL in pairs, applied in order:

```text
000n_*.up.sql
000n_*.down.sql
```

The `up` makes the change and the `down` reverses it. Nothing is edited once it
has been applied anywhere; a change to an applied migration is a new pair.

## Applying

[golang-migrate](https://github.com/golang-migrate/migrate) reads its own
`schema_migrations` table to decide what is outstanding, applies the `up` files
newer than that in order, and exits.

```bash
migrate -path . -database "$DATABASE_URL" up
```

The published `migrate/migrate` image runs exactly that, so a deployment runs it
as a one-shot job rather than building anything.

## Access

Everything connects as the default `postgres` account with no password.
Authenticating database access is defence in depth here and nothing depends on
it. Separate accounts and grants are a later concern.
