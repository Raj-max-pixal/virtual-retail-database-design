-- PostgreSQL stored procedure: adjust inventory after a sale.
-- Expected schema: products(product_id, stock_quantity), order_items(order_id, product_id, quantity).
-- Call this procedure only after the corresponding order_items rows have been created.
-- This procedure demonstrates a controlled inventory deduction; production systems should
-- ensure it is called exactly once per order and protected against duplicate processing.

CREATE OR REPLACE PROCEDURE deduct_inventory_for_order(p_order_id BIGINT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_item RECORD;
BEGIN
    IF p_order_id IS NULL THEN
        RAISE EXCEPTION 'Order ID cannot be NULL';
    END IF;

    -- Lock product rows in deterministic order to reduce the risk of deadlocks.
    FOR v_item IN
        SELECT product_id, SUM(quantity)::INTEGER AS total_quantity
        FROM order_items
        WHERE order_id = p_order_id
        GROUP BY product_id
        ORDER BY product_id
    LOOP
        UPDATE products
        SET stock_quantity = stock_quantity - v_item.total_quantity
        WHERE product_id = v_item.product_id
          AND stock_quantity >= v_item.total_quantity;

        IF NOT FOUND THEN
            RAISE EXCEPTION
                'Insufficient stock or unknown product_id % for order_id %',
                v_item.product_id, p_order_id;
        END IF;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Re-raise the error so the caller can roll back the transaction.
        RAISE;
END;
$$;

-- Example usage (run in a transaction after order_items are inserted):
-- BEGIN;
-- CALL deduct_inventory_for_order(1001);
-- COMMIT;
-- If CALL fails, issue ROLLBACK in the client/transaction.
