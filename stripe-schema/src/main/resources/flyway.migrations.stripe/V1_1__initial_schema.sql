create type credit_type as ENUM('SIGNUP', 'STRIPE');

CREATE TABLE "user"
(
    id SERIAL,
    email      VARCHAR   NOT NULL UNIQUE,
    CONSTRAINT user_id PRIMARY KEY (id)
);

CREATE TABLE stripe_user
(
    id SERIAL,
    stripe_user_id VARCHAR UNIQUE NOT NULL,
    user_id int4 NOT NULL UNIQUE,
    email      VARCHAR   NOT NULL UNIQUE,
    created          TIMESTAMP NULL     DEFAULT timezone('utc'::TEXT, NOW()),
    deleted          TIMESTAMP NULL     DEFAULT NULL,
    CONSTRAINT stripe_user_id PRIMARY KEY (id),
    CONSTRAINT user_stripe_user_fk FOREIGN KEY (user_id) REFERENCES "user" (id)
);
CREATE INDEX ix_stripe_user_user_id ON stripe_user (user_id);
CREATE INDEX ix_stripe_user ON stripe_user (stripe_user_id);

CREATE TABLE stripe_transaction
(
    id SERIAL,
    stripe_user_id VARCHAR NOT NULL,
    amount money NOT NULL,
    transaction_id   VARCHAR   NOT NULL UNIQUE,
    created timestamp NULL DEFAULT timezone('utc'::text, now()),
    deleted timestamp NULL DEFAULT NULL,
    CONSTRAINT stripe_transaction_id PRIMARY KEY (id),
    CONSTRAINT stripe_transaction_stripe_user_fk FOREIGN KEY (stripe_user_id) REFERENCES stripe_user (stripe_user_id)
);
CREATE INDEX ix_stripe_transaction_stripe_user_id ON stripe_transaction (stripe_user_id);

CREATE TABLE credit_account
(
    id SERIAL,
    user_id int4 NOT NULL,
    created timestamp NULL DEFAULT timezone('utc'::text, now()),
    deleted timestamp NULL DEFAULT NULL,
    type credit_type NOT NULL ,
    token_count INT4 NOT NULL,
    CONSTRAINT credit_account_id PRIMARY KEY (id),
    CONSTRAINT credit_account_user_fk FOREIGN KEY (user_id) REFERENCES "user" (id)
);
CREATE INDEX ix_credit_account_user_id ON credit_account (user_id);

CREATE TABLE credit_usage
(
    id SERIAL,
    user_id int4 NOT NULL,
    action_type VARCHAR NOT NULL ,
    created timestamp NULL DEFAULT timezone('utc'::text, now()),
    deleted timestamp NULL DEFAULT NULL,
    token_count INT4 NOT NULL,
    CONSTRAINT credit_usage_id PRIMARY KEY (id),
    CONSTRAINT credit_usage_user_fk FOREIGN KEY (user_id) REFERENCES "user" (id)
);
CREATE INDEX ix_credit_usage_user_id ON credit_usage (user_id);
