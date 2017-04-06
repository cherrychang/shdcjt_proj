ALTER PROCEDURE HrmResourceShare(@resourceid_1 INT, @departmentid_1 INT, @subcompanyid_1 INT, @managerid_1 INT, @seclevel_1 INT, @managerstr_1 VARCHAR(500), @olddepartmentid_1 INT, @oldsubcompanyid_1 INT, @oldmanagerid_1 INT, @oldseclevel_1 INT, @oldmanagerstr_1 VARCHAR(500), @flag_1 INT, @flag INT OUTPUT, @msg VARCHAR(80) OUTPUT)  AS
/*					��ԱID		����ID			�ֲ�ID		����ID			��ȫ����		�����ϼ�																		��־λ������Ϊ0���޸�Ϊ1*/
DECLARE
 @supresourceid_1 INT,
 @docid_1  INT,
 @crmid_1  INT,
 @prjid_1  INT,
 @cptid_1  INT,
 @sharelevel_1  INT,
 @countrec  INT,
 @countdelete  INT,
 @contractid_1  INT,
 @contractroleid_1 INT,
 @sharelevel_Temp INT,
 @workPlanId_1  INT

/* ������źͰ�ȫ������Ϣ���޸� */
IF(
 (@flag_1 = 1 AND (
   @departmentid_1 <> @olddepartmentid_1
   OR @oldsubcompanyid_1 <> @subcompanyid_1
   OR @seclevel_1 <> @oldseclevel_1
   OR @oldseclevel_1 IS NULL
   )
 ) OR @flag_1 = 0
)
BEGIN

    /* �޸�Ŀ¼���ɱ� */
    IF (@flag_1=1 AND ((@olddepartmentid_1 <> @departmentid_1) OR (@oldseclevel_1 <> @seclevel_1) OR (@oldsubcompanyid_1 <> @subcompanyid_1))) BEGIN
        EXECUTE Doc_DirAcl_DUserP_BasicChange @resourceid_1, @olddepartmentid_1, @oldsubcompanyid_1, @oldseclevel_1
    END
    IF ((@flag_1=0) or (@olddepartmentid_1 <> @departmentid_1) OR (@oldseclevel_1 <> @seclevel_1) OR (@oldsubcompanyid_1 <> @subcompanyid_1)) BEGIN
        EXECUTE Doc_DirAcl_GUserP_BasicChange @resourceid_1, @departmentid_1, @subcompanyid_1, @seclevel_1
    END

    /* �����½��ĵ�Ŀ¼���б� */
    EXEC DocUserCategory_InsertByUser @resourceid_1,'0','',''



 /* ------- DOC ���� -------  */
 /*����������˸��� ��Ҫ���ĵ��������е�ͬ���ż�¼���޸�*/
 IF ((@flag_1 = 1 AND @departmentid_1<>@olddepartmentid_1) OR @flag_1 = 0)
 BEGIN
  UPDATE shareinnerdoc SET content=@departmentid_1 WHERE type=3 AND  srcfrom=85 AND opuser=@resourceid_1
 END

 /*����ֲ����˱仯����Ҫ���ĵ��������е�ͬ�ֲ���صļ�¼���޸�*/
 IF ((@flag_1 = 1 AND @subcompanyid_1<>@oldsubcompanyid_1) OR @flag_1 = 0)
 BEGIN
  UPDATE shareinnerdoc SET content=@subcompanyid_1 WHERE type=2 AND srcfrom=84 AND opuser=@resourceid_1
 END

    /* ------- CRM  ���� -----�µĹ�����ʽ�£��޸Ĳ��ţ��ֲ��͵ȼ���Ӱ�칲��-- */

    /* delete the work plan share info of this user */
    DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* ������ʱ������ */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  �����е���Ϣ�ַŵ� @temptablevaluecrm �� */
    /*  �Լ��� manager �Ŀͻ� 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor

    /* �Լ��¼��Ŀͻ� 3 */
    /* �����¼� */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* ��Ϊcrm����Ա�ܿ����Ŀͻ� */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor   


    /* �ɿͻ��Ĺ�����õ�Ȩ�� 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* ����ʱ���е�����д�빲���� */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        /*insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)*/

    /* added by lupeng 2004-07-22 for customer contact work plan */ 
        DECLARE ccwp_cursor CURSOR FOR
        SELECT id FROM WorkPlan WHERE type_n = '3' AND ','+crmid+',' like '%,'+CONVERT(varchar(100), @crmid_1)+',%'
        OPEN ccwp_cursor 
        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN       
        IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
            AND userid = @resourceid_1 AND usertype = 1)
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
            @workPlanId_1, @resourceid_1, 1, 1)
        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        END     
        CLOSE ccwp_cursor 
        DEALLOCATE ccwp_cursor
    /* end */

        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor

    /* ------- PROJ ���� ------- */

    /* ������ʱ������ */
    DECLARE @temptablevaluePrj  TABLE(prjid INT,sharelevel INT)

    /*  �����е���Ϣ�ַŵ� @temptablevaluePrj �� */
    /*  �Լ�����Ŀ2 */
    DECLARE prjid_cursor CURSOR FOR
    SELECT id FROM Prj_ProjectInfo WHERE manager = @resourceid_1
    OPEN prjid_cursor
    FETCH NEXT FROM prjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 2)
        FETCH NEXT FROM prjid_cursor INTO @prjid_1
    END
    CLOSE prjid_cursor DEALLOCATE prjid_cursor


    /* �Լ��¼�����Ŀ3 */
    /* �����¼� */

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subprjid_cursor CURSOR FOR
    SELECT id FROM Prj_ProjectInfo WHERE ( manager IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) )
    OPEN subprjid_cursor
    FETCH NEXT FROM subprjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0  INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 3)
        FETCH NEXT FROM subprjid_cursor INTO @prjid_1
    END
    CLOSE subprjid_cursor DEALLOCATE subprjid_cursor

    /* ��Ϊ��Ŀ����Ա�ܿ�������Ŀ4 */
    DECLARE roleprjid_cursor CURSOR FOR
   SELECT DISTINCT t1.id FROM Prj_ProjectInfo  t1, hrmrolemembers  t2  WHERE t2.roleid=9 AND t2.resourceid= @resourceid_1 AND (t2.rolelevel=2 OR (t2.rolelevel=0 AND t1.department=@departmentid_1) OR  (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1 ))
    OPEN roleprjid_cursor
    FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0  INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 4)
        FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
    END
    CLOSE roleprjid_cursor DEALLOCATE roleprjid_cursor


    /* ����Ŀ�Ĺ�����õ�Ȩ�� 1 2 */
    DECLARE shareprjid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM Prj_ShareInfo  t2  WHERE  ( (t2.foralluser=1 AND t2.seclevel<=@seclevel_1)  OR ( t2.userid=@resourceid_1 ) OR (t2.departmentid=@departmentid_1 AND t2.seclevel<=@seclevel_1)  )
    OPEN shareprjid_cursor
    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluePrj VALUES(@prjid_1, @sharelevel_1)
        END
        FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    END
    CLOSE shareprjid_cursor DEALLOCATE shareprjid_cursor


    DECLARE shareprjid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  WHERE  t1.id = t2.relateditemid AND  t3.resourceid=@resourceid_1 AND t3.roleid=t2.roleid AND t3.rolelevel>=t2.rolelevel AND t2.seclevel<=@seclevel_1 AND ( (t2.rolelevel=0  AND t1.department=@departmentid_1) OR (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1) OR (t3.rolelevel=2) )
    OPEN shareprjid_cursor
    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluePrj VALUES(@prjid_1, @sharelevel_1)
        END
        FETCH NEXT FROM shareprjid_cursor INTO @prjid_1 , @sharelevel_1
    END
    CLOSE shareprjid_cursor DEALLOCATE shareprjid_cursor



    /* ��Ŀ��Ա5 (�ڲ��û�) */
    DECLARE @members_1 VARCHAR(200)
    SET @members_1 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'
    DECLARE inuserprjid_cursor CURSOR FOR
    SELECT  id FROM Prj_ProjectInfo   WHERE  (','+members+','  LIKE  @members_1)  AND isblock='1'
    OPEN inuserprjid_cursor
    FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(prjid) FROM @temptablevaluePrj WHERE prjid = @prjid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluePrj VALUES(@prjid_1, 5)
        END
        FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
    END
    CLOSE inuserprjid_cursor DEALLOCATE inuserprjid_cursor


    /* ɾ��ԭ�е������Ա��ص�������ĿȨ */
    DELETE FROM PrjShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* ����ʱ���е�����д�빲���� */
    DECLARE allprjid_cursor CURSOR FOR
    SELECT * FROM @temptablevaluePrj
    OPEN allprjid_cursor
    FETCH NEXT FROM allprjid_cursor INTO @prjid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO PrjShareDetail( prjid, userid, usertype, sharelevel) VALUES(@prjid_1, @resourceid_1,1,@sharelevel_1)
        FETCH NEXT FROM allprjid_cursor INTO @prjid_1 , @sharelevel_1
    END
    CLOSE allprjid_cursor DEALLOCATE allprjid_cursor


    /* ------- CPT ���� ------- */

    /* ������ʱ������ */
    DECLARE @temptablevalueCpt  TABLE(cptid INT,sharelevel INT)

    /*  �����е���Ϣ�ַŵ� @temptablevalueCpt �� */
    /*  �Լ����ʲ�2 */
    DECLARE cptid_cursor CURSOR FOR
    SELECT id FROM CptCapital WHERE resourceid = @resourceid_1
    OPEN cptid_cursor
    FETCH NEXT FROM cptid_cursor INTO @cptid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevalueCpt VALUES(@cptid_1, 2)
        FETCH NEXT FROM cptid_cursor INTO @cptid_1
    END
    CLOSE cptid_cursor DEALLOCATE cptid_cursor

    /*  �ʲ������޸��� */
    DECLARE cptid_cursor CURSOR FOR
    SELECT id FROM CptCapital WHERE lastmoderid = @resourceid_1
    OPEN cptid_cursor
    FETCH NEXT FROM cptid_cursor INTO @cptid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevalueCpt VALUES(@cptid_1, 1)
        FETCH NEXT FROM cptid_cursor INTO @cptid_1
    END
    CLOSE cptid_cursor DEALLOCATE cptid_cursor

    /* �Լ��¼����ʲ�1 */
    /* �����¼� */

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subcptid_cursor CURSOR FOR
    SELECT id FROM CptCapital WHERE ( resourceid IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) )
    OPEN subcptid_cursor
    FETCH NEXT FROM subcptid_cursor INTO @cptid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(cptid) FROM @temptablevalueCpt WHERE cptid = @cptid_1
        IF @countrec = 0  INSERT INTO @temptablevalueCpt VALUES(@cptid_1, 1)
        FETCH NEXT FROM subcptid_cursor INTO @cptid_1
    END
    CLOSE subcptid_cursor DEALLOCATE subcptid_cursor


    /* ���ʲ��Ĺ�����õ�Ȩ�� 1 2 */
    DECLARE sharecptid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM CptCapitalShareInfo  t2  WHERE  ( (t2.foralluser=1 AND t2.seclevel<=@seclevel_1)  OR ( t2.userid=@resourceid_1 ) OR (t2.departmentid=@departmentid_1 AND t2.seclevel<=@seclevel_1)  )
    OPEN sharecptid_cursor
    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(cptid) FROM @temptablevalueCpt WHERE cptid = @cptid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevalueCpt VALUES(@cptid_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    END
    CLOSE sharecptid_cursor DEALLOCATE sharecptid_cursor


    DECLARE sharecptid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 WHERE t1.id=t2.relateditemid AND t3.resourceid= @resourceid_1 AND t3.roleid=t2.roleid AND t3.rolelevel>=t2.rolelevel AND t2.seclevel<= @seclevel_1 AND ( (t2.rolelevel=0  AND t1.departmentid= @departmentid_1 ) OR (t2.rolelevel=1 AND t1.departmentid=t4.id AND t4.subcompanyid1= @subcompanyid_1 ) OR (t3.rolelevel=2) )
    OPEN sharecptid_cursor
    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(cptid) FROM @temptablevalueCpt WHERE cptid = @cptid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevalueCpt VALUES(@cptid_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharecptid_cursor INTO @cptid_1 , @sharelevel_1
    END
    CLOSE sharecptid_cursor DEALLOCATE sharecptid_cursor



    /* ɾ��ԭ�е������Ա��ص������ʲ�Ȩ */
    DELETE FROM CptShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* ����ʱ���е�����д�빲���� */
    DECLARE allcptid_cursor CURSOR FOR
    SELECT * FROM @temptablevalueCpt
    OPEN allcptid_cursor
    FETCH NEXT FROM allcptid_cursor INTO @cptid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO CptShareDetail( cptid, userid, usertype, sharelevel) VALUES(@cptid_1, @resourceid_1,1,@sharelevel_1)
        FETCH NEXT FROM allcptid_cursor INTO @cptid_1 , @sharelevel_1
    END
    CLOSE allcptid_cursor DEALLOCATE allcptid_cursor


     /* ------- �ͻ���ͬ����2003-11-06����� ------- */

    /* ������ʱ������ */
    DECLARE @temptablevaluecontract  TABLE(contractid INT,sharelevel INT)

    /*  �����е���Ϣ�ַŵ� @temptablevaluecontract �� */

    /* �Լ��¼��Ŀͻ���ͬ 3 */

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subcontractid_cursor CURSOR FOR
    SELECT id FROM CRM_Contract WHERE ( manager IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) )
    OPEN subcontractid_cursor
    FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0  INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 3)
        FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    END
    CLOSE subcontractid_cursor DEALLOCATE subcontractid_cursor


    /*  �Լ��� manager �Ŀͻ���ͬ 2 */
    DECLARE contractid_cursor CURSOR FOR
    SELECT id FROM CRM_Contract WHERE manager = @resourceid_1
    OPEN contractid_cursor
    FETCH NEXT FROM contractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 2)
        FETCH NEXT FROM contractid_cursor INTO @contractid_1
    END
    CLOSE contractid_cursor DEALLOCATE contractid_cursor



    /* ��Ϊ�ͻ���ͬ����Ա�ܿ����� */
    DECLARE roleids_cursor CURSOR FOR
    SELECT roleid FROM SystemRightRoles WHERE rightid = 396
    OPEN roleids_cursor
    FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
    WHILE @@fetch_status=0
    BEGIN

       DECLARE rolecontractid_cursor CURSOR FOR
       SELECT DISTINCT t1.id FROM CRM_Contract  t1, hrmrolemembers  t2  WHERE t2.roleid=@contractroleid_1 AND t2.resourceid=@resourceid_1 AND (t2.rolelevel=2 OR (t2.rolelevel=0 AND t1.department=@departmentid_1 ) OR (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1 ));

        OPEN rolecontractid_cursor
        FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
            IF @countrec = 0
            BEGIN
                INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 2)
            END
            ELSE
            BEGIN
                SELECT @sharelevel_1 = sharelevel FROM ContractShareDetail WHERE contractid = @contractid_1 AND userid = @resourceid_1 AND usertype = 1
                IF @sharelevel_1 = 1
                BEGIN
                     UPDATE ContractShareDetail SET sharelevel = 2 WHERE contractid = @contractid_1 AND userid = @resourceid_1 AND usertype = 1
                END
            END
            FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
        END
        CLOSE rolecontractid_cursor DEALLOCATE rolecontractid_cursor

     FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
     END
     CLOSE roleids_cursor DEALLOCATE roleids_cursor


    /* �ɿͻ���ͬ�Ĺ�����õ�Ȩ�� 1 2 */
    DECLARE sharecontractid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM Contract_ShareInfo  t2  WHERE  ( (t2.foralluser=1 AND t2.seclevel<=@seclevel_1)  OR ( t2.userid=@resourceid_1 ) OR (t2.departmentid=@departmentid_1 AND t2.seclevel<=@seclevel_1)  )
    OPEN sharecontractid_cursor
    FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluecontract VALUES(@contractid_1, @sharelevel_1)
        END
        ELSE
        BEGIN
            SELECT @sharelevel_Temp = sharelevel FROM @temptablevaluecontract WHERE contractid = @contractid_1
            IF ((@sharelevel_Temp = 1) AND (@sharelevel_1 = 2))
            UPDATE @temptablevaluecontract SET sharelevel = @sharelevel_1 WHERE contractid = @contractid_1
        END
        FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    END
    CLOSE sharecontractid_cursor DEALLOCATE sharecontractid_cursor



    DECLARE sharecontractid_cursor CURSOR FOR
    SELECT DISTINCT t2.relateditemid , t2.sharelevel FROM CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3  WHERE  t1.id = t2.relateditemid AND t3.resourceid=@resourceid_1 AND t3.roleid=t2.roleid AND t3.rolelevel>=t2.rolelevel AND t2.seclevel<=@seclevel_1 AND ( (t2.rolelevel=0  AND t1.department=@departmentid_1) OR (t2.rolelevel=1 AND t1.subcompanyid1=@subcompanyid_1) OR (t3.rolelevel=2) )
    OPEN sharecontractid_cursor
    FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0
        BEGIN
            INSERT INTO @temptablevaluecontract VALUES(@contractid_1, @sharelevel_1)
        END
        ELSE
        BEGIN
            SELECT @sharelevel_Temp = sharelevel FROM @temptablevaluecontract WHERE contractid = @contractid_1
            IF ((@sharelevel_Temp = 1) AND (@sharelevel_1 = 2))
            UPDATE @temptablevaluecontract SET sharelevel = @sharelevel_1 WHERE contractid = @contractid_1
        END
        FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1 , @sharelevel_1
    END
    CLOSE sharecontractid_cursor DEALLOCATE sharecontractid_cursor


    /* �Լ��¼��Ŀͻ���ͬ  (�ͻ�������������)*/

    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5),@resourceid_1) + ',%'

    DECLARE subcontractid_cursor CURSOR FOR
    SELECT t2.id FROM CRM_CustomerInfo t1 , CRM_Contract t2 WHERE ( t1.manager IN (SELECT DISTINCT id FROM HrmResource WHERE ','+managerstr LIKE @managerstr_11 ) ) AND (t2.crmId = t1.id)
    OPEN subcontractid_cursor
    FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        SELECT @countrec = count(contractid) FROM @temptablevaluecontract WHERE contractid = @contractid_1
        IF @countrec = 0  INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 1)
        FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
    END
    CLOSE subcontractid_cursor DEALLOCATE subcontractid_cursor


    /*  �Լ��� manager �Ŀͻ� (�ͻ�������������) */
    DECLARE contractid_cursor CURSOR FOR
    SELECT t2.id FROM CRM_CustomerInfo t1 , CRM_Contract t2 WHERE (t1.manager = @resourceid_1 ) AND (t2.crmId = t1.id)
    OPEN contractid_cursor
    FETCH NEXT FROM contractid_cursor INTO @contractid_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO @temptablevaluecontract VALUES(@contractid_1, 1)
        FETCH NEXT FROM contractid_cursor INTO @contractid_1
    END
    CLOSE contractid_cursor DEALLOCATE contractid_cursor


    /* ɾ��ԭ�е������Ա��ص�����Ȩ */
    DELETE FROM ContractShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* ����ʱ���е�����д�빲���� */
    DECLARE allcontractid_cursor CURSOR FOR
    SELECT * FROM @temptablevaluecontract
    OPEN allcontractid_cursor
    FETCH NEXT FROM allcontractid_cursor INTO @contractid_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN
        INSERT INTO ContractShareDetail( contractid, userid, usertype, sharelevel) VALUES(@contractid_1, @resourceid_1,1,@sharelevel_1)
        FETCH NEXT FROM allcontractid_cursor INTO @contractid_1 , @sharelevel_1
    END
    CLOSE allcontractid_cursor DEALLOCATE allcontractid_cursor


    /*================== �����ճ� ==================*/
    /*�µĹ�����ʽ�£��޸���Ա�Ĳ��ţ��ֲ��͵ȼ���Ӱ�칲��*/
    DECLARE @TmpTableValueWP TABLE (workPlanId int, shareLevel int)
    
    /* �����˱����ճ� */
    DECLARE creater_cursor CURSOR FOR
	SELECT id FROM WorkPlan WHERE createrId = @resourceid_1 
	OPEN creater_cursor 
	FETCH NEXT FROM creater_cursor INTO @workPlanId_1
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 2)
		FETCH NEXT FROM creater_cursor INTO @workPlanId_1
	END
	CLOSE creater_cursor 
    DEALLOCATE creater_cursor

    /* ���Կ����������¼��ճ� */     
    SET @managerstr_11 = '%,' + CONVERT(varchar(5), @resourceid_1) + ',%' 
    DECLARE underling_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE ',' + MANAGERSTR LIKE @managerstr_11))
    OPEN underling_cursor 
    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1
        IF (@countrec = 0)
        	INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 1)
        FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    END
    CLOSE underling_cursor 
    DEALLOCATE underling_cursor     


    /* ���Կ����ճ̹��������е��ճ� */
    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT workPlanShare.workPlanId, workPlanShare.shareLevel
    FROM WorkPlanShare workPlanShare
    WHERE 
    (
    /* ������ */
    (workPlanShare.forAll = 1 AND workPlanShare.securityLevel <= @seclevel_1)
    /* ������Դ */
    OR (workPlanShare.userId LIKE '%,'+cast(@resourceid_1 as varchar(10))+',%')
    /* ���� */
    OR (workPlanShare.deptId LIKE '%,'+cast(@departmentid_1 as varchar(10))+',%' AND workPlanShare.securityLevel <= @seclevel_1) 
    /* �ֲ� */
    OR (workPlanShare.subCompanyId LIKE '%,'+cast(@subcompanyid_1 as varchar(10))+',%' AND workPlanShare.securityLevel <= @seclevel_1)
    )   
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0)
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    /* ��ɫ */
    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT workPlanShare.workPlanId, workPlanShare.shareLevel
    FROM WorkPlan workPlan, WorkPlanShare workPlanShare, HrmRoleMembers hrmRoleMembers
    WHERE 
    (
        workPlan.id = workPlanShare.workPlanId 
        AND workPlanShare.roleId = hrmRoleMembers.roleId 
        AND hrmRoleMembers.resourceid = @resourceid_1 
        AND hrmRoleMembers.rolelevel >= workPlanShare.roleLevel 
        AND workPlanShare.securityLevel <= @seclevel_1
    )         
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0)
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor



    /* ����ʱ��д����ϸ�� */
    DECLARE allwp_cursor CURSOR FOR
    SELECT * FROM @TmpTableValueWP
    OPEN allwp_cursor 
    FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        INSERT INTO WorkPlanShareDetail(workId, userId, userType, shareLevel)
        	VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
        FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    END
    CLOSE allwp_cursor 
    DEALLOCATE allwp_cursor
    /* �ճ̹������� */



