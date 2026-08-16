create or replace package body cwip_rec_payment_workflow as

--1)   Get Max step_no in HRSS_APPROVAL_HISTORY for specific request

    FUNCTION get_max_step (
        P_payment_recommendation_id NUMBER
    ) RETURN NUMBER IS
        l_count NUMBER;
    BEGIN
        SELECT
            nvl(MAX(step_no), 0)
        INTO l_count
        FROM
            CWIP_PAYMENT_REC_APPROVAL_HISTORY
        WHERE
            payment_recommendation_id = P_payment_recommendation_id;

        RETURN l_count;
    END get_max_step;
--
---- ********************  End *****************

-- *****************************************************************************************************************************
FUNCTION VALIDATE_PAYMENT_REC(P_PAYMENT_RECOMMENDATION_ID    NUMBER) RETURN BOOLEAN AS
l_project_manager_count               NUMBER;
l_senior_project_manager_count        NUMBER;
l_general_project_manager_count       NUMBER;
l_contract_manager_count              NUMBER;
l_result                              BOOLEAN DEFAULT true;
--l_error_message
BEGIN
--1 Check Senior Project Manager
select count(t.person_id)
into l_senior_project_manager_count
from cwip_team t
where t.project_number in (
                        select ccp.project_number from cwip_contract_projects ccp
                        where ccp.contract_number in (
                                            select cpr.contract_number
                                            from cwip_payment_recommendation cpr
                                            where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                            and t.role_id = 10  -- 1(PMC),2(Cost Cons),4(Lead Cons) / 10(Senior Project Manager), 11(Contract Manager), 5(PME Dir), 7(TPC Dir), 8(Finance)
                                            and t.status = 'A'
                                            and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));
if l_senior_project_manager_count = 0 THEN
    l_result := false;
    l_error_message := l_error_message || ' - ' || 'No Senior Project Manager Assigned' ;
End if;    

--2 Check Contract Manager
select count(t.person_id)
into l_contract_manager_count
from cwip_team t
where t.project_number in (
                        select ccp.project_number from cwip_contract_projects ccp
                        where ccp.contract_number in (
                                            select cpr.contract_number
                                            from cwip_payment_recommendation cpr
                                            where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                            and t.role_id = 11  -- 1(PMC),2(Cost Cons),4(Lead Cons) / 10(Senior Project Manager), 11(Contract Manager), 5(PME Dir), 7(TPC Dir), 8(Finance)
                                            and t.status = 'A'
                                            and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));
if l_contract_manager_count = 0 THEN
    l_result := false;
    l_error_message := l_error_message || ' - ' || 'No Contract Manager Assigned' ;
End if; 

--3 Check General Project Manager
select count(t.person_id)
into l_general_project_manager_count
from cwip_team t
where t.project_number in (
                        select ccp.project_number from cwip_contract_projects ccp
                        where ccp.contract_number in (
                                            select cpr.contract_number
                                            from cwip_payment_recommendation cpr
                                            where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                            and t.role_id = 12  -- 1(PMC),2(Cost Cons),4(Lead Cons) / 10(Senior Project Manager), 11(Contract Manager), 5(PME Dir), 7(TPC Dir), 8(Finance)
                                            and t.status = 'A'
                                            and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));
if l_contract_manager_count = 0 THEN
    l_result := false;
    l_error_message := l_error_message || ' - ' || 'No General Project Manager Assigned.' ;
End if; 


return l_result;
END VALIDATE_PAYMENT_REC;
---- ********************  End *****************

-- *****************************************************************************************************************************

--1) Insert Submit User Details into CWIP_PAYMENT_REC_APPROVAL_HISTORY 
  procedure insert_submit_user        (P_payment_recommendation_id    number) as
  begin
    
    -- Insert 
INSERT INTO cwip_payment_rec_approval_history (
    payment_recommendation_id,
    step_no,
    person_id,
    person_type,
    role_id,
    action_required,
    recevied_date,
    status,
    action_date,
    approval_type
) VALUES (
    p_payment_recommendation_id,
    cwip_rec_payment_workflow.get_max_step(p_payment_recommendation_id) + 1,
    NV('PERSON_ID'),     -- APPLICATION ITEM
    V('PERSON_TYPE'),    --    'EXT',
    NV('ROLE_ID'),       -- APPLICATION_ITEM
        'Submit',
    systimestamp,
    'Submitted',
    systimestamp,
    'REC_PAYMENT_APPROVAL'
);

    --2- Update CWIP_PAYMENT_REC_APPROVAL_HISTORY status
    update cwip_payment_recommendation
    set approval_status = 'In-Progress',
        submitted_on = systimestamp,
        submitted_by = NV('PERSON_ID'),
        submitted_by_person_type = V('PERSON_TYPE')
    where payment_recommendation_id = p_payment_recommendation_id;

    

  end insert_submit_user;
