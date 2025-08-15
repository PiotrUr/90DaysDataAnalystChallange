/* === Dimensions ===================================================== */
CREATE TABLE dim_date (
  date_key       INT        NOT NULL PRIMARY KEY,     -- e.g., 20250131
  [date]         DATE       NOT NULL,
  [year]         SMALLINT   NOT NULL,
  [quarter]      TINYINT    NOT NULL,
  [month]        TINYINT    NOT NULL,
  day_of_month   TINYINT    NOT NULL,
  day_of_week    TINYINT    NOT NULL,
  is_workday     BIT        NOT NULL
);

CREATE TABLE dim_customer (
  customer_key      INT IDENTITY(1,1) PRIMARY KEY,    -- surrogate key
  customer_id_bk    NVARCHAR(50) NOT NULL,            -- business key from source
  name              NVARCHAR(200) NULL,
  city              NVARCHAR(100) NULL,
  segment           NVARCHAR(50)  NULL,
  valid_from        DATETIME2(0)  NOT NULL,           -- SCD2 period
  valid_to          DATETIME2(0)  NOT NULL,
  is_current        BIT           NOT NULL
);
CREATE UNIQUE INDEX UX_dim_customer_bk_hist
  ON dim_customer(customer_id_bk, valid_to) INCLUDE (is_current);

CREATE TABLE dim_product (
  product_key     INT IDENTITY(1,1) PRIMARY KEY,
  product_id_bk   NVARCHAR(50) NOT NULL,
  product_name    NVARCHAR(200) NOT NULL,
  category        NVARCHAR(100) NULL,
  brand           NVARCHAR(100) NULL,
  is_active       BIT NOT NULL
);
CREATE UNIQUE INDEX UX_dim_product_bk ON dim_product(product_id_bk);

CREATE TABLE dim_store (
  store_key      INT IDENTITY(1,1) PRIMARY KEY,
  store_code_bk  NVARCHAR(50) NOT NULL,
  city           NVARCHAR(100) NULL,
  region         NVARCHAR(100) NULL
);
CREATE UNIQUE INDEX UX_dim_store_bk ON dim_store(store_code_bk);

CREATE TABLE dim_payment_method (
  payment_method_key INT IDENTITY(1,1) PRIMARY KEY,
  method_code_bk     NVARCHAR(50) NOT NULL,
  method_name        NVARCHAR(100) NOT NULL
);
CREATE UNIQUE INDEX UX_dim_payment_bk ON dim_payment_method(method_code_bk);

/* === Fact =========================================================== */
CREATE TABLE fact_order_item (
  fact_id             BIGINT IDENTITY(1,1) PRIMARY KEY, -- narrow surrogate key
  order_id_bk         NVARCHAR(50) NOT NULL,            -- business key (header)
  order_item_nbr      INT          NOT NULL,            -- line number
  date_key            INT          NOT NULL,
  customer_key        INT          NOT NULL,
  product_key         INT          NOT NULL,
  store_key           INT          NULL,
  payment_method_key  INT          NULL,

  qty                 DECIMAL(18,4) NOT NULL,
  unit_price          DECIMAL(18,4) NOT NULL,
  discount_amount     DECIMAL(18,4) NOT NULL DEFAULT (0),
  tax_amount          DECIMAL(18,4) NOT NULL DEFAULT (0),
  total_amount        AS (qty * unit_price - discount_amount + tax_amount) PERSISTED
    -- computed column keeps storage minimal and ensures consistency
);

-- Foreign keys (enforce star integrity)
ALTER TABLE fact_order_item ADD CONSTRAINT FK_fact_date
  FOREIGN KEY (date_key) REFERENCES dim_date(date_key);
ALTER TABLE fact_order_item ADD CONSTRAINT FK_fact_customer
  FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key);
ALTER TABLE fact_order_item ADD CONSTRAINT FK_fact_product
  FOREIGN KEY (product_key) REFERENCES dim_product(product_key);
ALTER TABLE fact_order_item ADD CONSTRAINT FK_fact_store
  FOREIGN KEY (store_key) REFERENCES dim_store(store_key);
ALTER TABLE fact_order_item ADD CONSTRAINT FK_fact_payment
  FOREIGN KEY (payment_method_key) REFERENCES dim_payment_method(payment_method_key);

-- Performance helpers (typical for star joins)
CREATE INDEX IX_fact_order_item_date   ON fact_order_item(date_key);
CREATE INDEX IX_fact_order_item_cust   ON fact_order_item(customer_key);
CREATE INDEX IX_fact_order_item_prod   ON fact_order_item(product_key);
CREATE INDEX IX_fact_order_item_store  ON fact_order_item(store_key) INCLUDE (qty, total_amount);
CREATE INDEX IX_fact_order_item_bkline ON fact_order_item(order_id_bk, order_item_nbr);
