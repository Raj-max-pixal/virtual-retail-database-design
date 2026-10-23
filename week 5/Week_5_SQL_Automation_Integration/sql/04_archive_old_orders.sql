-- Example archive table and procedure.
-- Define the retention policy with the business/data-protection owner before use.
-- This example archives completed orders older than a supplied cutoff date.
-- Order items are not archived here; production archiving must preserve related data
-- and foreign-key integrity using a tested multi-table strategy.

CREATE TABLE IF NOT EXISTS archived_orders (
    order_id BIGINT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    archived_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE PROCEDURE archive_completed_orders(p_cutoff TIMESTAMP)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_cutoff IS NULL THEN
        RAISE EXCEPTION 'Cutoff timestamp cannot be NULL';
    END IF;

    INSERT INTO archived_orders (
        order_id, customer_id, order_date, status, total_amount
    )
    SELECT o.order_id, o.customer_id, o.order_date, o.status, o.total_amount
    FROM orders o
    WHERE o.status = 'Completed'
      AND o.order_date < p_cutoff
    ON CONFLICT (order_id) DO NOTHING;

    -- Deliberately does not delete source rows. Review archive completeness,
    -- dependencies, retention policy, and recovery procedure before deletion.
END;
$$;

-- Example:
-- CALL archive_completed_orders(TIMESTAMP '2025-01-01 00:00:00');
