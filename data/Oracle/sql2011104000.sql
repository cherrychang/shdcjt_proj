delete from SystemRightDetail where rightid =1167
/
delete from SystemRightsLanguage where id =1167
/
delete from SystemRights where id =1167
/
insert into SystemRights (id,rightdesc,righttype) values (1167,'�ĵ�������������Ȩ��','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,7,'�ĵ�������������Ȩ��','�ĵ�������������Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,9,'�ęn�����������d����','�ęn�����������d����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1167,8,'doc file batch download','doc file batch download') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42383,'�ĵ�������������Ȩ��','DocFileBatchDownLoad:ALL',1167) 
/