---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_PROJECT_MANAGER(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get Project Manager Count
select count(t.person_id) 
into l_pme_count
from cwip_team t
where t.project_number in (
select ccp.project_number from cwip_contract_projects ccp
where ccp.contract_number in (
select cpr.contract_number
from cwip_payment_recommendation cpr
where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
and t.role_id = 9  -- for Project Manager role
and t.status = 'A'
and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

-- if Project Manager Exist
if l_pme_count > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of Senior project manager 
for pme_person_id in (
                    select t.person_id 
                    from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                        select cpr.contract_number
                                                                        from cwip_payment_recommendation cpr
                                                                        where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                        and t.role_id = 9  -- for Project Manager role
                                                                        and t.status = 'A'
                                                                        and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop PME Serior Project Manager
                        --3.1) Insert Senior Project Manager Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for Senior Project Manager
                                                'INT',
                                                9,       -- 9 for (PM & E Project Manager) Role
--                                                    'Approve/Reject',
                                                    'Recommend/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'
                                    );
                    
                    --3) End loop PME Serior Project Manager 
                    End Loop;

End if;


END INSERT_PROJECT_MANAGER;

---- ********************  End *****************
-- *****************************************************************************************************************************
-- *****************************************************************************************************************************
PROCEDURE INSERT_PME_REVIEWER(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get Project Reviewers Count
select nvl(count(t.person_id) , 0)
into l_pme_count
from cwip_team t
where t.project_number in (
select ccp.project_number from cwip_contract_projects ccp
where ccp.contract_number in (
select cpr.contract_number
from cwip_payment_recommendation cpr
where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
and t.role_id = 14  -- for PME Reviewers role
and t.status = 'A'
and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

-- if Project Manager Exist
if l_pme_count > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of Senior project manager 
for pme_person_id in (
                    select t.person_id 
                    from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                        select cpr.contract_number
                                                                        from cwip_payment_recommendation cpr
                                                                        where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                        and t.role_id = 14  -- for PME Reviewers role
                                                                        and t.status = 'A'
                                                                        and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop PME Serior Project Manager
                        --3.1) Insert Senior Project Manager Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewer
                                                'INT',
                                                14,       -- 14  -- for PME Reviewers role
--                                                    'Approve/Reject',
                                                    'Recommend/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'
                                    );
                    
                    --3) End loop PME Reviewer
                    End Loop;

End if;


END INSERT_PME_REVIEWER;

---- ********************  End *****************
-- *****************************************************************************************************************************
-- *****************************************************************************************************************************
PROCEDURE INSERT_PME_SITE_REVIEWER(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get Project Reviewers Count
select nvl(count(t.person_id) , 0)
into l_pme_count
from cwip_team t
where t.project_number in (
select ccp.project_number from cwip_contract_projects ccp
where ccp.contract_number in (
select cpr.contract_number
from cwip_payment_recommendation cpr
where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
and t.role_id = 20	  -- for PME Site Reviewer role
and t.status = 'A'
and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

-- if Project Manager Exist
if l_pme_count > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of Senior project manager 
for pme_person_id in (
                    select t.person_id 
                    from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                        select cpr.contract_number
                                                                        from cwip_payment_recommendation cpr
                                                                        where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                        and t.role_id = 20	  -- for PME Site Reviewer role
                                                                        and t.status = 'A'
                                                                        and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop PME Serior Project Manager
                        --3.1) Insert Senior Project Manager Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewer
                                                'INT',
                                                20,       -- 20	  -- for PME Site Reviewer role
--                                                    'Approve/Reject',
                                                    'Recommend/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'
                                    );
                    
                    --3) End loop PME Reviewer
                    End Loop;

End if;


END INSERT_PME_SITE_REVIEWER;

---- ********************  End *****************
-- *****************************************************************************************************************************
PROCEDURE INSERT_PME_PROJ_DOC_CONTLR(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get INSERT_PME_DOC_CONTLR 
-- Role_id = 18 : PME Project Document Controller
-- if PME Reviewers Exist
if CWIP_REC_PAYMENT_UTIL.pme_cwip_role_count(18,P_PAYMENT_RECOMMENDATION_ID) > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of PME Reviewers 
for pme_person_id in (
                    select t.person_id
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 18  -- for PME Project Document Controller role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop PME Reviewers
                        --3.1) Insert PME Reviewers Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewers
                                                'INT',
                                                18,       -- 18 for PME Project Document Controller Role
--                                                    'Recommend/Return',
                                                    'Forward/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop PME Reviewers
                    End Loop;

End if;


END INSERT_PME_PROJ_DOC_CONTLR;

---- ********************  End *****************
-- *****************************************************************************************************************************
PROCEDURE INSERT_SENIOR_PROJECT_MANAGER(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of Senior project manager 
for pme_person_id in (
                    select t.person_id from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                select cpr.contract_number
                                                                from cwip_payment_recommendation cpr
                                                                where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                and t.role_id = 10  -- for Senior Project Manager
                                                                and t.status = 'A'
                                                                and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                     )
                    LOOP
                    --3) start loop PME Serior Project Manager
                        --3.1) Insert Senior Project Manager Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for Senior Project Manager
                                                'INT',
                                                10,       -- 10 for (PM & E Senior Project Manager) Role
                                                    'Approve/Reject',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop PME Serior Project Manager 
                    End Loop;




END INSERT_SENIOR_PROJECT_MANAGER;

---- ********************  End *****************
-- *****************************************************************************************************************************
-- *****************************************************************************************************************************
PROCEDURE INSERT_PME_HQ_DOC_CONTLR (P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get INSERT_PME_HQ_DOC_CONTLR 
-- Role_id = 19 : PME HQ Document Controller
-- if PME Reviewers Exist
if CWIP_REC_PAYMENT_UTIL.pme_cwip_role_count(19,P_PAYMENT_RECOMMENDATION_ID) > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of PME Reviewers 
for pme_person_id in (
                    select t.person_id
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 19  -- for PME HQ Document Controller role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop PME Reviewers
                        --3.1) Insert PME Reviewers Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewers
                                                'INT',
                                                19,       -- 19 for PME HQ Document Controller Role
--                                                    'Recommend/Return',
                                                    'Forward/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop PME Reviewers
                    End Loop;

End if;


END INSERT_PME_HQ_DOC_CONTLR;

---- ********************  End *****************
---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_GENERAL_PM(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_gpm_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of Senior project manager 
for gpm_person_id in (
                    select distinct t.person_id 
                    from cwip_team t 
                    where t.role_id = 12  -- for General PM role
                    and t.person_type = 'INT'
                    and t.status = 'A'
                    and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) 
                    and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                     )
                    LOOP
                    --3) start loop General Project Manager
                        --3.1) Insert General Project Manager Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                gpm_person_id.person_id ,     -- Person Id for general Project Manager
                                                'INT',
                                                12,       -- 12 for (General Project Manager) Role
                                                'Approve/Reject',
                                                NULL,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(gpm_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop General Project Manager 
                    End Loop;




END INSERT_GENERAL_PM;

---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_PME_DIRECTOR(P_PAYMENT_RECOMMENDATION_ID NUMBER, P_STATUS  VARCHAR) AS
l_PME_direcor_person_id     Number;
BEGIN

--1) get Person ID of PM&E Director
select person_id 
into l_pme_direcor_person_id
from employees_v where employee_num = (
select manager_emp_num
from organizations_v
where org_id = (select cwip_payments_configuration.pme_org_id 
                  from cwip_payments_configuration
                  where ID = 1));

--2) IF Check Person ID 
IF l_pme_direcor_person_id is NOT NULL THEN
        --2.1) Person ID Exist
                --2.1.1 Insert Approval History
                INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                cwip_rec_payment_workflow.get_max_step(p_payment_recommendation_id) + 1,
                                                l_pme_direcor_person_id ,     -- Person Id for PME Direcor
                                                'INT',
                                                5,       -- 5 for (PM & E Director) Role
                                                    'Approve/Reject',
                                                NULL,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(l_pme_direcor_person_id)
                                                , 'New'                                                
                                    );
                        -- End 2.1.1 -->
                -- End 2.1 -->
                ELSE
        -- 2.2) No PME Person ID Found
        raise_application_error(-20003, 'There is no PME Director found, Please contact System Administrator');
        -- End 2.2 No PME Person ID Found
--End (2) IF Check Person ID 
End IF;

END INSERT_PME_DIRECTOR;

---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_TPC_DIRECTOR(P_PAYMENT_RECOMMENDATION_ID NUMBER, P_STATUS  VARCHAR) AS
l_TPC_direcor_person_id     Number;
BEGIN

--1) get Person ID of TPC Director
select person_id 
into l_TPC_direcor_person_id
from employees_v where employee_num = (
select manager_emp_num
from organizations_v
where org_id = (select cwip_payments_configuration.tpc_org_id 
                  from cwip_payments_configuration
                  where ID = 1));

--2) IF Check Person ID 
IF l_TPC_direcor_person_id is NOT NULL THEN
        --2.1) Person ID Exist
                --2.1.1 Insert Approval History
                INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                cwip_rec_payment_workflow.get_max_step(p_payment_recommendation_id) + 1,
                                                l_TPC_direcor_person_id ,     -- Person Id for PME Direcor
                                                'INT',
                                                7,       -- 7 for (TPC Director) Role
                                                    'Approve/Reject',
                                                NULL,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(l_TPC_direcor_person_id)
                                                , 'New'                                                
                                    );
                        -- End 2.1.1 -->
                -- End 2.1 -->
                ELSE
        -- 2.2) No PME Person ID Found
        raise_application_error(-20003, 'There is no TPC Director found, Please contact System Administrator');
        -- End 2.2 No PME Person ID Found
--End (2) IF Check Person ID 
End IF;

END INSERT_TPC_DIRECTOR;

---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_CWIP_FINANCE(P_PAYMENT_RECOMMENDATION_ID NUMBER, P_STATUS  VARCHAR) AS
l_cwip_finance_person_id     Number;
BEGIN

--1) get Person ID of TPC Director
select person_id 
into l_cwip_finance_person_id
from employees_v where employee_num = (
select manager_emp_num
from organizations_v
where org_id = (select cwip_payments_configuration.cwip_org_id
                  from cwip_payments_configuration
                  where ID = 1));

