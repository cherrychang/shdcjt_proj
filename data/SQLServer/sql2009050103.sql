alter table workflow_flownode add issignmustinput int null
GO
update workflow_flownode set issignmustinput=1 where workflowid in (select id from workflow_base b where b.issignmustinput='1')
GO
alter table workflow_base drop column isSignMustInput
GO