END        /* �����޸��˲��źͰ�ȫ�������� */

/* �����޸��˾����ֶ� */
/* ------- DOC ���� -------  */
/*ֻ��Ҫ��docshareinner������Ӧ�ľ������Ķ��Ϳ����� 81�����������ϼ�*/
IF (@flag_1 = 1 AND @managerid_1 <> @oldManagerid_1)
BEGIN
UPDATE shareinnerdoc SET content=@managerid_1 WHERE srcfrom=81 AND opuser=@resourceid_1
END

/* �����޸��˾����ֶ� */
IF ( (@flag_1 = 1 AND @managerstr_1 <> @oldmanagerstr_1) OR @flag_1 = 0 )
BEGIN
    IF ( @managerstr_1 IS NOT NULL AND len(@managerstr_1) > 1 )  /* ���ϼ����� */
    BEGIN

        SET @managerstr_1 = ',' + @managerstr_1

    /* ------- CRM ���� -----�µĹ�����ʽ�£��޸ľ�����weaver.crm.CrmShareBase.setShareForNewManager�д���-- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CRM_CustomerInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        while @@fetch_status=0
        begin 

        /* added by lupeng 2004-07-22 for customer contact work plan */ 
        DECLARE ccwp_cursor CURSOR FOR
        SELECT id FROM WorkPlan WHERE type_n = '3' AND ','+crmid+',' like '%,'+CONVERT(varchar(100), @crmid_1)+',%'
        OPEN ccwp_cursor 
        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN       
            IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
            AND userid = @resourceid_1 AND usertype = 1)
            INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
            @workPlanId_1, @resourceid_1, 1, 1)
            FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        END     
        CLOSE ccwp_cursor 
        DEALLOCATE ccwp_cursor
        /* end */

            fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


    /* ------- PROJ ���� ------- */
    DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t2.id FROM HrmResource t1, Prj_ProjectInfo t2 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.manager = @resourceid_1;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @prjid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(prjid) FROM PrjShareDetail WHERE prjid = @prjid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO PrjShareDetail( prjid, userid, usertype, sharelevel) VALUES(@prjid_1,@supresourceid_1,1,3)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @prjid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor


    /* ------- CPT ���� ------- */
    DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t2.id FROM HrmResource t1, CptCapital t2 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.resourceid = @resourceid_1;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @cptid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(cptid) FROM CptShareDetail WHERE cptid = @cptid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO CptShareDetail( cptid, userid, usertype, sharelevel) VALUES(@cptid_1,@supresourceid_1,1,1)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @cptid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor

         /* ------- �ͻ���ͬ���� �����ı� 2003-11-06�����------- */
        DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t2.id FROM HrmResource t1, CRM_Contract t2 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.manager = @resourceid_1;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(contractid) FROM ContractShareDetail WHERE contractid = @contractid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO ContractShareDetail( contractid, userid, usertype, sharelevel) VALUES(@contractid_1,@supresourceid_1,1,3)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor

        DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id , t3.id FROM HrmResource t1, CRM_CustomerInfo t2 ,CRM_Contract t3 WHERE @managerstr_1 LIKE '%,'+CONVERT(VARCHAR(5),t1.id)+',%' AND  t2.manager = @resourceid_1  AND t2.id = t3.crmId;
        OPEN supuserid_cursor
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        WHILE @@fetch_status=0
        BEGIN
            SELECT @countrec = count(contractid) FROM ContractShareDetail WHERE contractid = @contractid_1 AND userid= @supresourceid_1 AND usertype= 1
            IF @countrec = 0
            BEGIN
                INSERT INTO ContractShareDetail( contractid, userid, usertype, sharelevel) VALUES(@contractid_1,@supresourceid_1,1,1)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @contractid_1
        END
        CLOSE supuserid_cursor DEALLOCATE supuserid_cursor


    /* for work plan */
    /* added by lupeng 2004-07-22 */
    /*�µĹ�����ʽ�£��޸ľ�����weaver.WorkPlan.WorkPlanShareBase.setShareForNewManager�д���*/
    DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id, t2.id FROM HrmResource t1, WorkPlan t2 WHERE @managerstr_1 LIKE '%,' + CONVERT(varchar(5),t1.id) + ',%' AND t2.createrid = @resourceid_1
        OPEN supuserid_cursor 
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 
            SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @supresourceid_1 AND usertype = 1
            IF (@countrec = 0)
            BEGIN
                INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) values(@workPlanId_1, @supresourceid_1, 1, 1)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @workPlanId_1
        end
        CLOSE supuserid_cursor 
    DEALLOCATE supuserid_cursor
    /* end */


    END             /* ���ϼ������ж����� */
