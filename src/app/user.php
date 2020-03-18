<?php

namespace App;
use Illuminate\Auth\Authenticatable;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Database\Eloquent\Model;
use DB;
use Mail;
use Auth;
use Hash;

class user extends Model implements AuthenticatableContract
{
    //
	use Authenticatable;

	protected $fillable = ['username', 'password'];

	public function add_barangay_official_account()
	{	
    	// UPDATE THIS FUNCTION WHEN RESIDENTS TABLE CREATE

		$brgy_id = session('session_brgy_id');

		$BarangayOfficialID = DB::table('t_barangay_official')->insertGetId([
			'BARANGAY_ID'=> $brgy_id,
			'RESIDENT_ID'=> 1,
			'START_TERM'=> request('StartTermTxt'),
			'END_TERM'=> request('EndTermTxt')
		]);


		$random_password=str_random(8);

		$GetResidentID=DB::table('t_resident_basic_info')
								->select('RESIDENT_ID')						
								->where(DB::raw('FULLNAME + " " + MIDDLENAME + " " +LASTNAME'),request('BarangayOfficialNameTxt'))->value();

		$InsertResidentNameToBO=DB::table('t_barangay_official')
								->where('BARANGAY_OFFICIAL_ID',$BarangayOfficialID)
								->update([ 'RESIDENT_ID' => $GetResidentID ]);

		$this->barangay_official_id=$BarangayOfficialID;
			
		if( request('BarangayPosTxt') == 'Barangay Chairman' ) 	
		{ 
			$this->username= "BC-".$BarangayOfficialID;

			Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail/email_txt=".md5(request('EmailTxt')),
				'USERNAME'=> "BC-".$BarangayOfficialID,
				'PASSWORD'=>$random_password],
				function($message)

				{   

					$message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
					->to(request('EmailTxt'),request('EmailTxt'))
					->subject('Account Verification');



				});

		}

	else if( request('BarangayPosTxt') == 'Secretary' ) 
		{ 
			$this->username=  "S-".$BarangayOfficialID;


	Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
		'USERNAME'=> "S-".$BarangayOfficialID,
		'PASSWORD'=>$random_password],
		function($message)

		{   

			$message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
			->to(request('EmailTxt'),request('EmailTxt'))
			->subject('Account Verification');



		});


}

else if( request('BarangayPosTxt') == 'Chief Tanod' ) 
	{ 
		echo request('BarangayPosTxt');
		$this->username=  "CT-".$BarangayOfficialID;

Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
	'USERNAME'=> "CT-".$BarangayOfficialID,
	'PASSWORD'=>$random_password],
	function($message)

	{   

		$message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
		->to(request('EmailTxt'),request('EmailTxt'))
		->subject('Account Verification');



	});

}

else if( request('BarangayPosTxt') == 'Census Officer' ) 
	{ $this->username=  "CO-".$BarangayOfficialID;



Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
	'USERNAME'=>  "CO-".$BarangayOfficialID,
	'PASSWORD'=>$random_password],
	function($message)

	{   

		$message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
		->to(request('EmailTxt'),request('EmailTxt'))
		->subject('Account Verification');



	});
}


	$this->password=bcrypt($random_password);
	$this->position_id=request('BarangayPosIDTxt');
	$this->email=request('EmailTxt');
	$this->save();

}

public function check_permission()
{

	if(request('CheckboxStatus')=='Checked')
	{
		if(request('PermissionName')=='BI')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_resident_basic_info=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='FP')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_family_profile=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='CP')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_community_profile=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='BO')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_barangay_officials=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='B')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_businesses=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='I')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_issuance_of_forms=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='O')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_ordinances=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='Blot')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_blotter=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='P')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_patawag=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='SR')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_system_reports=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='HS')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_health_services=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='DM')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_data_migration=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='UA')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_user_accounts=1;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='BC')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_barangay_config=1;
			$BarangayOfficial->save();
		}
		
		

	}
	else
	{

		if(request('PermissionName')=='BI')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_resident_basic_info=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='FP')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_family_profile=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='CP')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_community_profile=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='BO')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_barangay_officials=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='B')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_businesses=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='I')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_issuance_of_forms=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='O')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_ordinances=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='Blot')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_blotter=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='P')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_patawag=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='SR')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_system_reports=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='HS')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_health_services=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='DM')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_data_migration=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='UA')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_user_accounts=0;
			$BarangayOfficial->save();
		}
		else if(request('PermissionName')=='BC')
		{
			$BarangayOfficial=$this->where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
			$BarangayOfficial->permis_barangay_config=0;
			$BarangayOfficial->save();
		}
		


	}

}


