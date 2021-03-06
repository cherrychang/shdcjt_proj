CREATE or REPLACE PROCEDURE workflow_CurOpe_UbyForward 
(requestid_1 integer,userid_1 integer,usertype_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set isremark=2,operatedate=currentdate,operatetime=currenttime 
where requestid =requestid_1 and userid =userid_1 and usertype=usertype_1 and (isremark=1 or isremark=8 or isremark=9);

end;
/


CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebySubmit 
(userid_2 integer, requestid_1 integer,groupid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set operatedate = currentdate,operatetime = currenttime,viewtype=-2 where requestid = requestid_1 and userid = userid_2 and isremark='0' and groupid = groupid_1;

update workflow_currentoperator set isremark = '2' where requestid =requestid_1 and isremark='0' and groupid =groupid_1;

update workflow_currentoperator set isremark = '2' where requestid =requestid_1 and (isremark='1' or isremark='5' or isremark='8' or isremark='9') and userid = userid_2;
end;
/