-- 거래 유형 (수입/지출)
CREATE TYPE "transaction_type" AS ENUM (
	'income',
	'expense'
);

-- 계좌 유형 (카드, 현금, 은행, 대출)
CREATE TYPE "account_type" AS ENUM (
	'card',
	'cash',
	'bank',
	'loan'
);

-- 1. users (회원 정보) 테이블
CREATE TABLE IF NOT EXISTS "users" (
	"user_id" BIGSERIAL PRIMARY KEY,
	"email" VARCHAR(255) NOT NULL UNIQUE,
	"password_hash" VARCHAR(255) NOT NULL,
	"nickname" VARCHAR(50) NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE "users" IS '유저 정보';


-- 2. ledgers (가계부 컨테이너) 테이블
CREATE TABLE IF NOT EXISTS "ledgers" (
	"ledger_id" BIGSERIAL PRIMARY KEY,
	"owner_id" BIGINT NOT NULL REFERENCES users(user_id) ON DELETE NO ACTION,
	"name" VARCHAR(50) DEFAULT '나의 가계부',
	"currency" VARCHAR(3) DEFAULT 'KRW',
	"created_at" TIMESTAMP DEFAULT NOW(),
	"updated_at" TIMESTAMP DEFAULT NOW()
);
COMMENT ON TABLE "ledgers" IS '가계부 정보';


-- 3. accounts (가계부 별 계좌) 테이블
CREATE TABLE IF NOT EXISTS "accounts" (
	"account_id" BIGSERIAL PRIMARY KEY,
	"ledger_id" BIGINT NOT NULL REFERENCES ledgers(ledger_id) ON DELETE CASCADE,
	"user_id" BIGINT NOT NULL REFERENCES users(user_id) ON DELETE NO ACTION,
	"name" VARCHAR(255) NOT NULL,
	"type" account_type NOT NULL,
	"balance" BIGINT NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE "accounts" IS '가계부 별 계좌';


-- 4. categories (가계부 별 카테고리) 테이블
CREATE TABLE IF NOT EXISTS "categories" (
	"category_id" BIGSERIAL PRIMARY KEY,
	"ledger_id" BIGINT NOT NULL REFERENCES ledgers(ledger_id) ON DELETE CASCADE,
	"user_id" BIGINT NOT NULL REFERENCES users(user_id) ON DELETE NO ACTION,
	"name" VARCHAR(50) NOT NULL,
	"type" transaction_type NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE "categories" IS '가계부 별 카테고리';


-- 5. transactions (수입/지출) 테이블
CREATE TABLE IF NOT EXISTS "transactions" (
	"transaction_id" BIGSERIAL PRIMARY KEY,
	"ledger_id" BIGINT NOT NULL REFERENCES ledgers(ledger_id) ON DELETE CASCADE,
	"user_id" BIGINT NOT NULL REFERENCES users(user_id) ON DELETE NO ACTION,
	"account_id" BIGINT NOT NULL REFERENCES accounts(account_id)  ON DELETE CASCADE,
	"category_id" BIGINT NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
	"type" transaction_type NOT NULL,
	"amount" BIGINT NOT NULL DEFAULT 0, -- 원화 사용을 위한 BIGINT 타입 적용
	"action_date" DATE NOT NULL DEFAULT CURRENT_DATE,
	"memo" VARCHAR(255),
	"created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
	"updated_at" TIMESTAMP NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE "transactions" IS '수입/지출';


-- 6. ledger_members (공유 멤버십) 테이블 (추후 확장 대비)
-- * ledger_id와 user_id를 복합 PK로 설정하여 한 사용자가 한 가계부에 중복 가입 불가
CREATE TABLE IF NOT EXISTS "ledger_members" (
    "ledger_id" BIGINT NOT NULL REFERENCES ledgers(ledger_id) ON DELETE CASCADE,
    "user_id" BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    "joined_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY ("ledger_id", "user_id")
);
COMMENT ON TABLE "ledger_members" IS '가계부 공유 멤버 목록 (추후 확장용)';