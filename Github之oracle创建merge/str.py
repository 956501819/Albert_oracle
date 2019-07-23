# -*- coding :utf-8 -*-
#Author :刘悦(Albert)

#字段之间，以逗号分隔，使用时，将其替换
str='id,content_note,equipment_id,experiment_id,file_name,file_note,file_path,file_type,function_id,key_word,model_content_id,owner_model,project_id,project_task_id,state,state_name,upload_time,use_type,version_no,doc_type,related_model_type,study_direction,user_upload_user_id,up_id,file_info_up_id'
str2=str.split(',')
str3=''
for i in range(0,len(str2)):
    if i!=0:
        if i==len(str2)-1:
            print('t1.%s=t2.%s'%(str2[i],str2[i]))
            str3+='t2.%s'%str2[i]
        else:
            print('t1.%s=t2.%s,'%(str2[i],str2[i]))
            str3 += 't2.%s,' % str2[i]
        # str3+='t2.%s,'%str2[i]
    else:
        str3 += 't2.%s,' % str2[i]
str4='insert(%s) values(%s)'%(str,str3)
print(str4)