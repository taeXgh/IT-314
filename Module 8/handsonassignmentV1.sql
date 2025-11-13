--problem 1
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT DISTINCT idProduct, p.productname
    FROM bb_shopper s 
    INNER JOIN bb_basket b
        USING (idShopper)
    INNER JOIN bb_basketitem bi
        USING (idBasket)
    INNER JOIN bb_product p
        USING (idProduct)
    WHERE orderplaced = 1;

--problem 2
--ANSI JOIN
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT idBasket, idProduct, productname, description
    FROM bb_shopper s 
    INNER JOIN bb_basket b
        USING (idShopper)
    INNER JOIN bb_basketitem bi
        USING (idBasket)
    INNER JOIN bb_product p
        USING (idProduct)
    WHERE orderplaced = 1;

--Traditional JOIN
SELECT b.idBasket, p.idProduct, productname, description
    FROM bb_shopper s, bb_basket b, bb_basketitem bi, bb_product p
    WHERE s.idShopper = b.idShopper
        AND b.idBasket = bi.idBasket
        AND bi.idProduct = p.idProduct
        AND orderplaced = 1;

--problem 3
SELECT sysdate, 'Thalia Edwards' FROM dual;
--ANSI JOIN
SELECT lastname, idBasket, idProduct, productname, description
    FROM bb_shopper s 
    INNER JOIN bb_basket b
        USING (idShopper)
    INNER JOIN bb_basketitem bi
        USING (idBasket)
    INNER JOIN bb_product p
        USING (idProduct)
    WHERE orderplaced = 1;
--Traditional JOIN
SELECT s.lastname, b.idBasket, p.idProduct, productname, description
    FROM bb_shopper s, bb_basket b, bb_basketitem bi, bb_product p
    WHERE s.idShopper = b.idShopper
        AND b.idBasket = bi.idBasket
        AND bi.idProduct = p.idProduct
        AND orderplaced = 1;

--problem 4
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT idBasket, idShopper,TO_CHAR(dtordered, 'Month DD, YYYY') AS dateordered
   FROM bb_shopper
   INNER JOIN bb_basket
      USING (idShopper)
   WHERE dtordered = TO_DATE('February 12, 2012', 'Month DD, YYYY');

--problem 5
SELECT sysdate, 'Thalia Edwards' FROM dual;
SELECT idProduct, b.quantity
   FROM bb_shopper s 
    INNER JOIN bb_basket b
        USING (idShopper)
    INNER JOIN bb_basketitem bi
        USING (idBasket)
    INNER JOIN bb_product p
        USING (idProduct)
    WHERE orderplaced = 1;