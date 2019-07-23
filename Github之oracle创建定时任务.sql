-- 写在前面
--作者：刘悦 (Albert)
/*
定时任务的语法比较简单，大家可以参考我下方的案例进行编写

*/


************************************************以下是创建定时器的测试

-- 创建表 （步骤略，字段可参考我下方的值）

-- 查询 定时任务 jobid
SELECT job,next_date,what FROM dba_jobs

-- 为定时任务创建存储过程

1.创建 存储过程

CREATE OR REPLACE PROCEDURE TIME_procudure_test
AS
BEGIN
	INSERT INTO merge_test0829 (empno,ename,job,mgr,hiredate,sal,comm,deptno) values(1001,'定时测试','定时测试',7566,sysdate,700,500,01);
  commit;
END;
/

select * from emp

-- 2.查看用户所有的存储过程
select * from user_objects where object_type='PROCEDURE';-- 一定要大写


-- 3.创建定时器调用 存储过程
declare
  job number;
BEGIN
  DBMS_JOB.SUBMIT(  
        JOB => job,  /*自动生成JOB_ID*/  
        WHAT => 'TIME_procudure_test;',  /*需要执行的存储过程名称或SQL语句*/  
        NEXT_DATE => sysdate,  /*初次执行时间-立即执行*/  
        INTERVAL => 'trunc(sysdate,''mi'')+1/(24*60)' /*每隔1分钟执行一次，要根据实际情况来进行更改*/
      );  
  commit;
end;
/

4.删除定时器
BEGIN
  DBMS_JOB.REMOVE(5);    -- 这里的 5是查询出来的 定时任务的 id
  COMMIT;
END;
/

查看执行结果:
select * from merge_test0829



-- 关于定时器在这里举几个例子 *************************************************************
1、 每分钟执行  Interval => TRUNC(sysdate,’mi’) + 1 / (24*60)
2、 每天定时执行 例如：每天的凌晨2点执行 Interval => TRUNC(sysdate) + 1 +2 / (24)
3、 每周定时执行 例如：每周一凌晨2点执行 Interval => TRUNC(next_day(sysdate,2))+2/24 --星期一,一周的第二天
4、 每月定时执行 例如：每月1日凌晨2点执行 Interval =>TRUNC(LAST_DAY(SYSDATE))+1+2/24
5、 每季度定时执行 例如每季度的第一天凌晨2点执行 Interval => TRUNC(ADD_MONTHS(SYSDATE,3),'Q') + 2/24
6、 每半年定时执行 例如：每年7月1日和1月1日凌晨2点 Interval => ADD_MONTHS(trunc(sysdate,'yyyy'),6)+2/24
7、 每年定时执行 例如：每年1月1日凌晨2点执行 Interval =>ADD_MONTHS(trunc(sysdate,'yyyy'),12)+2/24