--2) IF Check Person ID 
IF l_cwip_finance_person_id is NOT NULL THEN
        --2.1) Person ID Exist
                --2.1.1 Insert Approval History
                INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                cwip_rec_payment_workflow.get_max_step(p_payment_recommendation_id) + 1,
                                                l_cwip_finance_person_id ,     -- Person Id for PME Direcor
                                                'INT',
                                                8,       -- 8 for (CWIP Finance) Role
                                                    'Approve/Reject',
                                                NULL,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(l_cwip_finance_person_id)
                                                , 'New'                                                
                                    );
                        -- End 2.1.1 -->
                -- End 2.1 -->
                ELSE
        -- 2.2) No CWIP FInance Person ID Found
        raise_application_error(-20003, 'There is no CWIP Finance Employee found, Please contact System Administrator');
        -- End 2.2 No CWIP FINANCE Person ID Found
--End (2) IF Check Person ID 
End IF;

END INSERT_CWIP_FINANCE;

---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_TPC_USER(P_PAYMENT_RECOMMENDATION_ID NUMBER,P_STATUS  VARCHAR)
IS
l_tpc_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of TPC Contract Manager 
for tpc_person_id in (
                    select t.person_id from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                select cpr.contract_number
                                                                from cwip_payment_recommendation cpr
                                                                where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                and t.role_id = 11  -- 11 for Contract Manager
                                                                and t.status = 'A'
                                                                and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                     )
                    LOOP
                    --3) start loop TPC Contract Manager
                        --3.1) Insert TPC Contract Manager Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                tpc_person_id.person_id ,     -- Person Id for Contract Manager
                                                'INT',
                                                11,       -- 11 for (Contract Manager) Role
                                                'Approve/Reject',
                                                NULL,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(tpc_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop Contract Manager 
                    End Loop;


End INSERT_TPC_USER;

---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_PMC_USER(P_PAYMENT_RECOMMENDATION_ID NUMBER,P_STATUS  VARCHAR)
IS
l_pmc_count           number;
l_step_no             number;
--l_degated_count       number;
BEGIN

--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of TPC Contract Manager 
for pmc_person_id in (
                    select t.person_id from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                select cpr.contract_number
                                                                from cwip_payment_recommendation cpr
                                                                where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                and t.role_id = 1  -- 1 for PMC role
                                                                and t.status = 'A'
                                                                and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                     )
                    LOOP
                    --3) start loop PMC
                        --3.1) Insert PMC Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
--                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pmc_person_id.person_id ,     -- Person Id for PMC
                                                'EXT',
                                                1,       -- 1 for (PMC) Role
                                                'Approve/Reject',
                                                 Case P_STATUS 
                                                        when 'Pending' Then systimestamp
                                                            else null
                                                 End ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
--                                                ,user_details.get_emp_Email(pmc_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop PMC 
                    End Loop;


End INSERT_PMC_USER;

---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_COST_CONSULTANT(P_PAYMENT_RECOMMENDATION_ID NUMBER,P_STATUS  VARCHAR)
IS
l_CC_count           number;
l_step_no             number;
--l_degated_count       number;
BEGIN

--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of CC (Cost Consultant) 
for cc_person_id in (
                    select t.person_id from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                select cpr.contract_number
                                                                from cwip_payment_recommendation cpr
                                                                where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                and t.role_id = 2  -- 2 for cc (Cost Consultant)
                                                                and t.status = 'A'
                                                                and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                     )
                    LOOP
                    --3) start loop CC (Cost Consultant)
                        --3.1) Insert CC (Cost Consultant) Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
--                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                cc_person_id.person_id ,     -- Person Id for CC (Cost Consultant)
                                                'EXT',
                                                2,       -- 2 for (CC) Role
                                                'Approve/Reject',
                                                 Case P_STATUS 
                                                        when 'Pending' Then systimestamp
                                                            else null
                                                 End ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