//SIGN IN
public function sign_in()
{	
	
	if (Auth::attempt(array('USERNAME' => request('UsernameTxt'), 'PASSWORD' => request('PasswordTxt'))))
		{

			$CheckRole = DB::table('v_useraccount')->where('USERNAME',request('UsernameTxt'))->where('ACTIVE_FLAG',1)->get();

			foreach($CheckRole as $val)
			{
				
				if( $val->POSITION_NAME == 'Barangay Chairman' ||  $val->POSITION_NAME == 'Secretary' ||  $val->POSITION_NAME == 'Chief Tanod' ||  $val->POSITION_NAME == 'Census Officer' )
				{

					$GetPermission = DB::table('v_realbarangayofficialsaccount')->where('USERNAME',request('UsernameTxt'))->get();
					foreach($GetPermission as $value)
					{


						session(['session_user_id' => $value->USER_ID]);
						session(['session_barangay_name' => $value->BARANGAY_NAME]);
						session(['session_position' => $value->POSITION_NAME]);
						session(['session_email' => $value->EMAIL]);


						session(['session_permis_resident_basic_info' => $value->PERMIS_RESIDENT_BASIC_INFO]);
						session(['session_permis_family_profile' => $value->PERMIS_FAMILY_PROFILE]);
						session(['session_permis_community_profile' => $value->PERMIS_COMMUNITY_PROFILE]);
						session(['session_permis_barangay_officials' => $value->PERMIS_BARANGAY_OFFICIAL]);
						session(['session_permis_businesses' => $value->PERMIS_BUSINESSES]);
						session(['session_permis_issuance_of_forms' => $value->PERMIS_ISSUANCE_OF_FORMS]);
						session(['session_permis_ordinances' => $value->PERMIS_ORDINANCES]);
						session(['session_permis_blotter' => $value->PERMIS_BLOTTER]);
						session(['session_permis_patawag'=> $value->PERMIS_PATAWAG]);
						session(['session_permis_system_reports' => $value->PERMIS_SYSTEM_REPORT]);
						session(['session_permis_health_services' => $value->PERMIS_HEALTH_SERVICES]);
						session(['session_permis_data_migration' => $value->PERMIS_DATA_MIGRATION]);
						session(['session_permis_user_accounts' => $value->PERMIS_USER_ACCOUNTS]);
						session(['session_permis_barangay_config' => $value->PERMIS_BARANGAY_CONFIG]);

					}	

				}
				else if( $val->Position_Name == 'Data Protection Officer' || )
				{
					$GetAccount=DB::table('v_dpoaccount')-> where('USERNAME',request('UsernameTxt'))->get();
					foreach($GetAccount as $value)
					{

						session(['session_user_id'=> $value->USER_ID]);
						session(['session_brgy_id'=> $value->BARANGAY_ID]);
						session(['session_dpo_name'=> $value->DPO_Name]);
						
						session(['session_barangay_name'=> $value->BARANGAY_NAME]);
						session(['session_position'=> $value->POSITION_NAME]);
						session(['session_email'=> $value->EMAIL]);

					}	
				}
				else
				{	
					echo "0";
					
				}

			}

		}
		else 
		{        
			echo "0";
		}
echo "0";

}

public function edit_my_user_account()
{

	session()->forget('session_email');
	$EditTable=$this->where('USER_ID',request('UserID'))->first();	
	$EditTable->EMAIL=request('EmailTxt');
	session(['session_email'=>request('EmailTxt')]);
	$EditTable->save();



	Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
	'USERNAME'=>  '',
	'PASSWORD'=>  ''],
	function($message)

	{   

		$message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
		->to(request('EmailTxt'),request('EmailTxt'))
		->subject('Account Verification');



	});


}


public function check_old_password()
{

		if (Auth::attempt(array('USER_ID' => request('UserID'), 'PASSWORD' => request('OldPasswordTxt'))))
		{
			echo '1';
		}
		else
		{
			echo '0';
		}
	
}


public function change_account_password()
{

	
	$ChangePassword=$this->where('USER_ID',request('UserID'))->first();	
	$ChangePassword->password=bcrypt(request('NewPasswordTxt'));
	
	$ChangePassword->save();

}



public function reset_password()
{

	$random_password=str_random(8);

	$ChangePassword=$this->where('EMAIL',request('EmailTxt'))->first();	
	$ChangePassword->password=bcrypt($random_password);

	$ChangePassword->save();



	
	Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
	'USERNAME' =>  '',
	'PASSWORD' =>  $random_password],
	function($message)

	{   

		$message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
		->to(request('EmailTxt'),request('EmailTxt'))
		->subject('Account Verification');



	});



}

public function set_status()
{
	$GetUserAccount=$this->where('USER_ID',request('UserID'))->first();
	if(request('Status')==1)
	{
		
		$GetUserAccount->active_flag=0;
		$GetUserAccount->save();

		echo "disable";

	}
	else
	{
		$GetUserAccount=$this->where('USER_ID',request('UserID'))->first();
		$GetUserAccount->active_flag=1;
		$GetUserAccount->save();

		echo "activate";

	}

}




}
