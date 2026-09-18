-- One replaceable, single-use challenge per credential. Time is not part of
-- validity; login atomically consumes this slot when issuing a principal grant.
ALTER TABLE credential ADD COLUMN current_login_challenge BYTEA
    CHECK (current_login_challenge IS NULL OR octet_length(current_login_challenge) = 32);
