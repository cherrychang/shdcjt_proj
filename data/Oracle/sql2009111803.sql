create table workflow_fieldtype(
	id integer,
	typename varchar(100),
	namelabel integer,
	classname varchar(200),
	ifdetailuse integer,
	orderid integer,
	status integer
)
/
delete from workflow_fieldtype
/
insert into workflow_fieldtype(id, typename, namelabel, classname, ifdetailuse, orderid, status)
values(1, '单行文本框', 688, 'weaver.workflow.field.InputElement', 1, 4, 1)
/
insert into workflow_fieldtype(id, typename, namelabel, classname, ifdetailuse, orderid, status)
values(2, '多行文本框', 689, 'weaver.workflow.field.TextareaElement', 1, 8, 1)
/
insert into workflow_fieldtype(id, typename, namelabel, classname, ifdetailuse, orderid, status)
values(3, '浏览按钮', 695, 'weaver.workflow.field.ButtonElement', 1, 12, 1)
/
insert into workflow_fieldtype(id, typename, namelabel, classname, ifdetailuse, orderid, status)
values(4, 'Check框', 691, 'weaver.workflow.field.CheckElement', 1, 16, 1)
/
insert into workflow_fieldtype(id, typename, namelabel, classname, ifdetailuse, orderid, status)
values(5, '选择框', 690, 'weaver.workflow.field.SelectElement', 1, 20, 1)
/
insert into workflow_fieldtype(id, typename, namelabel, classname, ifdetailuse, orderid, status)
values(6, '附件上传', 17616, 'weaver.workflow.field.FileElement', 0, 24, 1)
/
insert into workflow_fieldtype(id, typename, namelabel, classname, ifdetailuse, orderid, status)
values(7, '特殊字段', 21691, 'weaver.workflow.field.EspecialElement', 0, 28, 1)
/
delete from SysPubRef where masterCode='WorkflowShowModeType'
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkflowShowModeType', '流程显示模式', 0, '普通模式', 18016, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkflowShowModeType', '流程显示模式', 1, '模板模式', 18017, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkflowShowModeType', '流程显示模式', 2, 'Html模式', 23682, 1)
/

create table workflow_flownodehtml(
	workflowid integer,
	nodeid integer,
	colsperrow integer
)
/
create table workflow_nodehtmllayout(
	id integer,
	workflowid integer,
	formid integer,
	isbill integer,
	nodeid integer,
	type integer,
	layoutname varchar(200),
	syspath varchar(1000)
)
/

create sequence wf_nodehtmllayout_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger wf_nodehtmllayout_id_Tri
before insert on workflow_nodehtmllayout
for each row
begin
select wf_nodehtmllayout_id.nextval into :new.id from dual;
end;
/

create table workflow_nodefieldattr(
	id integer,
	fieldid integer,
	formid integer,
	isbill integer,
	nodeid integer,
	attrcontent varchar(4000)
)
/

create sequence wf_nodefieldattr_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger wf_nodefieldattr_id_Tri
before insert on workflow_nodefieldattr
for each row
begin
select wf_nodefieldattr_id.nextval into :new.id from dual;
end;
/

alter table workflow_nodeform add orderid number(10,2) null
/

update workflow_nodeform n
set n.orderid=(select f.fieldorder from workflow_formfield f where n.fieldid=f.fieldid and f.formid = (select b.formid from workflow_flownode fn left join workflow_base b on b.id=fn.workflowid where fn.nodeid=n.nodeid and b.isbill<>'1'))
/

update workflow_nodeform n
set n.orderid=(select f.dsporder from workflow_billfield f where n.fieldid=f.id and f.billid = (select b.formid from workflow_flownode fn left join workflow_base b on b.id=fn.workflowid where fn.nodeid=n.nodeid and b.isbill<>'1'))
/

update workflow_nodeform set orderid=0 where fieldid<0
/

insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 6, '个人计划', 786, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 7, '费用报销单', 788, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 11, '加班申请', 849, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 13, '借款申请', 862, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 14, '资产申购单', 872, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 15, '资产需求', 878, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 17, '一周工作情况单', 875, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 18, '资产调拨', 883, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 19, '资产领用', 886, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 21, '月工作总结与计划', 6167, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 22, '录用通知单', 890, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 23, '离职通知单', 891, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 28, '审批流转单', 1004, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 29, '邮箱申请', 1020, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 38, '讨论交流', 6009, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 39, '奖惩申请', 6150, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 40, '职位调动', 6110, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 41, '离职申请', 6119, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 42, '转正申请', 6121, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 45, '加班', 6151, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 46, '请假', 670, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 47, '用工需求', 6131, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 48, '培训申请', 6155, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 49, '业务合同', 6160, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 50, '多行请假单', 16676, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 66, '收发文流转单', 16974, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 67, '系统内部发文流转单', 17005, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 68, '在线注册', 17059, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 74, '项目审批单据', 17159, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 79, '客户审批流转单', 17180, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 85, '会议审批单', 17219, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 145, '目标绩效计划审批', 18197, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 146, '目标绩效目标审批', 18198, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 147, '目标绩效考核评分', 18199, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 152, '项目模板审批单', 18396, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 154, '预算审批流转单', 18432, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 156, '付款申请单', 18591, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 157, '借款申请单', 18520, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 158, '报销申请单', 18670, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 159, '预算变更申请单', 18747, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 161, '加班申请单据', 18832, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 162, '请假单据', 18855, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 163, '用车申请审批单据', 19047, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 180, '渤海保险请假单据', 20063, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 192, '客户联系人申请流转单', 20868, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 201, '资产报废单据', 21541, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 220, '资产借用', 6051, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 221, '资产减损', 6054, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 222, '资产送修', 22459, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) 
values ('SpecialBillID', '不支持新模式的单据ID', 224, '资产归还', 15305, 1)
/
