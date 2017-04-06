delete from HtmlLabelIndex where id=20481
go
delete from HtmlLabelInfo where indexid=20481
go

INSERT INTO HtmlLabelIndex values(20481,'现部门') 
go
INSERT INTO HtmlLabelInfo VALUES(20481,'现部门',7) 
go
INSERT INTO HtmlLabelInfo VALUES(20481,'new department',8) 
go


delete from HtmlLabelIndex where id in (20483,19023,19024,19059,19025,19044,19045,19060,19061,19081,19079,19062,19030,19082,19083,19026)
GO
delete from HtmlLabelInfo where indexid in (20483,19023,19024,19059,19025,19044,19045,19060,19061,19081,19079,19062,19030,19082,19083,19026)
GO

INSERT INTO HtmlLabelIndex values(20483,'统计时间段') 
GO
INSERT INTO HtmlLabelInfo VALUES(20483,'统计时间段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20483,'query times',8) 
GO

INSERT INTO HtmlLabelIndex values(19023,'报表共享设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19023,'报表共享设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19023,'set the Share of report',8) 
GO

INSERT INTO HtmlLabelIndex values(19024,'工作流 － 效率报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19024,'工作流 － 效率报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19024,'WORKFLOW - EFFICIENCY REPORT FORM',8) 
GO

INSERT INTO HtmlLabelIndex values(19059,'平均耗时') 
GO
INSERT INTO HtmlLabelInfo VALUES(19059,'平均耗时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19059,'average spending',8) 
GO

INSERT INTO HtmlLabelIndex values(19025,'共享设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19025,'共享设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19025,'SET SHARE',8) 
GO

INSERT INTO HtmlLabelIndex values(19045,'待提交') 
GO
INSERT INTO HtmlLabelIndex values(19044,'待批准') 
GO
INSERT INTO HtmlLabelInfo VALUES(19044,'待批准',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19044,'approving',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19045,'待提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19045,'submiting',8) 
GO

INSERT INTO HtmlLabelIndex values(19060,'具体流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(19060,'具体流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19060,'request',8) 
GO

INSERT INTO HtmlLabelIndex values(19081,'超时') 
GO
INSERT INTO HtmlLabelInfo VALUES(19081,'超时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19081,'Overtime',8) 
GO

INSERT INTO HtmlLabelIndex values(19079,'耗时') 
GO
INSERT INTO HtmlLabelInfo VALUES(19079,'耗时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19079,'spendtime',8) 

GO
INSERT INTO HtmlLabelIndex values(19061,'流程状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(19061,'流程状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19061,'request status',8) 

GO
INSERT INTO HtmlLabelIndex values(19062,'流转中') 
GO
INSERT INTO HtmlLabelInfo VALUES(19062,'流转中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19062,'flowing',8) 
GO

INSERT INTO HtmlLabelIndex values(19030,'人员办理时间分析表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19030,'人员办理时间分析表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19030,'Analytical table of the time that personnel handles',8) 
GO

INSERT INTO HtmlLabelIndex values(19083,'总') 
GO
INSERT INTO HtmlLabelIndex values(19082,'排名') 
GO
INSERT INTO HtmlLabelInfo VALUES(19082,'排名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19082,'sort',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19083,'总',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19083,'total',8) 
GO

INSERT INTO HtmlLabelIndex values(19026,'效率报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19026,'效率报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19026,'EFFICIENCY REPORT FORM',8) 
GO

delete from HtmlLabelIndex where id=19502
GO
delete from HtmlLabelInfo where indexid=19502
GO
delete from HtmlLabelIndex where id=19503
GO
delete from HtmlLabelInfo where indexid=19503
GO
delete from HtmlLabelIndex where id=19504
GO
delete from HtmlLabelInfo where indexid=19504
GO

INSERT INTO HtmlLabelIndex values(19502,'流程编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(19502,'流程编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19502,'flow code',8) 
GO



INSERT INTO HtmlLabelIndex values(19503,'编号字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19503,'编号字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19503,'field of coding',8) 
GO

INSERT INTO HtmlLabelIndex values(19504,'编号规则') 
GO
INSERT INTO HtmlLabelInfo VALUES(19504,'编号规则',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19504,'rule of coding',8) 
GO
