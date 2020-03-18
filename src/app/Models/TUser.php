<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */
// use Illuminate\Auth\Authenticatable;
// use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;


namespace App\Models;
use Reliese\Database\Eloquent\Model as Eloquent;
use Auth;

/**
 * Class TUser
 * 
 * @property int $USER_ID
 * @property int $BARANGAY_OFFICIAL_ID
 * @property int $POSITION_ID
 * @property string $FIRSTNAME
 * @property string $MIDDLENAME
 * @property string $LASTNAME
 * @property string $USERNAME
 * @property string $EMAIL
 * @property \Carbon\Carbon $EMAIL_VERIFIED_AT
 * @property string $PASSWORD
 * @property string $SECRET_QUESTION
 * @property string $SECRET_ANSWER
 * @property int $PERMIS_RESIDENT_BASIC_INFO
 * @property int $PERMIS_FAMILY_PROFILE
 * @property int $PERMIS_COMMUNITY_PROFILE
 * @property int $PERMIS_BARANGAY_OFFICIAL
 * @property int $PERMIS_BUSINESSES
 * @property int $PERMIS_ISSUANCE_OF_FORMS
 * @property int $PERMIS_ORDINANCES
 * @property int $PERMIS_BLOTTER
 * @property int $PERMIS_PATAWAG
 * @property int $PERMIS_SYSTEM_REPORT
 * @property int $PERMIS_HEALTH_SERVICES
 * @property int $PERMIS_DATA_MIGRATION
 * @property int $PERMIS_USER_ACCOUNTS
 * @property int $PERMIS_BARANGAY_CONFIG
 * @property string $REMEMBER_TOKEN
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\TBarangayOfficial $t_barangay_official
 * @property \App\Models\RPosition $r_position
 *
 * @package App\Models
 */
class TUser extends Eloquent 
{
		
	protected $primaryKey = 'USER_ID';
	public $timestamps = false;
	
