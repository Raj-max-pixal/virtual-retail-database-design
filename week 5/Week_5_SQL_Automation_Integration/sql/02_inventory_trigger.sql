-- PostgreSQL trigger: prevent stock from becoming negative.
-- This is a safety guard. The inventory deduction procedure is still responsible
-- for applying the business operation.

CREATE OR REPLACE FUNCTION prevent_negative_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.stock_quantity < 0 THEN
        RAISE EXCEPTION 'stock_quantity cannot be negative for product_id %',
            NEW.product_id;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_prevent_negative_stock ON products;

CREATE TRIGGER trg_prevent_negative_stock
BEFORE INSERT OR UPDATE OF stock_quantity
ON products
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_stock();
