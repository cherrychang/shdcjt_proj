delete from HtmlLabelIndex where id=19981
GO
delete from HtmlLabelInfo where indexid=19981
GO
INSERT INTO HtmlLabelIndex values(19981,'模版文件不存在，请重新生成!') 
GO
INSERT INTO HtmlLabelInfo VALUES(19981,'模版文件不存在，请重新生成!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19981,'File templet is not existed,Please set again!',8) 
GO

delete from HtmlLabelIndex where id=19982
GO
delete from HtmlLabelInfo where indexid=19982
GO
INSERT INTO HtmlLabelIndex values(19982,'导入费用时出错，某组织名称在数据库中不存在!') 
GO
INSERT INTO HtmlLabelInfo VALUES(19982,'导入费用时出错，某组织名称在数据库中不存在!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19982,'Import error! Some organization name are not found in DB!',8) 
GO

delete from HtmlLabelIndex where id=19983
GO
delete from HtmlLabelInfo where indexid=19983
GO
INSERT INTO HtmlLabelIndex values(19983,'导入费用时出错，某科目名称在数据库中不存在!') 
GO
INSERT INTO HtmlLabelInfo VALUES(19983,'导入费用时出错，某科目名称在数据库中不存在!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19983,'Import error! Some subject name are not found in DB!',8) 
GO

delete from HtmlLabelIndex where id=20069
GO
delete from HtmlLabelInfo where indexid=20069
GO
INSERT INTO HtmlLabelIndex values(20069,'未选择费用科目!') 
GO
INSERT INTO HtmlLabelInfo VALUES(20069,'未选择费用科目!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20069,'Not Selected Fee Subject!',8) 
GO

delete from HtmlLabelIndex where id=20070
GO
delete from HtmlLabelInfo where indexid=20070
GO
INSERT INTO HtmlLabelIndex values(20070,'按组织类型填写名称(分部填写分部名称，部门填写部门名称，个人填写个人名称)!') 
GO
INSERT INTO HtmlLabelInfo VALUES(20070,'按组织类型填写名称(分部填写分部名称，部门填写部门名称，个人填写个人名称)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20070,'Please order as type to input name!',8) 
GO

delete from HtmlLabelIndex where id=18617
GO
delete from HtmlLabelInfo where indexid=18617
GO
INSERT INTO HtmlLabelIndex values(18617,'请按下列顺序排列需导入的EXCEL文档中各字段的顺序，其中红色的部分为必填字段，不能为空！') 
GO
INSERT INTO HtmlLabelInfo VALUES(18617,'请按下列顺序排列需导入的EXCEL文档中各字段的顺序，其中红色的部分为必填字段，不能为空！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18617,'Please order as below in Excel,attention,red part must be input,can not be null!',8) 
GO
 
