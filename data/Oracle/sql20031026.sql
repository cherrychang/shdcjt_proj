/* 朝华测试错误 刘煜修改部分 */

alter table workflow_requestbase modify (requestname  varchar(200))
/


update workflow_groupdetail set objid=4 where groupid = 1
/

insert into workflow_groupdetail (groupid,type,objid,level_n) values (2,5,4,0)
/


delete workflow_nodelink where nodeid not in ( select id from workflow_nodebase ) or  destnodeid not in 
( select id from workflow_nodebase )
/



CREATE OR REPLACE PROCEDURE bill_monthinfodetail_Insert
    (infoid        integer,
    type_1        integer,
    targetname    varchar2,
    targetresult    varchar2  ,
    forecastdate    char,
    scale        number,
    point        varchar2,
    flag out integer ,
      msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

as
begin
    insert into bill_monthinfodetail (infoid,type,targetname,targetresult,forecastdate,scale,point)
    values (infoid,type_1,targetname,targetresult,forecastdate,scale,point);
end;
/


update FileBackupIndex set lastbackupimagefileid = 0 , lastbackupmailfileid = 0 
/


/* 朝华测试错误 杨国生修改部分 */

CREATE INDEX WorkPlan_type_n ON WorkPlan (type_n) 
/
CREATE INDEX WorkPlan_name ON WorkPlan (name) 
/
CREATE INDEX WorkPlan_resourceid ON WorkPlan (resourceid) 
/
CREATE INDEX WorkPlan_status ON WorkPlan (status) 
/
CREATE INDEX WorkPlan_begindate ON WorkPlan (begindate) 
/
CREATE INDEX WorkPlan_enddate ON WorkPlan (enddate) 
/

delete from HomePageDesign
/
delete from PersonalHomePageDesign
/
insert into HomePageDesign (name,iframe,height,url) values ('6057','CurrentWorkIframe','200','/system/homepage/HomePageWork.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('2118','WorkFlowIframe','200','/system/homepage/HomePageWorkFlow.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('316','NewsIframe','200','/system/homepage/HomePageNews.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6058','UnderlingWorkIframe','30','/system/homepage/HomePageUnderlingWork.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('2102','MeetingIframe','200','/system/homepage/HomePageMeeting.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6059','CustomerIframe','200','/system/homepage/HomePageCustomer.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('1211','ProjectIframe','200','/system/homepage/HomePageProject.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6060','UnderlingCustomerIframe','30','/system/homepage/HomePageUnderlingCustomer.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('1213','MailIframe','30','/system/homepage/HomePageMail.jsp')
/
insert into HomePageDesign (name,iframe,height,url) values ('6061','CustomerContactframe','200','/system/homepage/HomePageCustomerContact.jsp')
/

/*加入临时表*/
CREATE GLOBAL TEMPORARY TABLE TEMPTABLEVALUEWORK 
(
    WORKID     integer     ,
    USERID     integer     ,
    USERTYPE   integer     ,
    SHARELEVEL integer     
)
ON COMMIT DELETE ROWS
/
/*当会议审批通过时加入到相关人员的工作计划中并加入相应的权限*/
CREATE OR REPLACE TRIGGER TRI_U_BILL_WORKPLANBYMEET1
AFTER UPDATE 
ON MEETING
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW WHEN (new.isapproved=2) 
Declare
    name_1 varchar2(80);
     isapproved_1    integer;
     begindate_1    char(10);
     begintime_1  char(8);
     enddate_1    char(10);
     endtime_1    char(8);
    createdate_1    char(10);
     createtime_1  char(8);
     resourceid_1    integer;
     meetingid_1    integer;
     caller_1     integer;
     contacter_1 integer;
    allresource_1 varchar2(200); /*工作计划中的接受人*/
    managerstr_1 varchar2(200);
    managerid integer;
    tmpcount integer ;
    userid_1 integer ;
    usertype_1 integer ;
    sharelevel_1 integer ;
    workplanid_1 integer ;
    workplancount_1 integer ;
    /*all_cursor cursor;*/
    /*detail_cursor cursor*/
begin
    name_1:=:new.name;
    begindate_1:=:new.begindate;
    begintime_1:=:new.begintime;
    enddate_1:=:new.enddate;
    endtime_1:=:new.endtime;
    /*meetingid_1:=:meetingid;*/
    caller_1:=:new.caller;
    createdate_1:=:new.createdate;
    createtime_1:=:new.createtime;
    contacter_1:=:new.contacter;

    if enddate_1=''  then
          enddate_1:=begindate_1;
    end if;

        INSERT INTO WorkPlan
        (type_n ,
        name  ,
        resourceid ,
        begindate ,
        begintime ,
        enddate ,
        endtime  ,
        color ,
        description ,
        requestid  ,
        projectid ,
        crmid  ,
        docid  ,
        meetingid ,
        status  ,
        isremind  ,
        waketime  ,
        createrid  ,
        createdate  ,
        createtime ,
        deleted)
        values
        ('1' ,
        name_1  ,
        allresource_1 ,
        begindate_1 ,
        begintime_1 ,
        enddate_1 ,
        endtime_1  ,
        '50C1CB' ,
        '' ,
        '0'  ,
        '0' ,
        '0'  ,
        '0'  ,
        meetingid_1 ,
        '0'  ,
        '1'  ,
        '0'  ,
        caller_1  ,
        createdate_1  ,
        createtime_1  ,
        '0' );
    select id into workplanid_1 from WorkPlan where rownum=1 order by id desc;
    allresource_1 :=to_char(caller_1);
    if INSTR (concat(',',concat(allresource_1,',')),concat('%,',concat(to_char(contacter_1),',%')))=0 then

       /*PATINDEX('%,' + convert(varchar2(5),@contacter) + ',%' , ',' + @allresource + ',')*/
       allresource_1:=concat(allresource_1 ,concat  (',', to_char(contacter_1)));
       allresource_1:=to_char(caller_1);
    end if;
    insert into temptablevalueWork values(workplanid_1,caller_1,1,2) ;
    managerstr_1:='';
    select managerstr into managerstr_1 from HrmResource where id = caller_1;
    managerstr_1:= concat('%,', concat(managerstr_1,'%'));
    for allmanagerid_cursor in(
         select id from HrmResource where
         concat(',',concat(to_char(id),',')) like managerstr_1
    )
    loop
         select count(workid) into workplancount_1 from temptablevalueWork
         where workid=workplanid_1 and userid = managerid;
         if workplancount_1 = 0 then
              insert into temptablevalueWork values(workplanid_1,managerid,1,1);
         end if;
    end loop;
    /*召集人及其经理线权限--end*/

    /*联系人及其经理线权限--begin*/
    select count(workid) into workplancount_1 from temptablevalueWork
    where workid = workplanid_1 and userid = contacter_1;
    if workplancount_1 = 0 then
         insert into temptablevalueWork values(workplanid_1,contacter_1,1,1);
         managerstr_1:='';
         select managerstr into managerstr_1 from HrmResource where id = contacter_1;
         managerstr_1:=concat('%,',concat(managerstr_1,'%'));
         for allmanagerid_cursor in(
         select id from HrmResource where concat(',',concat(to_char(id),',')) like managerstr_1
         )
         loop
              select count(workid) into workplancount_1 from temptablevalueWork
              where workid = workplanid_1 and userid = managerid;
              if workplancount_1 = 0 then
                insert into temptablevalueWork values(workplanid_1,managerid,1,1);
              end if;
         end loop;
    end if;
    /*联系人及其经理线权限--end*/

    for detail_cursor in(
    select memberid from Meeting_Member2 where meetingid=meetingid_1 and membertype=1
    )
    loop
         /*if PATINDEX('%,' + convert(varchar2(5),@resourceid) + ',%' , ',' + @allresource + ',') = 0*/
         if INSTR(concat(',' ,concat(allresource_1, ',')),concat('%,',concat(to_char(resourceid_1),',%')))=0 then
              /*allresource_1:=to_char(caller_1);*/
              allresource_1:= concat(allresource_1,concat(',' , to_char(resourceid_1)));
              select count(workid) into workplancount_1 from temptablevalueWork
              where workid = workplanid_1 and userid = resourceid_1;
               if workplancount_1 = 0 then
                   insert into temptablevalueWork values(workplanid_1,resourceid_1,1,1);
                   managerstr_1:='';
                   select managerstr into managerstr_1 from HrmResource where id = resourceid_1;
                   managerstr_1:=concat('%,',concat(managerstr_1,'%'));

                   for allmanagerid_cursor in(
                   select id from HrmResource where concat(',',concat(to_char(id),',')) like managerstr_1
                   )
                   loop
                        select count(workid) into workplancount_1 from temptablevalueWork
                        where workid = workplanid_1 and userid = managerid;
                        if workplancount_1 = 0 then
                             insert into temptablevalueWork values(workplanid_1,managerid,1,1);
                        end if;
                   end loop;
               end if;
         end if;
    end loop;
    update WorkPlan set resourceid=allresource_1 where id =workplanid_1;

    for allmeetshare_cursor in(
    select * from temptablevalueWork
    )
    loop
        insert into WorkPlanShareDetail values(meetingid_1, userid_1, usertype_1, sharelevel_1);
    end loop;
end;
/
