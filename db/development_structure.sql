CREATE TABLE "accounts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "ancestry" varchar(255), "name" varchar(255), "created_at" datetime, "updated_at" datetime, "type" varchar(255));
CREATE TABLE "contacts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "self" boolean DEFAULT 'f', "name" varchar(255), "contact_name" varchar(255), "address" text, "city" varchar(255), "state" varchar(255), "postal_code" varchar(255), "country" varchar(255), "country_code" varchar(2), "tax_number" varchar(255), "created_at" datetime, "updated_at" datetime, "email" varchar(255), "phone_number" varchar(255));
CREATE TABLE "delayed_jobs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "priority" integer DEFAULT 0, "attempts" integer DEFAULT 0, "handler" text, "last_error" text, "run_at" datetime, "locked_at" datetime, "failed_at" datetime, "locked_by" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "exchange_rates" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "currency" varchar(255), "rate" decimal(20,4), "recorded_on" date);
CREATE TABLE "imports" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_id" integer, "file_name" varchar(255), "message" varchar(255), "status" varchar(255), "created_at" datetime, "updated_at" datetime, "mapping_id" integer, "ending_balance" decimal(20,4));
CREATE TABLE "ledger_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "sender_id" integer, "recipient_id" integer, "transacted_on" date, "total_amount" decimal, "tax_amount" decimal DEFAULT 0.0, "currency" varchar(3) NOT NULL, "description" varchar(255), "account_id" integer, "match_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "mappings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "currency" varchar(3), "date_row" integer, "total_amount_row" integer, "tax_amount_row" integer, "description_row" integer, "second_description_row" integer, "has_title_row" boolean, "day_follows_month" boolean, "reverses_sign" boolean, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "matches" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "people" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "is_self" boolean DEFAULT 'f', "name" varchar(255), "contact_name" varchar(255), "address" text, "city" varchar(255), "state" varchar(255), "postal_code" varchar(255), "country" varchar(255), "country_code" varchar(2), "tax_number" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "rules" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "new_sender_id" integer, "new_recipient_id" integer, "account_id" integer, "new_account_id" integer, "matched_description" varchar(255), "matched_debit" boolean, "created_at" datetime, "updated_at" datetime, "matched_sender_id" integer, "matched_recipient_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" varchar(255) NOT NULL, "data" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "transactions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "sender_id" integer, "recipient_id" integer, "issued_on" date, "total_amount" decimal(20,4), "tax_amount" decimal(20,4), "currency" varchar(3) NOT NULL, "description" varchar(255), "identifier" varchar(255), "account_id" integer, "match_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(255) NOT NULL, "email" varchar(255) NOT NULL, "crypted_password" varchar(255) NOT NULL, "password_salt" varchar(255) NOT NULL, "persistence_token" varchar(255) NOT NULL, "single_access_token" varchar(255) NOT NULL, "perishable_token" varchar(255) NOT NULL, "login_count" integer DEFAULT 0 NOT NULL, "failed_login_count" integer DEFAULT 0 NOT NULL, "current_login_at" datetime, "last_login_at" datetime, "current_login_ip" varchar(255), "last_login_ip" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_accounts_on_ancestry" ON "accounts" ("ancestry");
CREATE INDEX "index_accounts_on_type" ON "accounts" ("type");
CREATE INDEX "index_exchange_rates_on_currency" ON "exchange_rates" ("currency");
CREATE INDEX "index_exchange_rates_on_recorded_on" ON "exchange_rates" ("recorded_on");
CREATE INDEX "index_ledger_items_on_account_id" ON "ledger_items" ("account_id");
CREATE INDEX "index_ledger_items_on_recipient_id" ON "ledger_items" ("recipient_id");
CREATE INDEX "index_ledger_items_on_sender_id" ON "ledger_items" ("sender_id");
CREATE INDEX "index_ledger_items_on_total_amount" ON "ledger_items" ("total_amount");
CREATE INDEX "index_ledger_items_on_transacted_on" ON "ledger_items" ("transacted_on");
CREATE INDEX "index_sessions_on_session_id" ON "sessions" ("session_id");
CREATE INDEX "index_sessions_on_updated_at" ON "sessions" ("updated_at");
CREATE INDEX "index_transactions_on_account_id" ON "transactions" ("account_id");
CREATE INDEX "index_transactions_on_identifier" ON "transactions" ("identifier");
CREATE INDEX "index_transactions_on_issued_on" ON "transactions" ("issued_on");
CREATE INDEX "index_transactions_on_recipient_id" ON "transactions" ("recipient_id");
CREATE INDEX "index_transactions_on_sender_id" ON "transactions" ("sender_id");
CREATE INDEX "index_transactions_on_total_amount" ON "transactions" ("total_amount");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20100329113324');

INSERT INTO schema_migrations (version) VALUES ('20091006134353');

INSERT INTO schema_migrations (version) VALUES ('20091021153918');

INSERT INTO schema_migrations (version) VALUES ('20091022121318');

INSERT INTO schema_migrations (version) VALUES ('20091022152641');

INSERT INTO schema_migrations (version) VALUES ('20091025165424');

INSERT INTO schema_migrations (version) VALUES ('20091025165557');

INSERT INTO schema_migrations (version) VALUES ('20091025191438');

INSERT INTO schema_migrations (version) VALUES ('20091027094008');

INSERT INTO schema_migrations (version) VALUES ('20091116111536');

INSERT INTO schema_migrations (version) VALUES ('20091120174124');

INSERT INTO schema_migrations (version) VALUES ('20091203123815');

INSERT INTO schema_migrations (version) VALUES ('20091206014351');

INSERT INTO schema_migrations (version) VALUES ('20091218154431');

INSERT INTO schema_migrations (version) VALUES ('20091221171832');

INSERT INTO schema_migrations (version) VALUES ('20091224002832');

INSERT INTO schema_migrations (version) VALUES ('20100205150120');

INSERT INTO schema_migrations (version) VALUES ('20100329091654');

INSERT INTO schema_migrations (version) VALUES ('20100329105341');