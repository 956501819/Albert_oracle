-- 写在前面
--作者：刘悦 (Albert)
/*
创建dblink 的目的是为了便捷的跨oracle数据库进行通信，为我们节省了很多数据库导入导出的时间
让我们可以像在本地一样操作，远程数据库的表，但是创建的时候一定要注意赋权

可以看看我的博客地址，这里分享了我曾经踩过的坑... http://www.liuyue666.com/?p=49
*/



--创建 dblink

CREATE PUBLIC DATABASE LINK DBlink名称  CONNECT TO oracle用户名 IDENTIFIED BY 用户密码  USING '(DESCRIPTION =
     (ADDRESS_LIST =
       (ADDRESS = (PROTOCOL = TCP)(HOST = IP地址)(PORT = 端口号))
     )
     (CONNECT_DATA =
(SERVICE_NAME = 实例名)
     )
)' 


--删除 dblink

drop public database link DBlink名称


--创建好，一定要进行测试，看看
SELECT 字段名 FROM TableName@数据链名称;
select * from 远程数据库表名@DBlink名称  where rownum < 10


-- ***********************************************************************************************************

-- 在这里临时加一些别的有用的sql

--查看 本地的实例 名
SELECT * FROM GLOBAL_NAME;

--查看锁表
select   p.spid,a.serial#, c.object_name,b.session_id,b.oracle_username,b.os_user_name   from   v$process   p,v$session   a,   v$locked_object   b,all_objects   c   where   p.addr=a.paddr   and   a.process=b.process   and   c.object_id=b.object_id ; 

--查看表空间名称以及大小
SELECT t.tablespace_name, round(SUM(bytes / (1024 * 1024)), 0) ts_size 
FROM dba_tablespaces t, dba_data_files d 
WHERE t.tablespace_name = d.tablespace_name 
GROUP BY t.tablespace_name; 















































