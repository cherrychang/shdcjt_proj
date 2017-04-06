alter table CptSearchMould add stockindate char
/
alter table CptSearchMould add stockindate1 char
/

CREATE OR REPLACE PROCEDURE CptSearchMould_Insert (
 mouldname_1 	varchar2,
 userid_2 	integer,
 mark_3 	varchar2,
 name_4 	varchar2,
 startdate_5 	char,
 startdate1_6 	char,
 enddate_7 	char,
 enddate1_8 	char,
 seclevel_9 	smallint,
 seclevel1_10 	smallint,
 departmentid_11 	integer,
 costcenterid_12 	integer,
 resourceid_13 	integer,
 currencyid_14 	integer,
 capitalcost_15 	varchar2,
 capitalcost1_16 	varchar2,
 startprice_17 	varchar2,
 startprice1_18 	varchar2,
 depreendprice_19 	varchar2,
 depreendprice1_20 	varchar2,
 capitalspec_21 	varchar2,
 capitallevel_22 	varchar2,
 manufacturer_23 	varchar2,
 manudate_24 	char,
 manudate1_25 	char,
 capitaltypeid_26 	integer,
 capitalgroupid_27 	integer,
 unitid_28 	integer,
 capitalnum_29 	varchar2,
 capitalnum1_30 	varchar2,
 currentnum_31 	varchar2,
 currentnum1_32 	varchar2,
 replacecapitalid_33 	integer,
 version_34 	varchar2,
 itemid_35 	integer,
 depremethod1_36 	integer,
 depremethod2_37 	integer,
 deprestartdate_38 	char,
 deprestartdate1_39 	char,
 depreenddate_40 	char,
 depreenddate1_41 	char,
 customerid_42 	integer,
 attribute_43 	char,
 stateid_44 	integer,
 location_45 	varchar2,
 isdata		char,
 stockindate_46 char,
 stockindate1_47 char,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  as 
 
 begin 
 insert into CptSearchMould ( 
 mouldname,
 userid,
 mark,
 name,
 startdate,
 startdate1,
 enddate,
 enddate1,
 seclevel,
 seclevel1,
 departmentid,
 costcenterid,
 resourceid,
 currencyid,
 capitalcost,
 capitalcost1,
 startprice,
 startprice1,
 depreendprice,
 depreendprice1,
 capitalspec,
 capitallevel,
 manufacturer,
 manudate,
 manudate1,
 capitaltypeid,
 capitalgroupid,
 unitid,
 capitalnum,
 capitalnum1,
 currentnum,
 currentnum1,
 replacecapitalid,
 version,
 itemid,
 depremethod1,
 depremethod2,
 deprestartdate,
 deprestartdate1,
 depreenddate,
 depreenddate1,
 customerid,
 attribute,
 stateid,
 location,
 isdata,
 stockindate,
 stockindate1)  
 
 VALUES ( 
 mouldname_1,
 userid_2,
 mark_3,
 name_4,
 startdate_5,
 startdate1_6,
 enddate_7,
 enddate1_8,
 seclevel_9,
 seclevel1_10,
 departmentid_11,
 costcenterid_12,
 resourceid_13,
 currencyid_14,
 capitalcost_15,
 capitalcost1_16,
 startprice_17,
 startprice1_18,
 depreendprice_19,
 depreendprice1_20,
 capitalspec_21,
 capitallevel_22,
 manufacturer_23,
 manudate_24,
 manudate1_25,
 capitaltypeid_26,
 capitalgroupid_27,
 unitid_28,
 capitalnum_29,
 capitalnum1_30,
 currentnum_31,
 currentnum1_32,
 replacecapitalid_33,
 version_34,
 itemid_35,
 depremethod1_36,
 depremethod2_37,
 deprestartdate_38,
 deprestartdate1_39,
 depreenddate_40,
 depreenddate1_41,
 customerid_42,
 attribute_43,
 stateid_44,
 location_45,
 isdata,
 stockindate_46,
 stockindate1_47); 
 
 open thecursor for 
    select max(id) from CptSearchMould; 
 end;
/


CREATE OR REPLACE PROCEDURE CptSearchMould_Update (
 id_1 	integer,
 userid_2 	integer,
 mark_3 	varchar2,
 name_4 	varchar2,
 startdate_5 	char,
 startdate1_6 	char,
 enddate_7 	char,
 enddate1_8 	char,
 seclevel_9 	smallint,
 seclevel1_10 	smallint,
 departmentid_11 	integer,
 costcenterid_12 	integer,
 resourceid_13 	integer,
 currencyid_14 	integer,
 capitalcost_15 	varchar2,
 capitalcost1_16 	varchar2,
 startprice_17 	varchar2,
 startprice1_18 	varchar2,
 depreendprice_19 	varchar2,
 depreendprice1_20 	varchar2,
 capitalspec_21 	varchar2,
 capitallevel_22 	varchar2,
 manufacturer_23 	varchar2,
 manudate_24 	char,
 manudate1_25 	char,
 capitaltypeid_26 	integer,
 capitalgroupid_27 	integer,
 unitid_28 	integer,
 capitalnum_29 	varchar2,
 capitalnum1_30 	varchar2,
 currentnum_31 	varchar2,
 currentnum1_32 	varchar2,
 replacecapitalid_33 	integer,
 version_34 	varchar2,
 itemid_35 	integer,
 depremethod1_36 	integer,
 depremethod2_37 	integer,
 deprestartdate_38 	char,
 deprestartdate1_39 	char,
 depreenddate_40 	char,
 depreenddate1_41 	char,
 customerid_42 	integer,
 attribute_43 	char,
 stateid_44 	integer,
 location_45 	varchar2,
 isdata_1		char,
 stockindate_46	char,
 stockindate1_47	char,
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  as 
 begin 
 update CptSearchMould  
 SET  
 userid=userid_2,
 mark=mark_3,
 name=name_4,
 startdate=startdate_5,
 startdate1=startdate1_6,
 enddate=enddate_7,
 enddate1=enddate1_8,
 seclevel=seclevel_9,
 seclevel1=seclevel1_10,
 departmentid=departmentid_11,
 costcenterid=costcenterid_12,
 resourceid=resourceid_13,
 currencyid=currencyid_14,
 capitalcost=capitalcost_15,
 capitalcost1=capitalcost1_16,
 startprice=startprice_17,
 startprice1=startprice1_18,
 depreendprice=depreendprice_19,
 depreendprice1=depreendprice1_20,
 capitalspec=capitalspec_21,
 capitallevel=capitallevel_22,
 manufacturer=manufacturer_23,
 manudate=manudate_24,
 manudate1=manudate1_25,
 capitaltypeid=capitaltypeid_26,
 capitalgroupid=capitalgroupid_27,
 unitid=unitid_28,
 capitalnum=capitalnum_29,
 capitalnum1=capitalnum1_30,
 currentnum=currentnum_31,
 currentnum1=currentnum1_32,
 replacecapitalid=replacecapitalid_33,
 version=version_34,
 itemid=itemid_35,
 depremethod1=depremethod1_36,
 depremethod2=depremethod2_37,
 deprestartdate=deprestartdate_38,
 deprestartdate1=deprestartdate1_39,
 depreenddate=depreenddate_40,
 depreenddate1=depreenddate1_41,
 customerid=customerid_42,
 attribute=attribute_43,
 stateid=stateid_44,
 location=location_45 ,
 isdata		= isdata_1,
 stockindate =stockindate_46,
 stockindate1 =stockindate1_47  
 WHERE ( id=id_1); 
 end;
/
