--Hands On Assignment Part 1
--Assignment 9-1
SELECT sysdate, 'Thalia Edwards' FROM dual;

--create trigger create a product request when stock level falls below reorder level
CREATE OR REPLACE TRIGGER bb_reorder_trg
   AFTER UPDATE OF stock ON bb_product
   FOR EACH ROW 
DECLARE
  v_onorder_num NUMBER(4);
 BEGIN
  If :NEW.stock <= :NEW.reorder THEN
   SELECT SUM(qty)
    INTO v_onorder_num
    FROM bb_product_request
    WHERE idProduct = :NEW.idProduct
     AND dtRecd IS NULL;
   IF v_onorder_num IS NULL THEN v_onorder_num := 0; END IF;
   IF v_onorder_num = 0 THEN
     INSERT INTO bb_product_request (idRequest, idProduct, dtRequest, qty)
       VALUES (bb_prodreq_seq.NEXTVAL, :NEW.idProduct, SYSDATE, :NEW.reorder);
   END IF;
  END IF;
END;
/
--test the trigger
SELECT stock, reorder
FROM bb_product
WHERE idproduct = 4;
--------------------
UPDATE bb_product
SET stock = 25
WHERE idproduct = 4;
--------------------
SELECT * FROM bb_product_request;
ROLLBACK; --undo statements for reusing original data

--Assignment 9-2
SELECT sysdate, 'Thalia Edwards' FROM dual;

INSERT INTO bb_product_request (idRequest, idProduct, dtRequest, qty)
VALUES (3, 5, SYSDATE, 45);
COMMIT;
--delete from bb_product_request where idproduct = 5;

CREATE OR REPLACE TRIGGER bb_reqfill_trg
    AFTER UPDATE OF dtRecd ON bb_product_request
    FOR EACH ROW
BEGIN
    UPDATE bb_product
    SET stock = stock + :NEW.qty
    WHERE idProduct = :NEW.idProduct;
END;
/
--test the trigger
UPDATE bb_product_request
SET dtRecd = SYSDATE, cost = 225
WHERE idRequest = 3;

SELECT stock, reorder
FROM bb_product
WHERE idproduct = 5;

SELECT *
FROM bb_product_request
WHERE idproduct = 5;

ROLLBACK;
ALTER TRIGGER bb_reqfill_trg DISABLE;

/* Assignment 9-3
*/
SELECT sysdate, 'Thalia Edwards' FROM dual;

ALTER TRIGGER bb_reqfill_trg ENABLE;

CREATE OR REPLACE TRIGGER bb_reqfill_trg
    AFTER UPDATE OF dtRecd ON bb_product_request
    FOR EACH ROW
BEGIN
    IF :OLD.dtRecd IS NOT NULL AND :NEW.dtRecd IS NULL THEN
        UPDATE bb_product
        SET stock = stock - :NEW.qty
        WHERE idProduct = :NEW.idProduct;
        RETURN;
    ELSIF :OLD.dtRecd IS NULL AND :NEW.dtRecd IS NOT NULL THEN
        UPDATE bb_product
        SET stock = stock + :NEW.qty
        WHERE idProduct = :NEW.idProduct;
    END IF;
END;
/

INSERT INTO bb_product_request (idRequest, idProduct, dtRequest, qty,
dtRecd, cost)
VALUES (4, 5, SYSDATE, 45, '15-JUN-2012',225);

UPDATE bb_product
SET stock = 86
WHERE idProduct = 5;
COMMIT;

UPDATE bb_product_request
SET dtRecd = NULL
WHERE idRequest = 4;

SELECT stock, reorder
FROM bb_product
WHERE idproduct = 5;

SELECT * 
FROM bb_product_request
WHERE idproduct = 5;

ALTER TRIGGER bb_reqfill_trg DISABLE;