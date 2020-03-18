create view v_dpoaccount
as
select u.id,
			 BS.id as BarangayId,
			 CONCAT(U.First_Name,' ',U.Middle_Name,' ',U.Last_Name) as DPO_Name,
			 Position_Name,
			 username,
			 password,
			 Email,
			 barangay_name,
			 barangay_seal,
			 active_flag 
			 from r_barangay_info BS
inner join users U on  U.id=BS.userid
inner join r_position P on P.Position_Id=U.position_id 