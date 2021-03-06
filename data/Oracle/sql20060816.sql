CREATE or REPLACE  PROCEDURE CptCapital_Update 
	(id_1 	            integer,
	mark_2              varchar2,
	name_3 	            varchar2,
	barcode_4 	        varchar2,
	startdate_1		    char,
	enddate_1		    char,
	seclevel_7 	        smallint,
	resourceid_1	    integer,
	sptcount_1 	        char,
	currencyid_11 	    integer,
	capitalcost_12 	    number,
	startprice_13 	    number,
	depreendprice_1     number,
	capitalspec_1	    varchar2,			
	capitallevel_1	    varchar2,			
	manufacturer_1	    varchar2,
	manudate_1		    char,			
	capitaltypeid_14 	integer,
	capitalgroupid_15 	integer,
	unitid_16 	        integer,
	replacecapitalid_18 integer,
	version_19 	        varchar2,
	location_1          varchar2,
	remark_21 	        varchar2,
	capitalimageid_22 	integer,
	depremethod1_23 	integer,
	depremethod2_24 	integer,
	deprestartdate_1	char,
	depreenddate_1		char,
	customerid_27 	    integer,
	attribute_28 	    smallint,
	datefield1_31 	    char,
	datefield2_32 	    char,
	datefield3_33 	    char,
	datefield4_34 	    char,
	datefield5_35 	    char,
	numberfield1_36 	float,
	numberfield2_37 	float,
	numberfield3_38 	float,
	numberfield4_39 	float,
	numberfield5_40 	float,
	textfield1_41 	    varchar2,
	textfield2_42 	    varchar2,
	textfield3_43 	    varchar2,
	textfield4_44 	    varchar2,
	textfield5_45 	    varchar2,
	tinyintfield1_46 	char,
	tinyintfield2_47 	char,
	tinyintfield3_48 	char,
	tinyintfield4_49 	char,
	tinyintfield5_50 	char,
	lastmoderid_51 	    integer,
	lastmoddate_52 	    char,
	lastmodtime_53 	    char,
	relatewfid_1		integer,
	alertnum_1          number,
	fnamark_1			varchar2,
	isinner_1			char,
	invoice_1			varchar2,
	StockInDate_1		char,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS

tempgroupid integer;
begin

/*更新资产组中的资产卡片数量信息*/
select capitalgroupid INTO tempgroupid from CptCapital where id=id_1;
if tempgroupid<>capitalgroupid_15 then
	update CptCapitalAssortment set capitalcount = capitalcount-1 where id=tempgroupid;
	update CptCapitalAssortment set capitalcount = capitalcount+1 where id=capitalgroupid_15;
end if;

UPDATE CptCapital 
SET  	 
    mark	 = mark_2,
    name	 = name_3,
    barcode	 = barcode_4,
    startdate = startdate_1,
    enddate	 = enddate_1,	
    seclevel	 = seclevel_7,
    resourceid = resourceid_1,
    sptcount	= sptcount_1,	
    currencyid	 = currencyid_11,
    capitalcost	 = capitalcost_12,
    startprice	 = startprice_13,
    depreendprice	= depreendprice_1,
    capitalspec	= capitalspec_1,
    capitallevel	= capitallevel_1,
    manufacturer	= manufacturer_1,
    manudate      = manudate_1,
    capitaltypeid	 = capitaltypeid_14,
    capitalgroupid	 = capitalgroupid_15,
    unitid	 = unitid_16,
    replacecapitalid = replacecapitalid_18,
    version	 = version_19,
    location	  = location_1,
    remark	 = remark_21,
    capitalimageid	 = capitalimageid_22,
    depremethod1	 = depremethod1_23,
    depremethod2	 = depremethod2_24,
    deprestartdate= deprestartdate_1,
    depreenddate  = depreenddate_1,
    customerid	 = customerid_27,
    attribute	 = attribute_28,
    datefield1	 = datefield1_31,
    datefield2	 = datefield2_32,
    datefield3	 = datefield3_33,
    datefield4	 = datefield4_34,
    datefield5	 = datefield5_35,
    numberfield1	 = numberfield1_36,
    numberfield2	 = numberfield2_37,
    numberfield3	 = numberfield3_38,
    numberfield4	 = numberfield4_39,
    numberfield5	 = numberfield5_40,
    textfield1	 = textfield1_41,
    textfield2	 = textfield2_42,
    textfield3	 = textfield3_43,
    textfield4	 = textfield4_44,
    textfield5	 = textfield5_45,
    tinyintfield1	 = tinyintfield1_46,
    tinyintfield2	 = tinyintfield2_47,
    tinyintfield3	 = tinyintfield3_48,
    tinyintfield4	 = tinyintfield4_49,
    tinyintfield5	 = tinyintfield5_50,
    lastmoderid	 = lastmoderid_51,
    lastmoddate	 = lastmoddate_52,
    lastmodtime	 = lastmodtime_53,
    relatewfid	= relatewfid_1,
    alertnum	 = alertnum_1,
    fnamark	= fnamark_1,
    isinner	= isinner_1,
	invoice	= invoice_1,
	StockInDate	= StockInDate_1
	 
WHERE 
	( id	 = id_1);
end;
/

insert into CptCapitalModifyField (field,name)
values (51,'发票号码')
/
insert into CptCapitalModifyField (field,name)
values (52,'购置日期')
/