--                                                ,user_details.get_emp_Email(cc_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop CCC 
                    End Loop;


End INSERT_COST_CONSULTANT;

---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_LEAD_CONSULTANT(P_PAYMENT_RECOMMENDATION_ID NUMBER,P_STATUS  VARCHAR)
IS
l_LC_count           number;
l_step_no             number;
--l_degated_count       number;
BEGIN

--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of LC (Lead Consultant) 
for lc_person_id in (
                    select t.person_id from cwip_team t
                    where t.project_number in (
                                            select ccp.project_number from cwip_contract_projects ccp
                                            where ccp.contract_number in (
                                                                select cpr.contract_number
                                                                from cwip_payment_recommendation cpr
                                                                where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
                                                                and t.role_id = 3  -- 3 for lc ((Lead Consultant))
                                                                and t.status = 'A'
                                                                and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                     )
                    LOOP
                    --3) start loop LC (Lead Consultant)
                        --3.1) Insert LC (Lead Consultant) Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
--                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                lc_person_id.person_id ,     -- Person Id for LC (Lead Consultant)
                                                'EXT',
                                                3,       -- 3 for (LC)(Lead Consultant) Role
                                                'Approve/Reject',
                                                 Case P_STATUS 
                                                        when 'Pending' Then systimestamp
                                                            else null
                                                 End ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
--                                                ,user_details.get_emp_Email(lc_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop LC 
                    End Loop;


End INSERT_LEAD_CONSULTANT;
-- ************* END *************************************************
--- Additional Roles 29-OCT-2021 
---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_PME_REVIEWERS(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get PME Reviewers
select count(t.person_id) 
into l_pme_count
from cwip_team t
where  (t.project_number in (
							select ccp.project_number 
							from cwip_contract_projects ccp
							where ccp.contract_number in (	select cpr.contract_number
																from cwip_payment_recommendation cpr
																where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
														)
						)
    or t.project_number is null                    
                        )
and t.role_id = 14  -- for PME Reviewer role
and t.status = 'A'
and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

-- if PME Reviewers Exist
if l_pme_count > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of PME Reviewers 
for pme_person_id in (
                    select t.person_id
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 14  -- for PME Reviewer role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop PME Reviewers
                        --3.1) Insert PME Reviewers Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewers
                                                'INT',
                                                14,       -- 14 for PME Reviewers Role
--                                                    'Recommend/Return',
                                                    'Recommend/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop PME Reviewers
                    End Loop;

End if;


END INSERT_PME_REVIEWERS;

---- ********************  End *****************
---- ********************  End *****************

-- *****************************************************************************************************************************
PROCEDURE INSERT_TPC_REVIEWERS(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get TPC Reviewers
select count(t.person_id) 
into l_pme_count
from cwip_team t
where  (t.project_number in (
							select ccp.project_number 
							from cwip_contract_projects ccp
							where ccp.contract_number in (	select cpr.contract_number
																from cwip_payment_recommendation cpr
																where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
														)
						)
    or t.project_number is null                    
                        )
and t.role_id = 15  -- for TPC Reviewer role
and t.status = 'A'
and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

-- if TPC Reviewers Exist
if l_pme_count > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of TPC Reviewers 
for pme_person_id in (
                    select t.person_id 
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 15  -- for TPC Reviewer role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop TPC Reviewers
                        --3.1) Insert TPC Reviewers Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewers
                                                'INT',
                                                15,       -- 15 for TPC Reviewers Role
--                                                    'Recommend/Return',
                                                    'Recommend/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop TPC Reviewers
                    End Loop;

End if;


END INSERT_TPC_REVIEWERS;

---- ********************  End *****************
-- *****************************************************************************************************************************
PROCEDURE INSERT_TPC_TECHNICAL_SUPPORT(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get TPC Reviewers
select count(t.person_id) 
into l_pme_count
from cwip_team t
where  (t.project_number in (
							select ccp.project_number 
							from cwip_contract_projects ccp
							where ccp.contract_number in (	select cpr.contract_number
																from cwip_payment_recommendation cpr
																where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
														)
						)
    or t.project_number is null                    
                        )
and t.role_id = 13  -- for TPC Technical Support Officer role
and t.status = 'A'
and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

-- if TPC Reviewers Exist
if l_pme_count > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of TPC Reviewers 
for pme_person_id in (
                    select t.person_id 
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 13  -- for TPC Technical Support Officer role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop TPC Reviewers
                        --3.1) Insert TPC Reviewers Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewers
                                                'INT',
                                                13,       -- 13 for TPC Technical Support Officer
                                                    'FYI',
--                                                    'Recommend/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop TPC Reviewers
                    End Loop;

End if;


END INSERT_TPC_TECHNICAL_SUPPORT;

---- ********************  End *****************
-- *****************************************************************************************************************************
PROCEDURE INSERT_FINANCE_REVIEWER(P_PAYMENT_RECOMMENDATION_ID  NUMBER, P_STATUS  VARCHAR) AS
l_pme_count           number;
l_step_no             number;
l_degated_count       number;
BEGIN

-- get Finance Reviewers
select count(t.person_id) 
into l_pme_count
from cwip_team t
where  (t.project_number in (
							select ccp.project_number 
							from cwip_contract_projects ccp
							where ccp.contract_number in (	select cpr.contract_number
																from cwip_payment_recommendation cpr
																where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
														)
						)
    or t.project_number is null                    
                        )
and t.role_id = 16  -- for Finance Reviewers role
and t.status = 'A'
and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

-- if Finance Reviewers Exist
if l_pme_count > 0 Then
--1) get Max Step
l_step_no := cwip_rec_payment_workflow.get_max_step(P_PAYMENT_RECOMMENDATION_ID) + 1;

--2) get count of Finance Reviewers 
for pme_person_id in (
                    select t.person_id 
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 16  -- for Finance Reviewers role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     --3) start loop Finance Reviewers
                        --3.1) Insert Finance Reviewers Record
                        INSERT INTO cwip_payment_rec_approval_history (
                                                payment_recommendation_id,
                                                step_no,
                                                person_id,
                                                person_type,
                                                role_id,
                                                action_required,
                                                recevied_date,
                                                status,
                                                action_date,
                                                approval_type
                                                ,app_id 	
                                                ,approval_type_code	
                                                ,email			
                                                , n_status                                                
                                    ) VALUES (
                                                p_payment_recommendation_id,
                                                l_step_no,
                                                pme_person_id.person_id ,     -- Person Id for PME Reviewers
                                                'INT',
                                                16,       -- 16 for Finance Reviewers
--                                                    'FYI',
                                                    'Recommend/Return',
                                                case P_STATUS when 'Pending'
                                                                    then systimestamp
                                                                    else null
                                                end ,
                                                P_STATUS,
                                                NULL,
                                                'REC_PAYMENT_APPROVAL'
                                                ,NV('APP_ID')
                                                ,'CWIP'
                                                ,user_details.get_emp_Email(pme_person_id.person_id)
                                                , 'New'                                                
                                    );
                    
                    --3) End loop Finance Reviewers
                    End Loop;

End if;


END INSERT_FINANCE_REVIEWER;

---- ********************  End *****************

-- End of Additonal Role 29-OCT-2021

-- Approve CWIP Payment ------------------------------------------

PROCEDURE approve (P_PAYMENT_RECOMMENDATION_ID IN number,
                   p_person_id                 IN number,
                   P_COMMENT                   VARCHAR2) IS
l_approval_type         VARCHAR2(255);
l_max_step              NUMBER;
l_id                    NUMBER;
l_step_no               NUMBER;
--l_ap_count              number;
--l_dublicate_approver    VARCHAR2(1);
--l_id_next_step          NUMBER;          
l_action_required                varchar2(255);
    
BEGIN

 -- 1) GET ID , STEP_NO
 SELECT    id,   step_no, approval_type , action_required
INTO     l_id, l_step_no,  l_approval_type , l_action_required
 FROM    cwip_payment_rec_approval_history
  WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
    AND status = 'Pending'
    AND person_id = p_person_id;
--DBMS_OUTPUT.PUT_LINE( 'l_step_no ,l_id ' || l_step_no || ',' ||l_id); 

 -- 2) GET MAX STEPS

        SELECT   MAX(step_no)
        INTO  l_max_step
        FROM    cwip_payment_rec_approval_history
        WHERE payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
        AND action_required != 'FYI';
        
--DBMS_OUTPUT.PUT_LINE( 'l_max_step ' || l_max_step);