END   /* �޸ľ������ж����� */
GO

ALTER PROCEDURE HrmRoleMembersShare(@resourceid_1 int, @roleid_1 int, @rolelevel_1 int, @rolelevel_2 int, @flag_1 int, @flag integer output, @msg varchar(80) output)  AS

declare	
        @docid_1	int,
	@crmid_1	int,
	@prjid_1	int,
	@cptid_1	int,
        @sharelevel_1	int,
        @departmentid_1	int,
	@subcompanyid_1	int,
        @seclevel_1	int,
        @countrec	int,
        @countdelete	int,
        @countinsert	int,
        @contractid_1	int,
        @contractroleid_1	int ,
        @sharelevel_Temp	int,
	@workPlanId_1	int,
	@managerstr_11	char(500)


/* �����ɾ��ԭ�����ݣ������ɱ��е�Ȩ����������һ */
if (@flag_1 = 2) begin
    select @seclevel_1 = seclevel from hrmresource where id = @resourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_DUserP_RoleChange @resourceid_1, @roleid_1, @rolelevel_2, @seclevel_1
    end
end
/* ��������������ݣ������ɱ��е�Ȩ����������һ */
if (@flag_1 = 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @resourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_GUserP_RoleChange @resourceid_1, @roleid_1, @rolelevel_1, @seclevel_1
    end
end

if ( @flag_1 =0 or ( @flag_1 = 1 and @rolelevel_1  > @rolelevel_2 ) )
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    if @rolelevel_1 = '2'       /* �µĽ�ɫ����Ϊ�ܲ��� */
    begin 

	

	/* ------- CRM ���� ----��ɫ�仯��Ӱ��ͻ����ճ̵Ĺ�������������ɫ��Զ���--- */

	if(@roleid_1=8)
	    begin
	        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) select id,@resourceid_1,1,0 from WorkPlan where type_n = '3'
	    end
	else begin

	declare sharecrmid_cursor cursor for
        select distinct relateditemid , sharelevel from CRM_ShareInfo where contents = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND ','+crmid+',' like '%,'+CONVERT(varchar(100), @crmid_1)+',%'
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
		IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 0)
		FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	   /* end */

            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	end
	
	/* ------- PROJ ���� ------- */

	declare shareprjid_cursor cursor for
        select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor


	/* ------- CPT ���� ------- */

	declare sharecptid_cursor cursor for
        select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor

     
        /* ------- �ͻ���ͬ���� �ܲ� 2003-11-06�����------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396Ϊ�ͻ���ͬ����Ȩ��*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and t2.rolelevel=2 ;
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
                end
                else   
                begin
                    select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                    if @sharelevel_1 = 1
                    begin
                         update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                    end 
                end
                fetch next from rolecontractid_cursor into @contractid_1
            end
            close rolecontractid_cursor deallocate rolecontractid_cursor

            fetch next from roleids_cursor into @contractroleid_1
         end
         close roleids_cursor deallocate roleids_cursor	   

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */

	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE roleId = @roleid_1 AND roleLevel <= @rolelevel_1 AND securityLevel <= @seclevel_1 
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)  VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor

	 /* end */

