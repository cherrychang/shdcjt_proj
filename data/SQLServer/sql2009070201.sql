delete from HtmlLabelIndex where id=20244
GO
delete from HtmlLabelInfo where indexid=20244
GO
INSERT INTO HtmlLabelIndex values(20244,'NC系统手动同步') 
GO
INSERT INTO HtmlLabelInfo VALUES(20244,'NC系统手动同步',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20244,'NC System synchronization',8) 
GO

delete from HtmlLabelIndex where id=20243
GO
delete from HtmlLabelInfo where indexid=20243
GO
INSERT INTO HtmlLabelIndex values(20243,'NC系统同步设置')
GO
INSERT INTO HtmlLabelInfo VALUES(20243,'NC系统同步设置',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20243,'NC system settings',8)
GO