--3) IF1) Check if this is the final Approver
IF l_max_step - l_step_no = 0 THEN

        -- 3.1) Final Approval Actions
        -- 3.1.1) update approval history table
                UPDATE cwip_payment_rec_approval_history
                SET status = 'Approved',
                    action_date = systimestamp, 
                    comments = P_COMMENT, n_status = 'Expired'
                WHERE  id = l_id;
         --3.1.2) update cwip_payment_recommendation table
                UPDATE cwip_payment_recommendation
                SET  approval_status = 'Approved' , final_approve_on = systimestamp
                WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID; 
            
          -- to update "Beaten"  in the same approval level
          UPDATE cwip_payment_rec_approval_history
         SET    status = 'Beaten', action_date = systimestamp, n_status = 'Expired'
          WHERE  id <> l_id
          and status = 'Pending'   -- to exclude Delegated records
          and  step_no = l_step_no
          and PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;  
          
               
         --3.1.3) ction Final update FYI
         -- // TODO
         
         --3.1.4) Send Email FYI
         -- // TODO
         for fyi_person_id in (
                    select t.person_id ,PERSON_TYPE
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 17  -- for Final FYI Approval / Reject role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     cwip_rec_payment_emails.SEND_REC_PAYMENT_FYI_APPROVE_EMAIL(P_PAYMENT_RECOMMENDATION_ID ,fyi_person_id.person_id , fyi_person_id.PERSON_TYPE , P_COMMENT);
                     End loop;
         
         --3.1.5) Send Email to the initiator
        -- // TODO
        for emp in (select submitted_by , submitted_by_person_type
                    from cwip_payment_recommendation
                    where payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID )
        loop
        
        cwip_rec_payment_emails.SEND_REC_PAYMENT_FINAL_APPROVE_EMAIL(P_PAYMENT_RECOMMENDATION_ID,emp.submitted_by, emp.submitted_by_person_type , P_COMMENT  );
        
        End loop;
        
        -- Send FYI Email for The releated 9 - PM/ 10- Senior PM/12 General PM /15	TPC Reviewers
        for pme in (select distinct PERSON_ID, PERSON_TYPE
                    from cwip_payment_rec_approval_history
                    where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
                    and ROLE_ID in (9,10,12,15))
            LOOP
           cwip_rec_payment_emails.SEND_REC_PAYMENT_FINAL_APPROVE_EMAIL(P_PAYMENT_RECOMMENDATION_ID, pme.PERSON_ID , pme.PERSON_TYPE , P_COMMENT  ); 
            
            End LOOP;
        --3.1.6) Update Actions History
        -- //TODO
        
        
        -- 3.1) End **** Final Approval Actions -- End
        ELSE
    --3.2) Ongoing Approval Actions
        --3.2.1) Update current user in approval history table 
         UPDATE cwip_payment_rec_approval_history
         SET    status = case l_action_required when 'Approve/Reject'   then 'Approved'
                                                when 'Recommend/Return' then 'Recommend'
                                                when 'Forward/Return'   then 'Forward'
                                                else 'Approved'
                        end
         , action_date = systimestamp, comments = P_COMMENT, n_status = 'Expired'
         WHERE  id = l_id;
         
         -- to update "Beaten"  in the same approval level
          UPDATE cwip_payment_rec_approval_history
         SET    status = 'Beaten', action_date = systimestamp, n_status = 'Expired'
          WHERE  id <> l_id
          and status = 'Pending'   -- to exclude Delegated records
          and  step_no = l_step_no
          and PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;
          
            -- update cwip_payment_recommendation   approval_status if it was (Hold)
  update cwip_payment_recommendation
  set approval_status = 'In-Progress'
  where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
  and approval_status = 'Hold';
 
            -- 1) GET ID , STEP_NO for next Step
  
   SELECT    id,  approval_type     , action_required
    INTO    l_id, l_approval_type   , l_action_required
    FROM    cwip_payment_rec_approval_history
    WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
    AND     step_no = l_step_no + 1
    and rownum = 1;
  
         --3.2.2) Update Next User "Pending" in Approval history table
         if l_action_required = 'FYI' Then
            -- Update Next User FYI to be Notified in Approval history table
            update cwip_payment_rec_approval_history
            set status = 'Notified', recevied_date = systimestamp , action_date = systimestamp
            WHERE payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
             and action_required = 'FYI'
              AND step_no = l_step_no + 1; 

         --// TODO 
         -- Send FYI EMail
         for fyi_emp in (select person_id , person_type
                          FROM    cwip_payment_rec_approval_history
                            WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
                            AND     step_no = l_step_no + 1)
            LOOP
               cwip_rec_payment_emails.SEND_REC_PAYMENT_FYI_APPROVE_EMAIL(P_PAYMENT_RECOMMENDATION_ID, fyi_emp.person_id,fyi_emp.person_type,P_COMMENT );
           End LOOP;
         
         --//TODO End FYI Email
          UPDATE cwip_payment_rec_approval_history
          SET   status = 'Pending' 
                ,recevied_date = systimestamp
                ,hash_code = apex_util.get_hash(apex_t_varchar2(P_PAYMENT_RECOMMENDATION_ID, id ))
                ,trx_code = DBMS_RANDOM.STRING('X', 6)
          WHERE payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
          AND step_no = l_step_no + 2;
          
          else
            --Update Next User "Pending" in Approval history table
            UPDATE cwip_payment_rec_approval_history
          SET   status = 'Pending' 
                ,recevied_date = systimestamp
                ,hash_code = apex_util.get_hash(apex_t_varchar2(P_PAYMENT_RECOMMENDATION_ID, id ))
                ,trx_code = DBMS_RANDOM.STRING('X', 6)
          WHERE payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
          AND step_no = l_step_no + 1;
          
          -- to update "Beaten"  in the same approval level
          UPDATE cwip_payment_rec_approval_history
         SET    status = 'Beaten', action_date = systimestamp , n_status = 'Expired'
          WHERE  id <> l_id
          and status = 'Pending'   -- to exclude Delegated records
          and  step_no = l_step_no
          and PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;
         
         End if;
         --3.2.3) Send Mail to next approver
            -- //TODO : Send Email to next approver
           --*****************
            -- Send Email for Pending Users
            
            for emp in (select PERSON_ID , PERSON_TYPE ,id
            --            into l_person_id , l_PERSON_TYPE
                        from cwip_payment_rec_approval_history
                        where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
                        and STATUS = 'Pending')
                Loop
            
            cwip_rec_payment_emails.SEND_REC_PAYMENT_ACTION_REQUIRED_EMAIL(P_PAYMENT_RECOMMENDATION_ID , emp.PERSON_ID, emp.PERSON_TYPE ,emp.id );
         
                End Loop; 
         
    --3.2) End **** Ongoing Approval Actions -- End
        END IF; 




End approve;
-- ************* END *************************************************
-- ************* END *************************************************
-- Reject CWIP Payment ------------------------------------------

PROCEDURE REJECTED (P_PAYMENT_RECOMMENDATION_ID IN number,
                   p_person_id                 IN number
                   ,P_COMMENT                   VARCHAR2) IS
l_approval_type         VARCHAR2(255);
l_max_step              NUMBER;
l_id                    NUMBER;
l_step_no               NUMBER;
--l_ap_count              number;
--l_dublicate_approver    VARCHAR2(1);
--l_id_next_step          NUMBER;  
l_action_required       varchar2(255);
    
BEGIN

 -- 1) GET ID , STEP_NO
 SELECT    id,   step_no, approval_type , action_required
INTO     l_id, l_step_no,  l_approval_type, l_action_required
 FROM    cwip_payment_rec_approval_history
  WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
    AND status = 'Pending'
    AND person_id = p_person_id;
--DBMS_OUTPUT.PUT_LINE( 'l_step_no ,l_id ' || l_step_no || ',' ||l_id); 

 -- 2) GET MAX STEPS

        SELECT   MAX(step_no)
        INTO  l_max_step
        FROM    cwip_payment_rec_approval_history
        WHERE payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
        AND action_required != 'FYI';
        
--DBMS_OUTPUT.PUT_LINE( 'l_max_step ' || l_max_step);
--3) Update cwip_payment_recommendation table

                UPDATE cwip_payment_recommendation
                SET approval_status = case l_action_required when  'Approve/Reject'     then 'Rejected' 
                                                             when  'Recommend/Return'   then 'Returned'
                                                             when  'Forward/Return'     then 'Returned'
                                                            else    'Rejected'
                                    end
                , final_approve_on = systimestamp
               WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID;
                
--4) Update approval history table

                UPDATE cwip_payment_rec_approval_history
                SET status =  case l_action_required when  'Approve/Reject'     then 'Rejected' 
                                                             when  'Recommend/Return'   then 'Returned'
                                                             when  'Forward/Return'     then 'Returned'
                                                            else    'Rejected'
                                    end,
                    action_date = systimestamp , comments = P_COMMENT
                    , n_status = 'Expired'
                WHERE  id = l_id;
                
    -- to update "Beaten"  in the same approval level
          UPDATE cwip_payment_rec_approval_history
         SET    status = 'Beaten', action_date = systimestamp 
                , n_status = 'Expired'
          WHERE  id <> l_id
          and status = 'Pending'   -- to exclude Delegated records
          and  step_no = l_step_no
          and PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;  
          
--5) delete future  from approval history
               DELETE FROM cwip_payment_rec_approval_history
               where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
               AND step_no > l_step_no;

--5) Reject any other Payment pending the person after seq_count



                
--6) Send Reject Email to the Initiator
         -- // TODO
       for emp in (select submitted_by , submitted_by_person_type
                    from cwip_payment_recommendation
                    where payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID )
        loop
        
        cwip_rec_payment_emails.SEND_REC_PAYMENT_REJECT_EMAIL(P_PAYMENT_RECOMMENDATION_ID,emp.submitted_by, emp.submitted_by_person_type , P_COMMENT  );
        
        End loop;
--6) Send Reject Email to the Group Final FYI
    for fyi_person_id in (
                    select t.person_id ,PERSON_TYPE
					from cwip_team t
					where  (t.project_number in (
												select ccp.project_number 
												from cwip_contract_projects ccp
												where ccp.contract_number in (	select cpr.contract_number
																					from cwip_payment_recommendation cpr
																					where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
																			)
											)
						or t.project_number is null                    
											)
					and t.role_id = 17  -- for Final FYI Approval / Reject role
					and t.status = 'A'
					and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'))
                    )
                     Loop
                     cwip_rec_payment_emails.SEND_REC_PAYMENT_REJECT_EMAIL(P_PAYMENT_RECOMMENDATION_ID ,fyi_person_id.person_id , fyi_person_id.PERSON_TYPE , P_COMMENT);
                     End loop;