end


else if @rolelevel_1 = '1'          /* �µĽ�ɫ����Ϊ�ֲ��� */
begin
	/* ------- CRM ���� ----��ɫ�仯��Ӱ��ͻ����ճ̵Ĺ�������������ɫ��Զ���--- */

	declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.contents = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND ','+crmid+',' like '%,'+CONVERT(varchar(100), @crmid_1)+',%'
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
		IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 0)
		FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	   /* end */
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ ���� ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department=t4.id and t4.subcompanyid1= @subcompanyid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT ���� ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor



        /* ------- �ͻ���ͬ���� �ֲ� 2003-11-06�����------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396Ϊ�ͻ���ͬ����Ȩ��*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 );
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
                end
                else   
                begin
                    select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                    if @sharelevel_1 = 1
                    begin
                         update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                    end 
                end
                fetch next from rolecontractid_cursor into @contractid_1
            end
            close rolecontractid_cursor deallocate rolecontractid_cursor

            fetch next from roleids_cursor into @contractroleid_1
         end
         close roleids_cursor deallocate roleids_cursor	   

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = @roleid_1 AND t2.roleLevel <= @rolelevel_1 AND t2.securityLevel <= @seclevel_1 AND t1.subcompanyId = @subcompanyid_1
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)  VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor
	 /* end */


