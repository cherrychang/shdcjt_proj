UPDATE workflow_browserurl SET fielddbtype = 'int' WHERE (id = 87) 
/
UPDATE workflow_formdict set fielddbtype='int' WHERE (type = 87) 
/

INSERT INTO HtmlLabelIndex values(18588,'已经被应用，不能禁用！') 
/
INSERT INTO HtmlLabelInfo VALUES(18588,'已经被应用，不能禁用！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18588,'have been used ,do not estop',8) 
/

INSERT INTO HtmlLabelIndex values(18434,'多项目') 
/
INSERT INTO HtmlLabelInfo VALUES(18434,'多项目',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18434,'multiplicity project',8) 
/

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 135,18434,'text','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp','Prj_ProjectInfo','name','id','/proj/data/ViewProject.jsp?isrequest=1&ProjID=')
/