--7) Insert Reject Notification to the initiator
         -- // TODO
         
--8) Send Email to anyone approve befor
        -- // TODO

End REJECTED;
-- ************* END *************************************************
PROCEDURE STOP           (P_PAYMENT_RECOMMENDATION_ID   IN number) IS

l_approval_type         VARCHAR2(255);
l_max_step              NUMBER;
l_id                    NUMBER;
l_step_no               NUMBER;
l_ap_count              number;
l_dublicate_approver    VARCHAR2(1);
l_id_next_step          NUMBER;                   
    
BEGIN

 -- 1) GET ID , STEP_NO
 SELECT    id,   step_no, approval_type
INTO     l_id, l_step_no,  l_approval_type
 FROM    cwip_payment_rec_approval_history
  WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
    AND status = 'Pending'
    and rownum = 1;
--DBMS_OUTPUT.PUT_LINE( 'l_step_no ,l_id ' || l_step_no || ',' ||l_id); 

 -- 2) GET MAX STEPS

        SELECT   MAX(step_no)
        INTO  l_max_step
        FROM    cwip_payment_rec_approval_history
        WHERE payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
        AND action_required != 'FYI';
        
        --DBMS_OUTPUT.PUT_LINE( 'l_max_step ' || l_max_step);
        
--3) Update cwip_payment_recommendation table

                UPDATE cwip_payment_recommendation
                SET approval_status = 'Stopped'
               WHERE  payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID;
--4) Update approval history table

                UPDATE cwip_payment_rec_approval_history
                SET status = 'Stopped',
                    action_required = 'Stopped',
                    action_date = systimestamp 
                    , n_status = 'Expired'
                WHERE  id = l_id;
                
--5) delete future  from approval history
               DELETE FROM cwip_payment_rec_approval_history
               where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
               AND step_no >= l_step_no;
               
--6) INSERT STOPPED RECORDE IN APPROVAL HISTORY
        INSERT INTO cwip_payment_rec_approval_history (
            payment_recommendation_id,
            step_no,
            person_id,
            person_type,
            role_id,
            action_required,
            recevied_date,
            status,
            action_date,
            approval_type
            ,app_id 	
            ,approval_type_code	
            ,email			
            , n_status            
        ) VALUES (
            p_payment_recommendation_id,
            cwip_rec_payment_workflow.get_max_step(p_payment_recommendation_id) + 1,
            NV('PERSON_ID'),     -- APPLICATION ITEM
             V('PERSON_TYPE'),  -- APPLICATION ITEM
            NV('ROLE_ID'),       -- APPLICATION_ITEM
                'Stopped',
            systimestamp,
            'Stopped',
            systimestamp,
            'REC_PAYMENT_APPROVAL'
            ,NV('APP_ID')
            ,'CWIP'
            ,user_details.get_emp_Email(NV('PERSON_ID'))
            , 'Expired'            
        );



--7) Update Actions History
-- //TODO

--8) Insert Stopped Notification
--  //TODO


END STOP;
-- ************* END *************************************************
-- delegate Manual PR  ---------------------------------------------------------
PROCEDURE DELEGATE(P_PAYMENT_RECOMMENDATION_ID IN number,p_from_person_id  number,p_to_person_id  number)
IS
l_approval_type   VARCHAR2(255);
l_max_step        NUMBER;
l_id              NUMBER;
l_step_no           NUMBER;
l_ACTION_REQUIRED           varchar2(255);
l_ROLE_DESC                 varchar2(255);
l_ROLE_ID                   number;

BEGIN

 -- 1) GET ID , STEP_NO
        SELECT id, step_no, approval_type, ACTION_REQUIRED ,ROLE_ID
        INTO l_id, l_step_no, l_approval_type, l_ACTION_REQUIRED, l_ROLE_ID
        FROM
            cwip_payment_rec_approval_history
        WHERE
             PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
            AND status = 'Pending'
            and person_type = 'INT'
            and person_id = p_from_person_id;


-- 2) GET MAX STEPS

      SELECT   MAX(step_no)
        INTO l_max_step
        FROM    cwip_payment_rec_approval_history
        WHERE
             PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;
             
-- 3 update History                 
            -- update approval history
            UPDATE cwip_payment_rec_approval_history
            SET    status = 'Delegated',
                action_date = systimestamp
            WHERE  id = l_id;    
            

-- INSERT DELEGATED RECORDE IN APPROVAL HISTORY

INSERT INTO cwip_payment_rec_approval_history (
            payment_recommendation_id,
            step_no,
            person_id,
            person_type,
            role_id,
            action_required,
            recevied_date,
            status,
            action_date,
            approval_type,
            ON_BEHALF
            ,app_id 	
            ,approval_type_code	
            ,email			
            , n_status            
        ) VALUES (
            p_payment_recommendation_id,
            l_step_no,
            p_to_person_id,
            'INT',
            l_ROLE_ID,
             l_ACTION_REQUIRED,
            systimestamp,
            'Pending',
            null,
            'REC_PAYMENT_APPROVAL'
            ,'Y'     -- to indicate it's on-behalf 
            ,nvl(NV('APP_ID'),130)
            ,'CWIP'
            ,user_details.get_emp_Email(p_to_person_id)
            , 'New'            
        );            
--//TODO Send Email to the delegated Emp
    cwip_rec_payment_emails.SEND_DELEGATE_EMAIL(p_payment_recommendation_id ,p_from_person_id ,  p_to_person_id);

End DELEGATE;

-- ************* END *************************************************
-- MORE_INFO CWIP Payment ------------------------------------------------------
PROCEDURE MORE_INFO(P_PAYMENT_RECOMMENDATION_ID IN number,
                    p_from_person_id  number,p_to_person_id  number,
                    p_to_person_type  varchar2, to_role_id  number
                    , p_comment varchar2
                    , p_from_person_type     varchar2)
IS
l_approval_type   VARCHAR2(255);
l_max_step        NUMBER;
l_id              NUMBER;
l_step_no           NUMBER;
l_ACTION_REQUIRED           varchar2(255);
l_ROLE_DESC                 varchar2(255);
l_ROLE_ID                   number;

BEGIN

 -- 1) GET ID , STEP_NO
        SELECT id, step_no, approval_type, ACTION_REQUIRED ,ROLE_ID
        INTO l_id, l_step_no, l_approval_type, l_ACTION_REQUIRED, l_ROLE_ID
        FROM
            cwip_payment_rec_approval_history
        WHERE
             PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
            AND status = 'Pending'
            and person_type = 'INT'
            and person_id = p_from_person_id;


-- 2) GET MAX STEPS

      SELECT   MAX(step_no)
        INTO l_max_step
        FROM    cwip_payment_rec_approval_history
        WHERE
             PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;
             
-- 3 update History                 
            -- update approval history
            UPDATE cwip_payment_rec_approval_history
            SET    status = 'More Info',
                action_date = systimestamp
            WHERE  id = l_id;    
            

-- INSERT DELEGATED RECORDE IN APPROVAL HISTORY

