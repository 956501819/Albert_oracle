-- 写在前面
--作者：刘悦 (Albert)
/*
merge 很少单独使用，大都是与oracle定时器绑定使用，比如我们经常会设定，在数据库数据吞吐量较少的时段进行merge操作，比如凌晨一点等...
这里告诉大家，如何将 merge 与oracle 定时器进行结合使用 当然，要求定时器，就得使用存储过程
执行的步骤为：
1. 编写 merge 语句并进行测试（跨数据库用dblink）
2. 编写存储过程进行测试
3. 定时器调用 包含merge语句的存储过程 并进行测试

*/


-- Create table 以下是建表 T_FILE_INFO的 语句
	create table T_FILE_INFO
	(
	  id                  NVARCHAR2(32) not null,
	  content_note        NVARCHAR2(200),
	  equipment_id        NVARCHAR2(32),
	  experiment_id       NVARCHAR2(32),
	  file_name           NVARCHAR2(100),
	  file_note           NCLOB,
	  file_path           NCLOB,
	  file_type           NVARCHAR2(50),
	  function_id         NVARCHAR2(32),
	  key_word            NCLOB,
	  model_content_id    NVARCHAR2(32),
	  owner_model         NVARCHAR2(100),
	  project_id          NVARCHAR2(32),
	  project_task_id     NVARCHAR2(32),
	  state               NVARCHAR2(32),
	  state_name          NVARCHAR2(200),
	  upload_time         DATE,
	  use_type            NVARCHAR2(32),
	  version_no          NVARCHAR2(32),
	  doc_type            NVARCHAR2(32),
	  related_model_type  NVARCHAR2(32),
	  study_direction     NVARCHAR2(32),
	  user_upload_user_id NVARCHAR2(80),
	  up_id               NVARCHAR2(32),
	  file_info_up_id     NVARCHAR2(32)
	)


-- 编写merge语句，并进行测试（注意下面merge 语句包含 dblink ：lims_link_3，dblink的创建参考我写的其他的案例）

	merge into t_file_info              t1
	using t_file_info@lims_link_3       t2
	on (t1.id=t2.id)
	when matched then
	   update set
	  t1.content_note=t2.content_note,
	  t1.equipment_id=t2.equipment_id,
	  t1.experiment_id=t2.experiment_id,
	  t1.file_name=t2.file_name,
	  t1.file_note=t2.file_note,
	  t1.file_path=t2.file_path,
	  t1.file_type=t2.file_type,
	  t1.function_id=t2.function_id,
	  t1.key_word=t2.key_word,
	  t1.model_content_id=t2.model_content_id,
	  t1.owner_model=t2.owner_model,
	  t1.project_id=t2.project_id,
	  t1.project_task_id=t2.project_task_id,
	  t1.state=t2.state,
	  t1.state_name=t2.state_name,
	  t1.upload_time=t2.upload_time,
	  t1.use_type=t2.use_type,
	  t1.version_no=t2.version_no,
	  t1.doc_type=t2.doc_type,
	  t1.related_model_type=t2.related_model_type,
	  t1.study_direction=t2.study_direction,
	  t1.user_upload_user_id=t2.user_upload_user_id,
	  t1.up_id=t2.up_id,
	  t1.file_info_up_id=t2.file_info_up_id
	when not matched then
	  insert(id,content_note,equipment_id,experiment_id,file_name,file_note,file_path,file_type,function_id,key_word,model_content_id,owner_model,project_id,project_task_id,state,state_name,upload_time,use_type,version_no,doc_type,related_model_type,study_direction,user_upload_user_id,up_id,file_info_up_id) values(t2.id,t2.content_note,t2.equipment_id,t2.experiment_id,t2.file_name,t2.file_note,t2.file_path,t2.file_type,t2.function_id,t2.key_word,t2.model_content_id,t2.owner_model,t2.project_id,t2.project_task_id,t2.state,t2.state_name,t2.upload_time,t2.use_type,t2.version_no,t2.doc_type,t2.related_model_type,t2.study_direction,t2.user_upload_user_id,t2.up_id,t2.file_info_up_id)
	 
-- 编写 包含merge语句的存储过程


CREATE OR REPLACE PROCEDURE procudure_file_info
AS
BEGIN
  merge into t_file_info  t1
   using t_file_info@lims_link_3 t2
   on (t1.id=t2.id)
   when matched then
     update set
      t1.content_note=t2.content_note,
      t1.equipment_id=t2.equipment_id,
      t1.experiment_id=t2.experiment_id,
      t1.file_name=t2.file_name,
      t1.file_note=t2.file_note,
      t1.file_path=t2.file_path,
      t1.file_type=t2.file_type,
      t1.function_id=t2.function_id,
      t1.key_word=t2.key_word,
      t1.model_content_id=t2.model_content_id,
      t1.owner_model=t2.owner_model,
      t1.project_id=t2.project_id,
      t1.project_task_id=t2.project_task_id,
      t1.state=t2.state,
      t1.state_name=t2.state_name,
      t1.upload_time=t2.upload_time,
      t1.use_type=t2.use_type,
      t1.version_no=t2.version_no,
      t1.doc_type=t2.doc_type,
      t1.related_model_type=t2.related_model_type,
      t1.study_direction=t2.study_direction,
      t1.user_upload_user_id=t2.user_upload_user_id,
      t1.up_id=t2.up_id,
      t1.file_info_up_id=t2.file_info_up_id
    when not matched then
    insert(id,content_note,equipment_id,experiment_id,file_name,file_note,file_path,file_type,function_id,key_word,model_content_id,owner_model,project_id,project_task_id,state,state_name,upload_time,use_type,version_no,doc_type,related_model_type,study_direction,user_upload_user_id,up_id,file_info_up_id) values(t2.id,t2.content_note,t2.equipment_id,t2.experiment_id,t2.file_name,t2.file_note,t2.file_path,t2.file_type,t2.function_id,t2.key_word,t2.model_content_id,t2.owner_model,t2.project_id,t2.project_task_id,t2.state,t2.state_name,t2.upload_time,t2.use_type,t2.version_no,t2.doc_type,t2.related_model_type,t2.study_direction,t2.user_upload_user_id,t2.up_id,t2.file_info_up_id); 
    commit;
END;
/



--删除存储过程

DROP PROCEDURE procudure_file_info 



--测试哦调用同步t_file_info 的 存储过程 （主要要commit 提交）

begin
  -- Call the procedure
  procudure_file_info;
  commit;         
end;


2.创建job 定时器 任务  每天 凌晨 一点 执行

declare
        job number;
begin
        DBMS_JOB.submit(
            JOB => JOB,
            WHAT =>'procudure_file_info;',
            NEXT_DATE =>SYSDATE,
           -- INTERVAL => 'TRUNC(SYSDATE,''MI'')+1/(24*60)'  /* 每隔一分钟执行一次  */
            Interval => 'TRUNC(sysdate+ 1)  +1/ (24) '   /* 每天凌晨 一点 执行一次  */
        );
        COMMIT;
end;
/
























