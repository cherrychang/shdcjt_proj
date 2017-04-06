ALTER table  HrmUserDefine  ADD hasaccounttype char(1)
/


ALTER table  HrmSearchMould  ADD accounttype integer
/

CREATE or REPLACE PROCEDURE HrmSearchMould_Insert
	(mouldname_1 	varchar2,
	 userid_2 	integer,
	 resourceid_3 	integer,
	 resourcename_4 	varchar2,
	 jobtitle_5 	integer,
	 activitydesc_6 	varchar2,
	 jobgroup_7 	integer,
	 jobactivity_8 	integer,
	 costcenter_9 	integer,
	 competency_10 	integer,
	 resourcetype_11 	char,
	 status_12 	char,
	 subcompany1_13 	integer,
	 department_14 	varchar2,
	 location_15 	integer,
	 manager_16 	integer,
	 assistant_17 	integer,
	 roles_18 	integer,
	 seclevel_19 	smallint,
	 joblevel_20 	smallint,
	 workroom_21 	varchar2,
	 telephone_22 	varchar2,
	 startdate_23 	char,
	 enddate_24 	char,
	 contractdate_25 	char,
	 birthday_26 	char,
	 sex_27 	char,
	 seclevelTo_28 	smallint,
	 joblevelTo_29 	smallint,
	 startdateTo_30 	char,
	 enddateTo_31 	char,
	 contractdateTo_32 	char,
	 birthdayTo_33 	char,
	 age_34 	integer,
	 ageTo_35 	integer,
	 resourceidfrom_36 	integer,
	 resourceidto_37 	integer,
	 workcode_38 	varchar2,
	 jobcall_39 	integer,
	 mobile_40 	varchar2,
	 mobilecall_41 	varchar2,
	 fax_42 	varchar2,
	 email_43 	varchar2,
	 folk_44 	varchar2,
	 nativeplace_45 	varchar2,
	 regresidentplace_46 	varchar2,
	 maritalstatus_47 	char,
	 certificatenum_48 	varchar2,
	 tempresidentnumber_49 	varchar2,
	 residentplace_50 	varchar2,
	 homeaddress_51 	varchar2,
	 healthinfo_52 	char,
	 heightfrom_53 	integer,
	 heightto_54 	integer,
	 weightfrom_55 	integer,
	 weightto_56 	integer,
	 educationlevel_57 	char,
	 degree_58 	varchar2,
	 usekind_59 	integer,
	 policy_60 	varchar2,
	 bememberdatefrom_61 	char,
	 bememberdateto_62 	char,
	 bepartydatefrom_63 	char,
	 bepartydateto_64 	char,
	 islabouunion_65 	char,
	 bankid1_66 	integer,
	 accountid1_67 	varchar2,
	 accumfundaccount_68 	varchar2,
	 loginid_69 	varchar2,
	 systemlanguage_70 	integer,
	 birthdayyear_71   integer,
	 birthdaymonth_72  integer,
	 birthdayday_73    integer,
	 educationlevelto_74   integer,
     accounttype_75   integer,
	 flag out integer ,
	 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS
begin
INSERT INTO HrmSearchMould 
	 ( mouldname,
	 userid,
	 resourceid,
	 resourcename,
	 jobtitle,
	 activitydesc,
	 jobgroup,
	 jobactivity,
	 costcenter,
	 competency,
	 resourcetype,
	 status,
	 subcompany1,
	 department,
	 location,
	 manager,
	 assistant,
	 roles,
	 seclevel,
	 joblevel,
	 workroom,
	 telephone,
	 startdate,
	 enddate,
	 contractdate,
	 birthday,
	 sex,
	 seclevelTo,
	 joblevelTo,
	 startdateTo,
	 enddateTo,
	 contractdateTo,
	 birthdayTo,
	 age,
	 ageTo,
	 resourceidfrom,
	 resourceidto,
	 workcode,
	 jobcall,
	 mobile,
	 mobilecall,
	 fax,
	 email,
	 folk,
	 nativeplace,
	 regresidentplace,
	 maritalstatus,
	 certificatenum,
	 tempresidentnumber,
	 residentplace,
	 homeaddress,
	 healthinfo,
	 heightfrom,
	 heightto,
	 weightfrom,
	 weightto,
	 educationlevel,
	 degree,
	 usekind,
	 policy,
	 bememberdatefrom,
	 bememberdateto,
	 bepartydatefrom,
	 bepartydateto,
	 islabouunion,
	 bankid1,
	 accountid1,
	 accumfundaccount,
	 loginid,
	 systemlanguage,
	 birthdayyear,
	 birthdaymonth,
	 birthdayday,
	 educationlevelto,
	 accounttype) 
 
VALUES 
	( mouldname_1,
	 userid_2,
	 resourceid_3,
	 resourcename_4,
	 jobtitle_5,
	 activitydesc_6,
	 jobgroup_7,
	 jobactivity_8,
	 costcenter_9,
	 competency_10,
	 resourcetype_11,
	 status_12,
	 subcompany1_13,
	 department_14,
	 location_15,
	 manager_16,
	 assistant_17,
	 roles_18,
	 seclevel_19,
	 joblevel_20,
	 workroom_21,
	 telephone_22,
	 startdate_23,
	 enddate_24,
	 contractdate_25,
	 birthday_26,
	 sex_27,
	 seclevelTo_28,
	 joblevelTo_29,
	 startdateTo_30,
	 enddateTo_31,
	 contractdateTo_32,
	 birthdayTo_33,
	 age_34,
	 ageTo_35,
	 resourceidfrom_36,
	 resourceidto_37,
	 workcode_38,
	 jobcall_39,
	 mobile_40,
	 mobilecall_41,
	 fax_42,
	 email_43,
	 folk_44,
	 nativeplace_45,
	 regresidentplace_46,
	 maritalstatus_47,
	 certificatenum_48,
	 tempresidentnumber_49,
	 residentplace_50,
	 homeaddress_51,
	 healthinfo_52,
	 heightfrom_53,
	 heightto_54,
	 weightfrom_55,
	 weightto_56,
	 educationlevel_57,
	 degree_58,
	 usekind_59,
	 policy_60,
	 bememberdatefrom_61,
	 bememberdateto_62,
	 bepartydatefrom_63,
	 bepartydateto_64,
	 islabouunion_65,
	 bankid1_66,
	 accountid1_67,
	 accumfundaccount_68,
	 loginid_69,
	 systemlanguage_70,
	 birthdayyear_71,
	 birthdaymonth_72,
	 birthdayday_73,
	 educationlevelto_74,
	 accounttype_75
     );
open thecursor for 
select max(id) from HrmSearchMould;
end;
/

CREATE or REPLACE PROCEDURE HrmSearchMould_Update
	(id_1 	integer,
	 userid_2 	integer,
	 resourceid_3 	integer,
	 resourcename_4 	varchar2,
	 jobtitle_5 	integer,
	 activitydesc_6 	varchar2,
	 jobgroup_7 	integer,
	 jobactivity_8 	integer,
	 costcenter_9 	integer,
	 competency_10 	integer,
	 resourcetype_11 	char,
	 status_12 	char,
	 subcompany1_13 	integer,
	 department_14 	varchar2,
	 location_15 	integer,
	 manager_16 	integer,
	 assistant_17 	integer,
	 roles_18 	integer,
	 seclevel_19 	smallint,
	 joblevel_20 	smallint,
	 workroom_21 	varchar2,
	 telephone_22 	varchar2,
	 startdate_23 	char,
	 enddate_24 	char,
	 contractdate_25 	char,
	 birthday_26 	char,
	 sex_27 	char,
	 seclevelTo_28 	smallint,
	 joblevelTo_29 	smallint,
	 startdateTo_30 	char,
	 enddateTo_31 	char,
	 contractdateTo_32 	char,
	 birthdayTo_33 	char,
	 age_34 	integer,
	 ageTo_35 	integer,
	 resourceidfrom_36 	integer,
	 resourceidto_37 	integer,
	 workcode_38 	varchar2,
	 jobcall_39 	integer,
	 mobile_40 	varchar2,
	 mobilecall_41 	varchar2,
	 fax_42 	varchar2,
	 email_43 	varchar2,
	 folk_44 	varchar2,
	 nativeplace_45 	varchar2,
	 regresidentplace_46 	varchar2,
	 maritalstatus_47 	char,
	 certificatenum_48 	varchar2,
	 tempresidentnumber_49 	varchar2,
	 residentplace_50 	varchar2,
	 homeaddress_51 	varchar2,
	 healthinfo_52 	char,
	 heightfrom_53 	integer,
	 heightto_54 	integer,
	 weightfrom_55 	integer,
	 weightto_56 	integer,
	 educationlevel_57 	char,
	 degree_58 	varchar2,
	 usekind_59 	integer,
	 policy_60 	varchar2,
	 bememberdatefrom_61 	char,
	 bememberdateto_62 	char,
	 bepartydatefrom_63 	char,
	 bepartydateto_64 	char,
	 islabouunion_65 	char,
	 bankid1_66 	integer,
	 accountid1_67 	varchar2,
	 accumfundaccount_68 	varchar2,
	 loginid_69 	varchar2,
	 systemlanguage_70 	integer,
	 birthdayyear_71   integer,
	 birthdaymonth_72  integer,
	 birthdayday_73    integer,
	 educationlevelto_74   integer,
 	 accounttype_75    integer,
	 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 
begin
UPDATE HrmSearchMould 
SET      userid	 = userid_2,
	 resourceid	 = resourceid_3,
	 resourcename	 = resourcename_4,
	 jobtitle	 = jobtitle_5,
	 activitydesc	 = activitydesc_6,
	 jobgroup	 = jobgroup_7,
	 jobactivity	 = jobactivity_8,
	 costcenter	 = costcenter_9,
	 competency	 = competency_10,
	 resourcetype	 = resourcetype_11,
	 status	 = status_12,
	 subcompany1	 = subcompany1_13,
	 department	 = department_14,
	 location	 = location_15,
	 manager	 = manager_16,
	 assistant	 = assistant_17,
	 roles	 = roles_18,
	 seclevel	 = seclevel_19,
	 joblevel	 = joblevel_20,
	 workroom	 = workroom_21,
	 telephone	 = telephone_22,
	 startdate	 = startdate_23,
	 enddate	 = enddate_24,
	 contractdate	 = contractdate_25,
	 birthday	 = birthday_26,
	 sex	 = sex_27,
	 seclevelTo	 = seclevelTo_28,
	 joblevelTo	 = joblevelTo_29,
	 startdateTo	 = startdateTo_30,
	 enddateTo	 = enddateTo_31,
	 contractdateTo	 = contractdateTo_32,
	 birthdayTo	 = birthdayTo_33,
	 age	 = age_34,
	 ageTo	 = ageTo_35,
	 resourceidfrom	 = resourceidfrom_36,
	 resourceidto	 = resourceidto_37,
	 workcode	 = workcode_38,
	 jobcall	 = jobcall_39,
	 mobile	 = mobile_40,
	 mobilecall	 = mobilecall_41,
	 fax	 = fax_42,
	 email	 = email_43,
	 folk	 = folk_44,
	 nativeplace	 = nativeplace_45,
	 regresidentplace	 = regresidentplace_46,
	 maritalstatus	 = maritalstatus_47,
	 certificatenum	 = certificatenum_48,
	 tempresidentnumber	 = tempresidentnumber_49,
	 residentplace	 = residentplace_50,
	 homeaddress	 = homeaddress_51,
	 healthinfo	 = healthinfo_52,
	 heightfrom	 = heightfrom_53,
	 heightto	 = heightto_54,
	 weightfrom	 = weightfrom_55,
	 weightto	 = weightto_56,
	 educationlevel	 = educationlevel_57,
	 degree	 = degree_58,
	 usekind	 = usekind_59,
	 policy	 = policy_60,
	 bememberdatefrom	 = bememberdatefrom_61,
	 bememberdateto	 = bememberdateto_62,
	 bepartydatefrom	 = bepartydatefrom_63,
	 bepartydateto	 = bepartydateto_64,
	 islabouunion	 = islabouunion_65,
	 bankid1	 = bankid1_66,
	 accountid1	 = accountid1_67,
	 accumfundaccount	 = accumfundaccount_68,
	 loginid	 = loginid_69,
	 systemlanguage	 = systemlanguage_70 ,
	 birthdayyear   =   birthdayyear_71   ,
	 birthdaymonth  =   birthdaymonth_72  ,
	 birthdayday    =   birthdayday_73    ,
	 educationlevelto   =   educationlevelto_74 ,
	 accounttype    =  accounttype_75

WHERE 
	( id = id_1);
end;
/

CREATE OR REPLACE PROCEDURE HrmUserDefine_Insert 
    (userid_1 		integer, 
    hasresourceid_2 	char,
    hasresourcename_3 	char,
    hasjobtitle_4 	char,
    hasactivitydesc_5 	char,
    hasjobgroup_6 	char,
    hasjobactivity_7 	char,
    hascostcenter_8 	char,
    hascompetency_9 	char,
    hasresourcetype_10 	char,
    hasstatus_11 		char,
    hassubcompany_12 	char,
    hasdepartment_13 	char,
    haslocation_14 	char,
    hasmanager_15 	char,
    hasassistant_16 	char,
    hasroles_17 		char,
    hasseclevel_18 	char,
    hasjoblevel_19 	char,
    hasworkroom_20 	char,
    hastelephone_21 	char,
    hasstartdate_22 	char,
    hasenddate_23 	char,
    hascontractdate_24 	char,
    hasbirthday_25 	char,
    hassex_26 		char,
    projectable_27 	char,
    crmable_28 		char,
    itemable_29 		char,
    docable_30 		char,
    workflowable_31 	char,
    subordinateable_32 	char,
    trainable_33 		char,
    budgetable_34 	char,
    fnatranable_35 	char,
    dspperpage_36 	smallint,
    hasage_37 		char,
    hasworkcode_38 	char,
    hasjobcall_39 	char,
    hasmobile_40 		char,
    hasmobilecall_41 	char,
    hasfax_42 		char,
    hasemail_43 		char,
    hasfolk_44 		char,
    hasregresidentplace_45 char,
    hasnativeplace_46 	char,
    hascertificatenum_47 	char,
    hasmaritalstatus_48 	char,
    haspolicy_49 		char,
    hasbememberdate_50 	char,
    hasbepartydate_51 	char,
    hasislabouunion_52 	char,
    haseducationlevel_53 	char,
    hasdegree_54 		char,
    hashealthinfo_55 	char,
    hasheight_56 		char,
    hasweight_57 		char,
    hasresidentplace_58 	char,
    hashomeaddress_59 	char,
    hastempresidentnumber_60 	char,
    hasusekind_61 	char,
    hasbankid1_62 	char,
    hasaccountid1_63 	char,
    hasaccumfundaccount_64 char,
    hasloginid_65 	char,
    hassystemlanguage_66 	char,
	hasaccounttype_67 char,
    workplanable1_68  char,
    flag out integer ,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor )
AS 
recordercount integer; 
begin 
Select  count(userid) INTO recordercount from HrmUserDefine where userid = to_number(userid_1); 
if recordercount = 0 then 
INSERT INTO HrmUserDefine 
(userid,
    hasresourceid,
    hasresourcename,
    hasjobtitle,
    hasactivitydesc,
    hasjobgroup,
    hasjobactivity,
    hascostcenter,
    hascompetency,
    hasresourcetype,
    hasstatus,
    hassubcompany,
    hasdepartment,
    haslocation,
    hasmanager,
    hasassistant,
    hasroles,
    hasseclevel,
    hasjoblevel,
    hasworkroom,
    hastelephone,
    hasstartdate,
    hasenddate,
    hascontractdate,
    hasbirthday,
    hassex,
    projectable,
    crmable,
    itemable,
    docable,
    workflowable,
    subordinateable,
    trainable,
    budgetable,
    fnatranable,
    dspperpage,
    hasage,
    hasworkcode,
    hasjobcall,
    hasmobile,
    hasmobilecall,
    hasfax,
    hasemail,
    hasfolk,
    hasregresidentplace,
    hasnativeplace,
    hascertificatenum,
    hasmaritalstatus,
    haspolicy,
    hasbememberdate,
    hasbepartydate,
    hasislabouunion,
    haseducationlevel,
    hasdegree,
    hashealthinfo,
    hasheight,
    hasweight,
    hasresidentplace,
    hashomeaddress,
    hastempresidentnumber,
    hasusekind,
    hasbankid1,
    hasaccountid1,
    hasaccumfundaccount,
    hasloginid,
    hassystemlanguage,
	hasaccounttype,
    workplanable)
    VALUES 
    (userid_1,
    hasresourceid_2,
    hasresourcename_3,
    hasjobtitle_4,
    hasactivitydesc_5,
    hasjobgroup_6,
    hasjobactivity_7,
    hascostcenter_8,
    hascompetency_9,
    hasresourcetype_10,
    hasstatus_11,
    hassubcompany_12,
    hasdepartment_13,
    haslocation_14,
    hasmanager_15,
    hasassistant_16,
    hasroles_17,
    hasseclevel_18,
    hasjoblevel_19,
    hasworkroom_20,
    hastelephone_21,
    hasstartdate_22,
    hasenddate_23,
    hascontractdate_24,
    hasbirthday_25,
    hassex_26,
    projectable_27,
    crmable_28,
    itemable_29,
    docable_30,
    workflowable_31,
    subordinateable_32,
    trainable_33,
    budgetable_34,
    fnatranable_35,
    dspperpage_36,
    hasage_37,
    hasworkcode_38,
    hasjobcall_39,
    hasmobile_40,
    hasmobilecall_41,
    hasfax_42,
    hasemail_43,
    hasfolk_44,
    hasregresidentplace_45,
    hasnativeplace_46,
    hascertificatenum_47,
    hasmaritalstatus_48,
    haspolicy_49,
    hasbememberdate_50,
    hasbepartydate_51,
    hasislabouunion_52,
    haseducationlevel_53,
    hasdegree_54,
    hashealthinfo_55,
    hasheight_56,
    hasweight_57,
    hasresidentplace_58,
    hashomeaddress_59,
    hastempresidentnumber_60,
    hasusekind_61,
    hasbankid1_62,
    hasaccountid1_63,
    hasaccumfundaccount_64,
    hasloginid_65,
    hassystemlanguage_66,
	hasaccounttype_67,
    workplanable1_68); 
else 
UPDATE HrmUserDefine  SET
hasresourceid	 = hasresourceid_2,
hasresourcename	 = hasresourcename_3,
hasjobtitle		 = hasjobtitle_4,
hasactivitydesc	 = hasactivitydesc_5,
hasjobgroup		 = hasjobgroup_6,
hasjobactivity	 = hasjobactivity_7,
hascostcenter	 = hascostcenter_8,
hascompetency	 = hascompetency_9,
hasresourcetype	 = hasresourcetype_10,
hasstatus		 = hasstatus_11,
hassubcompany	 = hassubcompany_12,
hasdepartment	 = hasdepartment_13,
haslocation	 = haslocation_14,
hasmanager	 = hasmanager_15,
hasassistant	 = hasassistant_16,
hasroles	 = hasroles_17,
hasseclevel	 = hasseclevel_18,
hasjoblevel	 = hasjoblevel_19,
hasworkroom	 = hasworkroom_20,
hastelephone	 = hastelephone_21,
hasstartdate	 = hasstartdate_22,
hasenddate	 = hasenddate_23,
hascontractdate	 = hascontractdate_24,
hasbirthday	 = hasbirthday_25,
hassex	 = hassex_26,
projectable	 = projectable_27,
crmable	 = crmable_28,
itemable	 = itemable_29,
docable	 = docable_30,
workflowable	 = workflowable_31,
subordinateable	 = subordinateable_32,
trainable	 = trainable_33,
budgetable	 = budgetable_34,
fnatranable	 = fnatranable_35,
dspperpage	 = dspperpage_36,
hasage	 = hasage_37,
hasworkcode	 = hasworkcode_38,
hasjobcall	 = hasjobcall_39,
hasmobile	 = hasmobile_40,
hasmobilecall	 = hasmobilecall_41,
hasfax	 = hasfax_42,
hasemail	 = hasemail_43,
hasfolk	 = hasfolk_44,
hasregresidentplace	 = hasregresidentplace_45,
hasnativeplace	 = hasnativeplace_46,
hascertificatenum	 = hascertificatenum_47,
hasmaritalstatus	 = hasmaritalstatus_48, 
haspolicy	 = haspolicy_49,
hasbememberdate	 = hasbememberdate_50,
hasbepartydate	 = hasbepartydate_51,
hasislabouunion	 = hasislabouunion_52,
haseducationlevel	 = haseducationlevel_53,
hasdegree	 = hasdegree_54,
hashealthinfo	 = hashealthinfo_55,
hasheight	 = hasheight_56,
hasweight	 = hasweight_57,
hasresidentplace	 = hasresidentplace_58,
hashomeaddress	 = hashomeaddress_59,
hastempresidentnumber	 = hastempresidentnumber_60,
hasusekind	 = hasusekind_61,
hasbankid1	 = hasbankid1_62,
hasaccountid1	 = hasaccountid1_63,
hasaccumfundaccount	 = hasaccumfundaccount_64,
hasloginid	 = hasloginid_65,
hassystemlanguage	 = hassystemlanguage_66,
hasaccounttype = hasaccounttype_67,
workplanable=workplanable1_68 WHERE ( userid = userid_1); 
end if; 
end;
/