INSERT INTO cwip_payment_rec_approval_history (
            payment_recommendation_id,
            step_no,
            person_id,
            person_type,
            role_id,
            action_required,
            recevied_date,
            status,
            action_date,
            approval_type
--            ON_BEHALF
            ,app_id 	
            ,approval_type_code	
            ,email			
            , n_status
        ) VALUES (
            p_payment_recommendation_id,
            l_step_no,
            p_to_person_id,
            p_to_person_type,
            to_role_id,
             'Additional Info',
            systimestamp,
            'Pending',
            null,
            'REC_PAYMENT_APPROVAL'
--            ,'Y'     -- to indicate it's on-behalf 
            , nvl(NV('APP_ID'), 130)
            ,'CWIP'
            ,user_details.get_emp_Email(p_to_person_id)
            , 'New'
        );            
--//TODO Send Email to the delegated Emp
cwip_rec_payment_emails.SEND_REC_PAYMENT_MORE_INFO_EMAIL(P_PAYMENT_RECOMMENDATION_ID,p_from_person_id,p_from_person_type, p_to_person_id,p_to_person_type,p_comment );

End MORE_INFO;
-- ************* END *************************************************
-- MORE_INFO Reply CWIP Payment ------------------------------------------------------
PROCEDURE MORE_INFO_REPLY(P_PAYMENT_RECOMMENDATION_ID   IN number,P_PERSON_SENDER_ID NUMBER, P_PERSON_SENDER_TYPE   VARCHAR2	,
                            P_PERSON_RECEIVER_ID 	NUMBER, P_PERSON_RECEIVER_TYPE   VARCHAR2,  P_REPLY  VARCHAR2)
IS
l_from              NUMBER; 
l_from_person_type  varchar2(3);  
l_to                NUMBER; 
l_to_person_type    varchar2(3);   
l_priority          varchar2(50);  
l_to_role_id        NUMBER;

l_approval_type   VARCHAR2(255);
l_max_step        NUMBER;
l_id              NUMBER;
l_step_no           NUMBER;
l_ACTION_REQUIRED           varchar2(255);
l_ROLE_DESC                 varchar2(255);
l_ROLE_ID                   number;

BEGIN

select m.FROM_PERSON_ID, m.FROM_PERSON_TYPE, m.TO_PERSON_ID, m.TO_PERSON_TYPE , m.priority
into   l_from  , l_from_person_type,  l_to , l_to_person_type , l_priority
from cwip_payment_rec_more_info m
where m.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
and m.to_person_id   = NV('PERSON_ID')
and m.to_person_type = V('PERSON_TYPE')
and m.id = (select max(x.id)
            from cwip_payment_rec_more_info x
            where  x.payment_recommendation_id = m.payment_recommendation_id);

-- Insert Reply
INSERT INTO cwip_payment_rec_more_info (
    payment_recommendation_id,
    from_person_id,
    from_person_type,
    to_person_id,
    to_person_type,
    action_required,
    priority,
    comments
) VALUES (
    P_PAYMENT_RECOMMENDATION_ID,
    NV('PERSON_ID'),
    V('PERSON_TYPE'),
    l_from,
    l_from_person_type,
    'Reply',
    l_priority,
    P_REPLY
);

-- //TODO Send Email to Requestor Additional Info
cwip_rec_payment_emails.SEND_REC_PAYMENT_MORE_INFO_UPDATES_EMAIL(P_PAYMENT_RECOMMENDATION_ID,
                                                                 P_PERSON_SENDER_ID,P_PERSON_SENDER_TYPE, 
                                                                 P_PERSON_RECEIVER_ID,P_PERSON_RECEIVER_TYPE ,
                                                                 P_REPLY    );

 -- 1) GET ID , STEP_NO
        SELECT id, step_no, approval_type, ACTION_REQUIRED ,ROLE_ID
        INTO l_id, l_step_no, l_approval_type, l_ACTION_REQUIRED, l_ROLE_ID
        FROM
            cwip_payment_rec_approval_history
        WHERE
             PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
            AND status = 'Pending'
            and person_type = V('PERSON_TYPE')
            and person_id = l_to ;


-- 2) GET MAX STEPS

      SELECT   MAX(step_no)
        INTO l_max_step
        FROM    cwip_payment_rec_approval_history
        WHERE
             PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;
             
-- 3 update History                 
            -- update approval history
            UPDATE cwip_payment_rec_approval_history
            SET    status = 'Replied',
                action_date = systimestamp
            WHERE  id = l_id;    
            
-- Get to_role_id
--
         select distinct ROLE_ID
            into l_to_role_id
        from cwip_payment_rec_approval_history h
        where h.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID
        and h.person_id =   l_from --l_from
        and h.person_type = 'INT' --l_from_person_type
        and ROWNUM = 1         ;
            
-- INSERT  RECORDE IN APPROVAL HISTORY

INSERT INTO cwip_payment_rec_approval_history (
            payment_recommendation_id,
            step_no,
            person_id,
            person_type,
            role_id,
            action_required,
            recevied_date,
            status,
            action_date,
            approval_type
--            ,ON_BEHALF
        ) VALUES (
            p_payment_recommendation_id,
            l_step_no,
            l_from,
            l_from_person_type,
            null,
             'Approve/Reject',
            systimestamp,
            'Pending',
            null,
            'REC_PAYMENT_APPROVAL'
--            ,'Y'     -- to indicate it's on-behalf 
        );            
--//TODO Send Email to the delegated Emp

End MORE_INFO_REPLY;
-- *****************************************************************************
-- ************* END *************************************************
-- Hold Procedure  ---------------------------------------------------------
PROCEDURE Hold (P_PAYMENT_RECOMMENDATION_ID IN number , 
                p_person_id                 IN number , 
                p_comment                   IN varchar2)
IS
l_approval_type   VARCHAR2(255);
l_max_step        NUMBER;
l_id              NUMBER;
l_step_no           NUMBER;
l_ACTION_REQUIRED           varchar2(255);
l_ROLE_DESC                 varchar2(255);
l_ROLE_ID                   number;
l_seq                       Number;

BEGIN

 -- 1) GET ID , STEP_NO
        SELECT id, step_no, approval_type, ACTION_REQUIRED ,ROLE_ID
        INTO l_id, l_step_no, l_approval_type, l_ACTION_REQUIRED, l_ROLE_ID
        FROM
            cwip_payment_rec_approval_history
        WHERE
             PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
            AND status = 'Pending'
            and person_type = 'INT'
            and person_id = p_person_id;

-- 2) GET MAX STEPS

      SELECT   MAX(step_no)
        INTO   l_max_step
        FROM    cwip_payment_rec_approval_history
        WHERE  PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID;
             
-- 3 update History                 
            -- update approval history
            UPDATE cwip_payment_rec_approval_history
            SET    status = 'Hold',
                action_date = systimestamp, COMMENTS = p_comment
                , n_status = 'Expired'
            WHERE  id = l_id;                

-- INSERT DELEGATED RECORDE IN APPROVAL HISTORY
l_seq  := CWIP_PAYMENT_REC_APPROVAL_HISTORY_SEQ.nextVal;

INSERT INTO cwip_payment_rec_approval_history (
            id,
            payment_recommendation_id,
            step_no,
            person_id,
            person_type,
            role_id,
            action_required,
            recevied_date,
            status,
            action_date,
            approval_type,
            ON_BEHALF
--            ,hash_code
            ,app_id 	
            ,approval_type_code	
            ,email			
            , n_status
        ) VALUES (
            l_seq,
            p_payment_recommendation_id,
            l_step_no,
            p_person_id,
            'INT',
            l_ROLE_ID,
            l_ACTION_REQUIRED ,
            systimestamp,
            'Pending',
            null,
            l_approval_type
            ,'N'     -- to indicate it's on-behalf 
--            , apex_util.get_hash(apex_t_varchar2(P_PAYMENT_RECOMMENDATION_ID, id ))
            ,nvl(NV('APP_ID'),130)
            ,'CWIP'
            ,user_details.get_emp_Email(p_person_id)
            , 'New'
        );  
   -- set Hashcode for the new record
   update cwip_payment_rec_approval_history
   set hash_code = apex_util.get_hash(apex_t_varchar2(PAYMENT_RECOMMENDATION_ID, id ))
    ,trx_code = DBMS_RANDOM.STRING('X', 6)