	protected $casts = [
		'BARANGAY_OFFICIAL_ID' => 'int',
		'POSITION_ID' => 'int',
		'PERMIS_RESIDENT_BASIC_INFO' => 'int',
		'PERMIS_FAMILY_PROFILE' => 'int',
		'PERMIS_COMMUNITY_PROFILE' => 'int',
		'PERMIS_BARANGAY_OFFICIAL' => 'int',
		'PERMIS_BUSINESSES' => 'int',
		'PERMIS_ISSUANCE_OF_FORMS' => 'int',
		'PERMIS_ORDINANCES' => 'int',
		'PERMIS_BLOTTER' => 'int',
		'PERMIS_PATAWAG' => 'int',
		'PERMIS_SYSTEM_REPORT' => 'int',
		'PERMIS_HEALTH_SERVICES' => 'int',
		'PERMIS_DATA_MIGRATION' => 'int',
		'PERMIS_USER_ACCOUNTS' => 'int',
		'PERMIS_BARANGAY_CONFIG' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'EMAIL_VERIFIED_AT',
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BARANGAY_OFFICIAL_ID',
		'POSITION_ID',
		'FIRSTNAME',
		'MIDDLENAME',
		'LASTNAME',
		'USERNAME',
		'EMAIL',
		'EMAIL_VERIFIED_AT',
		'PASSWORD',
		'SECRET_QUESTION',
		'SECRET_ANSWER',
		'PERMIS_RESIDENT_BASIC_INFO',
		'PERMIS_FAMILY_PROFILE',
		'PERMIS_COMMUNITY_PROFILE',
		'PERMIS_BARANGAY_OFFICIAL',
		'PERMIS_BUSINESSES',
		'PERMIS_ISSUANCE_OF_FORMS',
		'PERMIS_ORDINANCES',
		'PERMIS_BLOTTER',
		'PERMIS_PATAWAG',
		'PERMIS_SYSTEM_REPORT',
		'PERMIS_HEALTH_SERVICES',
		'PERMIS_DATA_MIGRATION',
		'PERMIS_USER_ACCOUNTS',
		'PERMIS_BARANGAY_CONFIG',
		'REMEMBER_TOKEN',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function t_barangay_official()
	{
		return $this->belongsTo(\App\Models\TBarangayOfficial::class, 'BARANGAY_OFFICIAL_ID');
	}

	public function r_position()
	{
		return $this->belongsTo(\App\Models\RPosition::class, 'POSITION_ID');
	}

	public function sign_in($username)
	{	
		
		
       
		// if (Auth::attempt(array('USERNAME' => request('UsernameTxt'), 'PASSWORD' => request('PasswordTxt'))))
		// 	{

		// 		$CheckRole = DB::table('v_useraccount')->where('USERNAME',request('UsernameTxt'))->where('ACTIVE_FLAG',1)->get();

		// 		foreach($CheckRole as $val)
		// 		{
					
		// 			if( $val->POSITION_NAME == 'Barangay Chairman' ||  $val->POSITION_NAME == 'Secretary' ||  $val->POSITION_NAME == 'Chief Tanod' ||  $val->POSITION_NAME == 'Census Officer' )
		// 			{

		// 				$GetPermission = DB::table('v_realbarangayofficialsaccount')->where('USERNAME',request('UsernameTxt'))->get();
		// 				foreach($GetPermission as $value)
		// 				{


		// 					session(['session_user_id' => $value->USER_ID]);
		// 					session(['session_barangay_name' => $value->BARANGAY_NAME]);
		// 					session(['session_position' => $value->POSITION_NAME]);
		// 					session(['session_email' => $value->EMAIL]);


		// 					session(['session_permis_resident_basic_info' => $value->PERMIS_RESIDENT_BASIC_INFO]);
		// 					session(['session_permis_family_profile' => $value->PERMIS_FAMILY_PROFILE]);
		// 					session(['session_permis_community_profile' => $value->PERMIS_COMMUNITY_PROFILE]);
		// 					session(['session_permis_barangay_officials' => $value->PERMIS_BARANGAY_OFFICIAL]);
		// 					session(['session_permis_businesses' => $value->PERMIS_BUSINESSES]);
		// 					session(['session_permis_issuance_of_forms' => $value->PERMIS_ISSUANCE_OF_FORMS]);
		// 					session(['session_permis_ordinances' => $value->PERMIS_ORDINANCES]);
		// 					session(['session_permis_blotter' => $value->PERMIS_BLOTTER]);
		// 					session(['session_permis_patawag'=> $value->PERMIS_PATAWAG]);
		// 					session(['session_permis_system_reports' => $value->PERMIS_SYSTEM_REPORT]);
		// 					session(['session_permis_health_services' => $value->PERMIS_HEALTH_SERVICES]);
		// 					session(['session_permis_data_migration' => $value->PERMIS_DATA_MIGRATION]);
		// 					session(['session_permis_user_accounts' => $value->PERMIS_USER_ACCOUNTS]);
		// 					session(['session_permis_barangay_config' => $value->PERMIS_BARANGAY_CONFIG]);

		// 				}	

		// 			}
		// 			else if( $val->Position_Name == 'Data Protection Officer')
		// 			{
		// 				$GetAccount=DB::table('v_dpoaccount')-> where('USERNAME',request('UsernameTxt'))->get();
		// 				foreach($GetAccount as $value)
		// 				{

		// 					session(['session_user_id'=> $value->USER_ID]);
		// 					session(['session_brgy_id'=> $value->BARANGAY_ID]);
		// 					session(['session_dpo_name'=> $value->DPO_Name]);
							
		// 					session(['session_barangay_name'=> $value->BARANGAY_NAME]);
		// 					session(['session_position'=> $value->POSITION_NAME]);
		// 					session(['session_email'=> $value->EMAIL]);

		// 				}	
		// 			}
		// 			else
		// 			{	
		// 				echo "0";
						
		// 			}

		// 		}

		// 	}
		// 	else 
		// 	{        
		// 		echo "0";
		// 	}

	}
}