end


else if @rolelevel_1 = '0'          /* Ϊ�½�ʱ���趨����Ϊ���ż� */
begin

    
	
	/* ------- CRM ���� ---��ɫ�仯��Ӱ��ͻ����ճ̵Ĺ�������������ɫ��Զ���---- */

	declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.contents = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = @departmentid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND ','+crmid+',' like '%,'+CONVERT(varchar(100), @crmid_1)+',%'
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
		IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 0)
		FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	   /* end */

            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ ���� ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department= @departmentid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT ���� ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid= @departmentid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


       /* ------- �ͻ���ͬ���� ���� 2003-11-06�����------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396Ϊ�ͻ���ͬ����Ȩ��*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=0 and t1.department=@departmentid_1 );
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
                end
                else   
                begin
                    select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                    if @sharelevel_1 = 1
                    begin
                         update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                    end 
                end
                fetch next from rolecontractid_cursor into @contractid_1
            end
            close rolecontractid_cursor deallocate rolecontractid_cursor

            fetch next from roleids_cursor into @contractroleid_1
         end
         close roleids_cursor deallocate roleids_cursor	          

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = @roleid_1 AND t2.roleLevel <= @rolelevel_1 AND t2.securityLevel <= @seclevel_1 AND t1.deptId LIKE '%,'+cast(@departmentid_1 as varchar(10))+',%'
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)  VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor
	 /* end */

    end
