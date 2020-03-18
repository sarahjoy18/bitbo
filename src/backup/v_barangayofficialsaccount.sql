create view V_barangayofficialsaccount
	ass
SELECT barangay_official_id,
		username,
		password,
	   barangay_name ,
	   Position_Name,
	   Email,
	   municipality_name,
	   province_name,
	   Start_Term,End_Term,
	    permis_resident_basic_info,
	    permis_family_profile,
	    permis_community_profile,
	    permis_barangay_officials,
	    permis_businesses,
	    permis_issuance_of_forms,
	    permis_ordinances,
	    permis_blotter,
	    permis_patawag,
	    permis_system_reports,
	    permis_health_services,
	    permis_data_migration,
	    permis_user_accounts ,
	    permis_barangay_config, 
	    BO.active_flag FROM `users` U
inner join r_position P on P.position_id=U.position_id
inner join r_barangay_official BO on BO.barangay_official_id=U.barangay_official_id
inner join r_barangay_info BS on  BS.id=BO.barangay_id
inner join municipalities M on  M.municipal_id=BS.municipal_id