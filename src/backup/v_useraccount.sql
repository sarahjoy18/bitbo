create view v_useraccount
as
select   Position_Name,barangay_name,First_Name,Middle_Name,Last_Name,username,password,email,U.active_flag from users U 
inner join r_position as P on P.position_id=U.position_id 
left outer join r_barangay_info as BS on U.id=BS.userid

left outer join municipalities as M on M.municipal_id=U.municipalid
left outer join r_barangay_official as BO on BO.barangay_official_id=U.barangay_official_id and BS.id=BO.barangay_id 