end



else if ( @flag_1 =2 or ( @flag_1 = 1 and @rolelevel_1  < @rolelevel_2 ) ) /* ��Ϊɾ�����߼��𽵵� */
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0
	
  

   


    /* ------- CRM  ���� ----��ɫ�仯��Ӱ��ͻ����ճ̵Ĺ�������������ɫ��Զ���--- */


    /* ɾ��ԭ�еĸ��˵����пͻ�������Ϣ 
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1*/

    /* delete the work plan share info of this user */
    DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1


    /* ������ʱ������ */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  �����е���Ϣ�ַŵ� @temptablevaluecrm �� */
    /*  �Լ��� manager �Ŀͻ� 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* �Լ��¼��Ŀͻ� 3 */
    /* �����¼� */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* ��Ϊcrm����Ա�ܿ����Ŀͻ� */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* �ɿͻ��Ĺ�����õ�Ȩ�� 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid = @departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department = @departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* ����ʱ���е�����д�빲���� */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        /*insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)*/

	/* added by lupeng 2004-07-22 for customer contact work plan */	
        DECLARE ccwp_cursor CURSOR FOR
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
        OPEN ccwp_cursor 
        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 	    
	    IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
	    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        END	    
        CLOSE ccwp_cursor 
        DEALLOCATE ccwp_cursor
	/* end */

        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor
    
    /* ------- PROJ ���� ------- */

    /* ������ʱ������ */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  �����е���Ϣ�ַŵ� @temptablevaluePrj �� */
    /*  �Լ�����Ŀ2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* �Լ��¼�����Ŀ3 */
    /* �����¼� */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* ��Ϊ��Ŀ����Ա�ܿ�������Ŀ4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* ����Ŀ�Ĺ�����õ�Ȩ�� 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* ��Ŀ��Ա5 (�ڲ��û�) */
    declare inuserprjid_cursor cursor for
    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =@resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' 

    
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1 
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* ɾ��ԭ�е������Ա��ص�������ĿȨ */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* ����ʱ���е�����д�빲���� */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT ���� ------- */

    /* ������ʱ������ */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  �����е���Ϣ�ַŵ� @temptablevalueCpt �� */
    /*  �Լ����ʲ�2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* �Լ��¼����ʲ�1 */
    /* �����¼� */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* ���ʲ��Ĺ�����õ�Ȩ�� 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1) /*2004-8-3 ·�� -- ��ɫ�ı�ʱ���ʲ���Ȩ�޹����������á�*/
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* ɾ��ԭ�е������Ա��ص������ʲ�Ȩ */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* ����ʱ���е�����д�빲���� */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor



     /* ------- �ͻ���ͬ����2003-11-06����� ------- */

    /* ������ʱ������ */
    Declare @temptablevaluecontract  table(contractid int,sharelevel int)

    /*  �����е���Ϣ�ַŵ� @temptablevaluecontract �� */

    /* �Լ��¼��Ŀͻ���ͬ 3 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 3)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  �Լ��� manager �Ŀͻ���ͬ 2 */
    declare contractid_cursor cursor for
    select id from CRM_Contract where manager = @resourceid_1 
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 2)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor



    /* ��Ϊ�ͻ���ͬ����Ա�ܿ����� */
    declare roleids_cursor cursor for
    select roleid from SystemRightRoles where rightid = 396
    open roleids_cursor 
    fetch next from roleids_cursor into @contractroleid_1
    while @@fetch_status=0
    begin 

       declare rolecontractid_cursor cursor for
       select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1 ) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ));
       
        open rolecontractid_cursor 
        fetch next from rolecontractid_cursor into @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
            if @countrec = 0  
            begin
                insert into @temptablevaluecontract values(@contractid_1, 2)
            end
            else
            begin
                select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                if @sharelevel_1 = 1
                begin
                     update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                end 
            end
            fetch next from rolecontractid_cursor into @contractid_1
        end
        close rolecontractid_cursor deallocate rolecontractid_cursor
        
     fetch next from roleids_cursor into @contractroleid_1
     end
     close roleids_cursor deallocate roleids_cursor	 


    /* �ɿͻ���ͬ�Ĺ�����õ�Ȩ�� 1 2 */
    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor



    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor


    /* �Լ��¼��Ŀͻ���ͬ  (�ͻ�������������)*/
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where ( t1.manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and (t2.crmId = t1.id)
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  �Լ��� manager �Ŀͻ� (�ͻ�������������) */
    declare contractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where (t1.manager = @resourceid_1 ) and (t2.crmId = t1.id)
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor


    /* ɾ��ԭ�е������Ա��ص�����Ȩ */
    delete from ContractShareDetail where userid = @resourceid_1 and usertype = 1

    /* ����ʱ���е�����д�빲���� */
    declare allcontractid_cursor cursor for
    select * from @temptablevaluecontract
    open allcontractid_cursor 
    fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    end
    close allcontractid_cursor deallocate allcontractid_cursor

end        /* ������ɫɾ�����߼��𽵵͵Ĵ��� */



    
    /*================== �����ճ� ==================*/
    DECLARE @TmpTableValueWP TABLE (workPlanId int, shareLevel int)
    
    /* �����˱����ճ� */
    DECLARE creater_cursor CURSOR FOR
	SELECT id FROM WorkPlan WHERE createrId = @resourceid_1 
	OPEN creater_cursor 
	FETCH NEXT FROM creater_cursor INTO @workPlanId_1
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 2)
		FETCH NEXT FROM creater_cursor INTO @workPlanId_1
	END
	CLOSE creater_cursor 
    DEALLOCATE creater_cursor

    /* ���Կ����������¼��ճ� */     
    SET @managerstr_11 = '%,' + CONVERT(varchar(5), @resourceid_1) + ',%' 
    DECLARE underling_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE ',' + MANAGERSTR LIKE @managerstr_11))
    OPEN underling_cursor 
    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1
        IF (@countrec = 0)
        	INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 1)
        FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    END
    CLOSE underling_cursor 
    DEALLOCATE underling_cursor     


    /* ���Կ����ճ̹��������е��ճ� */
    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT workPlanShare.workPlanId, workPlanShare.shareLevel
    FROM WorkPlanShare workPlanShare
    WHERE 
    (
    /* ������ */
    (workPlanShare.forAll = 1 AND workPlanShare.securityLevel <= @seclevel_1)
    /* ������Դ */
    OR (workPlanShare.userId LIKE '%,'+cast(@resourceid_1 as varchar(10))+',%')
    /* ���� */
    OR (workPlanShare.deptId LIKE '%,'+cast(@departmentid_1 as varchar(10))+',%' AND workPlanShare.securityLevel <= @seclevel_1) 
    /* �ֲ� */
    OR (workPlanShare.subCompanyId LIKE '%,'+cast(@subcompanyid_1 as varchar(10))+',%' AND workPlanShare.securityLevel <= @seclevel_1)
    )     
    
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0)
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    /* ��ɫ */
    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT workPlanShare.workPlanId, workPlanShare.shareLevel
    FROM WorkPlan workPlan, WorkPlanShare workPlanShare, HrmRoleMembers hrmRoleMembers
    WHERE 
    (
        workPlan.id = workPlanShare.workPlanId 
        AND workPlanShare.roleId = hrmRoleMembers.roleId 
        AND hrmRoleMembers.resourceid = @resourceid_1 
        AND hrmRoleMembers.rolelevel >= workPlanShare.roleLevel 
        AND workPlanShare.securityLevel <= @seclevel_1
    )    
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0)
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor


    /* ����ʱ��д����ϸ�� */
    DECLARE allwp_cursor CURSOR FOR
    SELECT * FROM @TmpTableValueWP
    OPEN allwp_cursor 
    FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
			IF (@countrec = 0)
			BEGIN
			    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel)  VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
			END
			ELSE IF (@sharelevel_1 = 2)
			BEGIN
			    UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */   
			END
			FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
    CLOSE allwp_cursor 
    DEALLOCATE allwp_cursor
    
    /* �ճ̹������� */
    

GO