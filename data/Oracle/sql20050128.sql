insert into SystemRights (id,rightdesc,righttype) values (457,'知识积累创新报表查看权限','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,7,'知识积累创新报表查看权限','知识积累创新报表查看权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,8,'知识积累创新报表查看权限','doccreativereport') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3148,'知识积累创新报表查看权限','docactiverep:View',457) 
/ 
insert into SystemRightToGroup (groupid, rightid) values (2,457)
/
insert into systemrightroles(rightid,roleid,rolelevel) values (457,3,2)
/