--   where PAYMENT_RECOMMENDATION_ID = p_payment_recommendation_id;
    where ID  = l_seq ;
--//TODO Send Email to the delegated Emp
 --   cwip_rec_payment_emails.SEND_DELEGATE_EMAIL(p_payment_recommendation_id ,p_from_person_id ,  p_to_person_id);
 
 Update cwip_payment_recommendation
 set APPROVAL_STATUS = 'Hold'
 where PAYMENT_RECOMMENDATION_ID = p_payment_recommendation_id;

End Hold;

-- ************* END *************************************************

-- **********  Main Procedure to submit  -------


PROCEDURE SUBMIT(P_PAYMENT_RECOMMENDATION_ID    NUMBER)
IS
l_pme_count             Number;
l_person_id             Number;
l_PERSON_TYPE           varchar2(20);
BEGIN

-- get Project Manager Count
    select count(t.person_id) 
        into l_pme_count
    from cwip_team t
     where t.project_number in (
                                select ccp.project_number from cwip_contract_projects ccp
                                where ccp.contract_number in (
                                select cpr.contract_number
                                from cwip_payment_recommendation cpr
                                where cpr.payment_recommendation_id = P_PAYMENT_RECOMMENDATION_ID))
    and t.role_id = 9  -- for Project Manager role
    and t.status = 'A'
    and sysdate BETWEEN nvl(t.start_date , to_date('01-01-2000','dd-MM-yyyy')) and nvl(t.end_date , to_date('31-12-4040','dd-MM-yyyy'));

if VALIDATE_PAYMENT_REC(P_PAYMENT_RECOMMENDATION_ID) Then 

case NV('ROLE_ID') 
    when 4  Then 
        -- Contractor
        insert_submit_user              (P_PAYMENT_RECOMMENDATION_ID);
        INSERT_LEAD_CONSULTANT          (P_PAYMENT_RECOMMENDATION_ID , 'Pending');
        INSERT_COST_CONSULTANT          (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PMC_USER                 (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_PROJ_DOC_CONTLR      (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PME_SITE_REVIEWER		(P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PROJECT_MANAGER          (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_SENIOR_PROJECT_MANAGER   (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_HQ_DOC_CONTLR        (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PME_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_GENERAL_PM               (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_TPC_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_USER                 (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');        
        INSERT_TPC_TECHNICAL_SUPPORT    (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_FINANCE_REVIEWER         (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_CWIP_FINANCE             (P_PAYMENT_RECOMMENDATION_ID , 'Future');
    
    when 3  Then 
        -- Lead Consultant
        insert_submit_user              (P_PAYMENT_RECOMMENDATION_ID);
        INSERT_COST_CONSULTANT          (P_PAYMENT_RECOMMENDATION_ID , 'Pending');
        INSERT_PMC_USER                 (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_PROJ_DOC_CONTLR      (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PME_SITE_REVIEWER		(P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PROJECT_MANAGER          (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_SENIOR_PROJECT_MANAGER   (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_HQ_DOC_CONTLR        (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PME_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_GENERAL_PM               (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_TPC_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_USER                 (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');        
        INSERT_TPC_TECHNICAL_SUPPORT    (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_FINANCE_REVIEWER         (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_CWIP_FINANCE             (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        
    when 2  Then 
        -- Cost Consultant
        insert_submit_user              (P_PAYMENT_RECOMMENDATION_ID);
        INSERT_PMC_USER                 (P_PAYMENT_RECOMMENDATION_ID , 'Pending');
        INSERT_PME_PROJ_DOC_CONTLR      (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PME_SITE_REVIEWER		(P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PROJECT_MANAGER          (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_SENIOR_PROJECT_MANAGER   (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_HQ_DOC_CONTLR        (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PME_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_GENERAL_PM               (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_TPC_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_USER                 (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');        
        INSERT_TPC_TECHNICAL_SUPPORT    (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_FINANCE_REVIEWER         (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_CWIP_FINANCE             (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        
    when 1  Then 
        -- PMC
        insert_submit_user              (P_PAYMENT_RECOMMENDATION_ID);
		INSERT_PME_PROJ_DOC_CONTLR      (P_PAYMENT_RECOMMENDATION_ID , 'Pending');
		INSERT_PME_SITE_REVIEWER		(P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PROJECT_MANAGER          (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_SENIOR_PROJECT_MANAGER   (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_HQ_DOC_CONTLR        (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_PME_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_GENERAL_PM               (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_PME_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');
		INSERT_TPC_REVIEWERS            (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_USER                 (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_TPC_DIRECTOR             (P_PAYMENT_RECOMMENDATION_ID , 'Future');        
        INSERT_TPC_TECHNICAL_SUPPORT    (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_FINANCE_REVIEWER         (P_PAYMENT_RECOMMENDATION_ID , 'Future');
        INSERT_CWIP_FINANCE             (P_PAYMENT_RECOMMENDATION_ID , 'Future');

End CASE;


--******************************************************************************

-- Confirm Pending Status for min step_no
    Update cwip_payment_rec_approval_history
    set status = 'Pending' , recevied_date = systimestamp
    where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
    and step_no = (
    select DISTINCT min(step_no) over (PARTITION BY PAYMENT_RECOMMENDATION_ID) min_step
    from cwip_payment_rec_approval_history
    where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
    and ACTION_DATE is null);
    
 --******************************************************************************   
-- Send Email for Pending Users

for emp in (select PERSON_ID , PERSON_TYPE , id, apex_util.get_hash(apex_t_varchar2(P_PAYMENT_RECOMMENDATION_ID, id ))  v_hash
--            into l_person_id , l_PERSON_TYPE
            from cwip_payment_rec_approval_history
            where PAYMENT_RECOMMENDATION_ID = P_PAYMENT_RECOMMENDATION_ID
            and STATUS = 'Pending')
    Loop
        update cwip_payment_rec_approval_history
        set hash_code = emp.v_hash ,trx_code = DBMS_RANDOM.STRING('X', 6)
        where id = emp.id;
        
cwip_rec_payment_emails.SEND_REC_PAYMENT_ACTION_REQUIRED_EMAIL(P_PAYMENT_RECOMMENDATION_ID , emp.PERSON_ID, emp.PERSON_TYPE, emp.id );

    End Loop;

--*****************
-- Send Email for FYI- Payment Application Submitted Users Role
for FyiEmp in (SELECT  person_id
                FROM  dct_data_access_assignment
                WHERE   entity_type_id = 'ROLE'
                    AND entity_id = 62  -- 62 for FYI- Payment Application Submitted
                    AND status = 'A'
                    AND sysdate BETWEEN start_date AND nvl(end_date, sysdate + 10))
   Loop
    -- Send Email
        cwip_rec_payment_emails.FYI_PAYMENT_APP_SUBMITTED_EMAIL(P_PAYMENT_RECOMMENDATION_ID, FyiEmp.person_id, 'INT');
   
   End loop;
  --*****************


else

raise_application_error(-20003, l_error_message);
end if;

END SUBMIT;
end cwip_rec_payment_workflow;