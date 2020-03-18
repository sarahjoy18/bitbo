create view v_municipalaccount
as
SELECT  U.id,
				Position_Name,
				province_name,
				municipality_name,
				username,
				password,
				Email,
				U.active_flag 
				FROM users U 
				inner join municipalities M on M.municipal_id=U.municipalid
				inner join r_position P on P.Position_Id=U.position_id 