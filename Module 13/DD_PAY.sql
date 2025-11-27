CREATE OR REPLACE FUNCTION dd_paydate1_sf
  (p_id IN dd_pledge.idpledge%TYPE)
  RETURN DATE
  IS
  lv_pl_dat DATE;
  lv_mth_txt VARCHAR2(2);
  lv_yr_txt VARCHAR2(4);
BEGIN
  SELECT ADD_MONTHS(pledgedate,1)
    INTO lv_pl_dat
    FROM dd_pledge
    WHERE idpledge = p_id;
  lv_mth_txt := TO_CHAR(lv_pl_dat,'mm');
  lv_yr_txt := TO_CHAR(lv_pl_dat,'yyyy');
  RETURN TO_DATE((lv_mth_txt || '-01-' || lv_yr_txt),'mm-dd-yyyy');
END;

CREATE OR REPLACE FUNCTION dd_payend_sf
  (p_id IN dd_pledge.idpledge%TYPE)
  RETURN DATE
  IS
  lv_pay1_dat DATE;
  lv_mths_num dd_pledge.paymonths%TYPE;
BEGIN
  SELECT dd_paydate1_sf(idpledge), paymonths - 1
    INTO lv_pay1_dat, lv_mths_num
    FROM dd_pledge
    WHERE idpledge = p_id;
  IF lv_mths_num = 0 THEN
     RETURN lv_pay1_dat;
  ELSE
     RETURN ADD_MONTHS(lv_pay1_dat, lv_mths_num);
  END IF;
END;

