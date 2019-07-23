-- 写在前面
--作者：刘悦 (Albert)
/*
当我们需要在本地的表变动时，需要及时的将数据同步到另一个数据库的另一张表中时就需要建立一个跨数据库的 触发器
要与dblink 结合进行使用。

*/

-- 首先创建测试表：TRIGGER_TEST 和 远程数据库的 测试表 trigger_test_2(这里就不演示了)
create table TRIGGER_TEST
(
  empno    NUMBER(4),
  ename    VARCHAR2(10),
  job      VARCHAR2(9),
  mgr      NUMBER(4),
  hiredate DATE,
  sal      NUMBER(7,2),
  comm     NUMBER(7,2),
  deptno   NUMBER(2)
)
tablespace FSZZJ    -- 这里是表空间
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64
    next 1
    minextents 1
    maxextents unlimited
  );


--接下来给表 trigger_test 建立触发器

create or replace trigger TRIGGER_ON_trigger_test
after insert or update
on c##liuyue.trigger_test 
for each row
declare
    integrity_error exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;
    
begin
if inserting then
    insert into trigger_test_2@oracle_link_105(empno,ename,job,mgr,hiredate,sal,comm,deptno) values(:NEW.empno,:NEW.ename,:NEW.job,:new.mgr,:NEW.hiredate,:NEW.sal,:NEW.comm,:NEW.deptno);
elsif updating then 
    update trigger_test_2@oracle_link_105 set empno=:NEW.empno,ename=:NEW.ename,job=:NEW.job,hiredate=:NEW.hiredate,sal=:NEW.sal,comm=:NEW.comm,deptno=:NEW.deptno where empno=:OLD.empno;
end if;
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;

--插入数据测试
insert into trigger_test(empno,ename,job,mgr,hiredate,sal,comm,deptno) values(1001,'测试','销售',1001,sysdate,5000,400,01)


--修改数据测试

update trigger_test set ename='DBA测试' where empno=1001
delete from trigger_test

insert into trigger_test select * from emp;
select * from trigger_test


--测试发现只有 commit 之后才会执行 触发器事件，当一次插入大量数据时，肯定得分批提交，那么如果保证来分批commit呢？

