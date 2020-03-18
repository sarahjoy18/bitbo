<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\TUser;

use App\Models\TRESIDENTBASICINFO;
use DB;
use Mail;
use Hash;
use Session;
class UserAccountsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */ 
    public function index()
    {
        //$this->sign_out();
        $position_name = session('session_position');
        $DisplayData = db::table('v_realbarangayofficialsaccount')->get();
        $DisplayResidents =  db::select("call sp_residents_not_official()");
        $DisplayBarangayPosition = db::select('call sp_get_positions()');
        $DisplayPermission = db::select("call sp_get_permissions()");
        return view('administration.useraccounts',compact('DisplayData','DisplayBarangayPosition','DisplayPermission','DisplayResidents')); 
       
      
    }

    public function store()
    {   
        //UPDATE THIS FUNCTION WHEN RESIDENTS TABLE CREATE
        
        $brgy_id = session('session_brgy_id');

        $resident_id = request('res_id');
        $start_term = request('start_term');
        $end_term = request('end_term');
        $pos_id = request('pos_id');
        $email = request('email');
        $employee_number = request('employee_number');
        //$username = request('duname');
        //$password = request('dpass');



        $get_name = DB::table('t_resdient_basic_info')
                        ->select(DB::raw("LTRIM(RTRIM((CONCAT(REPLACE(FIRSTNAME, ' ', '') ,'.', LASTNAME)))) AS USERNAME"))
                        ->where('RESIDENT_ID',$resident_id)
                        ->value('USERNAME');

        $BarangayOfficialID = db::table('t_barangay_official')->insertgetid(
            [
                'RESIDENT_ID'=> $resident_id,
                'BARANGAY_ID'=> $brgy_id,
                'START_TERM'=> $start_term,
                'END_TERM'=> $end_term,
                'EMPLOYEE_NUMBER' => $employee_number,
                'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                'ACTIVE_FLAG' => 1
            ]);

        DB::TABLE('t_users')
        ->INSERT(
            [
                'BARANGAY_OFFICIAL_ID' => $BarangayOfficialID,
                'POSITION_ID' => $pos_id,
                'USERNAME' => $get_name,
                'EMAIL' => $email,
                'PASSWORD' =>  bcrypt($employee_number),
                'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                'ACTIVE_FLAG' => 1
            ]);
       

        $credentials = (object) ['username' => $get_name];
        return response()->json($credentials);

        // if( request('BarangayPosTxt') == 'Barangay Chairman' )  
        // { 
        //     // $T_USERS->USERNAME = "BC-".$BarangayOfficialID;

        //     // Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail/email_txt=".md5(request('EmailTxt')),
        //     //     'USERNAME'=> "BC-".$BarangayOfficialID,
        //     //     'PASSWORD'=>$random_password],
        //     //     function($message)
        //     //     {   

        //     //         $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
        //     //         ->to(request('EmailTxt'),request('EmailTxt'))
        //     //         ->subject('Account Verification');
        //     //     });

        // }
        // else if( request('BarangayPosTxt') == 'Secretary' ) 
        // { 
        // //     $T_USERS->USERNAME = "S-".$BarangayOfficialID;


        // // Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
        // //     'USERNAME'=> "S-".$BarangayOfficialID,
        // //     'PASSWORD'=>$random_password],
        // //     function($message)

        // //     {   

        // //         $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
        // //         ->to(request('EmailTxt'),request('EmailTxt'))
        // //         ->subject('Account Verification');
        // //     });
        // }
    
        // else if( request('BarangayPosTxt') == 'Chief Tanod' ) 
        // { 
       
        //     // $T_USERS->USERNAME = "CT-".$BarangayOfficialID;
        //     // Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
        //     // 'USERNAME'=> "CT-".$BarangayOfficialID,
        //     // 'PASSWORD'=> $random_password],
        //     // function($message)
        //     // {   

        //     //     $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
        //     //     ->to(request('EmailTxt'),request('EmailTxt'))
        //     //     ->subject('Account Verification');
        //     // });
        // }
        // else if( request('BarangayPosTxt') == 'Census Officer' ) 
        // { 

        //      // $T_USERS->USERNAME =  "CO-".$BarangayOfficialID;
        //      //    Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
        //      //        'USERNAME'=>  "CO-".$BarangayOfficialID,
        //      //        'PASSWORD'=>$random_password],
        //      //        function($message)
        //      //        {   

        //      //            $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
        //      //            ->to(request('EmailTxt'),request('EmailTxt'))
        //      //            ->subject('Account Verification');
        //      //        });
        //}
       
    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
        public function check_permission()
        {
            if(request('CheckboxStatus')=='Checked')
            {
                if(request('PermissionName')=='BI')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_RESIDENT_BASIC_INFO=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='FP')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_FAMILY_PROFILE=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='CP')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_COMMUNITY_PROFILE=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='BO')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BARANGAY_OFFICIAL=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='B')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BUSINESSES=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='I')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_ISSUANCE_OF_FORMS=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='O')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_ORDINANCES=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='Blot')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BLOTTER=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='P')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_PATAWAG=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='SR')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_SYSTEM_REPORT=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='HS')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_HEALTH_SERVICES=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='DM')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_DATA_MIGRATION=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='UA')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_USER_ACCOUNTS=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='BC')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BARANGAY_CONFIG=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='BA')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BUSINESS_APPROVAL=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='AF')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_APPLICATION_FORM=1;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='AE')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_APPLICATION_FORM_EVALUATION=1;
                    $BarangayOfficial->save();
                }

            }
            else
            {
                if(request('PermissionName')=='BI')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_RESIDENT_BASIC_INFO=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='FP')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_FAMILY_PROFILE=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='CP')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_COMMUNITY_PROFILE=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='BO')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BARANGAY_OFFICIAL=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='B')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BUSINESSES=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='I')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BUSINESSES=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='O')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BUSINESSES=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='Blot')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BLOTTER=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='P')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BLOTTER=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='SR')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_SYSTEM_REPORT=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='HS')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_SYSTEM_REPORT=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='DM')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_SYSTEM_REPORT=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='UA')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_USER_ACCOUNTS=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='BC')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->permis_barangay_config=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='BA')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_BUSINESS_APPROVAL=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='AF')
                {
                    $BarangayOfficial = TUSER::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_APPLICATION_FORM=0;
                    $BarangayOfficial->save();
                }
                else if(request('PermissionName')=='AE')
                {
                    $BarangayOfficial = TUser::where('BARANGAY_OFFICIAL_ID',request('BarangayOfficialID'))->first();
                    $BarangayOfficial->PERMIS_APPLICATION_FORM_EVALUATION=0;
                    $BarangayOfficial->save();
                }
            }
        }
    /** 
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function addnewuser()
    {

        $resident_id = db::table('t_resident_basic_info')
        ->insertgetid([

                    'LASTNAME' => strtoupper(request('rbi_firstname')),
                    'MIDDLENAME' => strtoupper(request('rbi_middlename')),
                    'FIRSTNAME' => strtoupper(request('rbi_lastname')),
                    'ADDRESS_HOUSE_NO' => request('rbi_house_no'),
                    'ADDRESS_STREET_NO' => request('rbi_street_no'),
                    'ADDRESS_STREET' => request('rbi_street'),
                    //'ADDRESS_PHASE' => $multi_rbi_hphase[0],
                    'ADDRESS_BUILDING' => request('rbi_building'),
                    'ADDRESS_UNIT_NO' => request('rbi_hunitno'),
                    'ADDRESS_SUBDIVISION' => request('rbi_hsubdivision'),

                    'QUALIFIER' => request('rbi_qualifier'),
                    'DATE_OF_BIRTH' => request('rbi_dob'),
                    'PLACE_OF_BIRTH' => request('rbi_placeofb'),
                    'SEX' => request('rbi_gender'),
                    'CIVIL_STATUS' => request('rbi_civilstat'),
                    'OCCUPATION' => request('rbi_occu'),
                    'CITIZENSHIP' => request('rbi_citizenship'),
                    'IS_RBI_COMPLETE' => 0,
                    'RELATION_TO_HOUSEHOLD_HEAD' => request('rbi_reltohead'),                 
                    'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                    'ACTIVE_FLAG' => 1
        ]);
         
        $brgy_id = session('session_brgy_id');

        
        $start_term = request('rbi_sterm');
        $end_term = request('rbi_eterm');
        $pos_id = request('rbi_position_id');
        $email = request('rbi_email');
        $employee_number = request('rbi_employee_no');
        $status = request('status');
        //$username = request('duname');
        //$password = request('dpass');



        $get_name = DB::table('t_resident_basic_info')
                        ->select(DB::raw("LTRIM(RTRIM((CONCAT(REPLACE(FIRSTNAME, ' ', '') ,'.', LASTNAME)))) AS USERNAME"))
                        ->where('RESIDENT_ID', $resident_id)
                        ->value('USERNAME');

        $BarangayOfficialID = db::table('t_barangay_official')->insertgetid(
            [
                'RESIDENT_ID'=> $resident_id,
                'BARANGAY_ID'=> $brgy_id,
                'START_TERM'=> $start_term,
                'END_TERM'=> $end_term,
                'EMPLOYEE_NUMBER' => $employee_number,
                'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                'ACTIVE_FLAG' => 1
            ]);

        DB::TABLE('t_users')
        ->INSERT(
            [
                'BARANGAY_OFFICIAL_ID' => $BarangayOfficialID,
                'POSITION_ID' => $pos_id,
                'USERNAME' => $get_name,
                'EMAIL' => $email,
                'PASSWORD' =>  bcrypt($employee_number),
                'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                'ACTIVE_FLAG' => 1
            ]);


            if ( $status == "newborn" ) {
                DB::TABLE('t_hs_newborn')->INSERT(['RESIDENT_ID' => $resident_id, 'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')]);
            }
            else 
            if ( $status == "infant" ) {
                DB::TABLE('t_hs_infant')->INSERT(['RESIDENT_ID' => $resident_id, 'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')]);
            }
            else 
            if ( $status == "child" ) {
                DB::TABLE('t_hs_child')->INSERT(['RESIDENT_ID' => $resident_id, 'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')]);
                DB::TABLE('t_children_profile')->INSERT(['RESIDENT_ID' => $resident_id, 'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')]);
            }
            else 
            if ( $status == "adolescent" ) {
                DB::TABLE('t_hs_adolescent')->INSERT(['RESIDENT_ID' => $resident_id, 'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')]);
            }
            else 
            if ( $status == "elderly" ) {
                DB::TABLE('t_hs_elderly')->INSERT(['RESIDENT_ID' => $resident_id, 'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')]);
            }

        echo "good";
    }
    
    public function addnewuserview()
    {
        $DisplayBarangayPosition = db::select('call sp_get_positions()');   
        return view('administration.addnewuser',compact('DisplayBarangayPosition'));
    }

    public function signin(Request $request)
    {

        $username = $request->GET('UsernameTxt');
        $password = $request->GET('PasswordTxt');
        session(['session_position' => "sample"]);

        $checkuser = TUser::SELECTRAW("COUNT(*) AS TOTAL")->WHERE('USERNAME','=', $username)->FIRST();

        if(intval($checkuser->TOTAL) > 0) 
        {

            $getpassword = TUser::SELECT("PASSWORD")->WHERE('USERNAME','=', $username)->FIRST();
            if(password_verify($password, $getpassword->PASSWORD))
            {

                $checkrole = \DB::TABLE('v_useraccounts')->WHERE('USERNAME', $username)->WHERE('ACTIVE_FLAG',1)->GET();
                foreach ($checkrole as $val) 
                {
                    $count = db::table('r_position')->where('POSITION_NAME',$val->POSITION_NAME)->count();
                    if( $count > 0 && $val->POSITION_NAME != 'Admin') 
                    {
                            $getpermission = \DB::TABLE('v_realbarangayofficialsaccount')->WHERE('USERNAME', $username)->GET();
                            foreach ($getpermission as $value)
                            {
                                 session(['session_user_id' => $value->USER_ID]);
                                 session(['session_brgy_id'=> $value->BARANGAY_ID]);
                                 session(['session_full_name' => $value->FULLNAME]);
                                 session(['session_barangay_name' => $value->BARANGAY_NAME]);
                                 session(['session_municipal_name' => $value->MUNICIPAL_NAME]);                                 
                                 session(['session_province_name' => $value->PROVINCE_NAME]);                                 
                                 session(['session_municipal_logo' => $value->MUNICIPAL_SEAL]);
                                 session(['session_barangay_logo' => $value->BARANGAY_SEAL]);
                                 session(['session_position' => $value->POSITION_NAME]);
                                 session(['session_email' => $value->EMAIL]);
                                 session(['session_username'=> $value->USERNAME]);
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
                                 session(['session_permis_business_approval' => $value->PERMIS_BUSINESS_APPROVAL]);

                                 session(['session_permis_barangay_application_form' => $value->PERMIS_APPLICATION_FORM]);
                                 session(['session_permis_barangay_application_evaluation' => $value->PERMIS_APPLICATION_FORM_EVALUATION]);
                                 
                                 
                            }

                            $getbrgychair = \DB::TABLE('v_realbarangayofficialsaccount')
                            ->WHERE(strtolower('POSITION_NAME'), strtolower("barangay chairman"))->GET();
                            
                            foreach ($getbrgychair as $value)
                            {
                                 session(['session_brgychairman_name' => $value->FULLNAME]);
                                 
                            }
                            
                            Session::save(); 

                        }
                        else
                        if ($val->POSITION_NAME == 'Data Protection Officer' || $val->POSITION_NAME == 'Admin')
                        { 
                            $getaccount = \DB::TABLE('v_adminaccount')->WHERE('USERNAME', $username)->GET();
                            foreach($getaccount as $value)
                          {
                                 session(['session_user_id'=> $value->USER_ID]);
                                 session(['session_brgy_id'=> $value->BARANGAY_ID]);
                                 session(['session_dpo_name'=> $value->FULL_NAME]);
                                 session(['session_barangay_name'=> $value->BARANGAY_NAME]);
                                 session(['session_municipal_name' => $value->MUNICIPAL_NAME]);                                 
                                 session(['session_province_name' => $value->PROVINCE_NAME]);                                 
                                 session(['session_municipal_logo' => $value->MUNICIPAL_SEAL]);
                                 session(['session_barangay_logo' => $value->BARANGAY_SEAL]);
                                 session(['session_position' => $value->POSITION_NAME]);
                                 session(['session_email'=> $value->EMAIL]);
                                 session(['session_username'=> $value->USERNAME]);
                                 
                                 Session::save(); 
                                
                              
                          } 
                           
                          
                                
                                            
                                 echo '2';
                        }
                }
            }
            else
            {   
                
                      
                echo '0';
            }

        }
        else
        {
          
                          
                            
                          
           echo '0';
        }
    }
 // $val->POSITION_NAME == 'Barangay Chairman' ||  $val->POSITION_NAME == 'Secretary' || 
 //                        $val->POSITION_NAME == 'Chief Tanod' ||  $val->POSITION_NAME == 'Census Officer' || $val->POSITION_NAME == 'Kagawad' || $val->POSITION_NAME == 'Committee'
    public function checkoldpass(Request $request)
    {
        $username = session('session_username');
        $password = $request->GET('OldPasswordTxt');
       
        $checkuser = TUser::SELECTRAW("COUNT(*) AS TOTAL")->WHERE('USERNAME','=', $username)->FIRST();

         if(intval($checkuser->TOTAL) > 0) 
         {  
            $getpassword = TUser::SELECT("PASSWORD")->WHERE('USERNAME','=', $username)->FIRST();
            if(password_verify($password, $getpassword->PASSWORD)) {
                echo '1';
            }
            else {
                echo '0';
            }
         }
         else
         {
            echo '0';
         }
        
    }


    public function change_password()
    {
        $change_password = new TUser();
        $change_password = TUser::where('USER_ID',request('UserID'))->first(); 
        $change_password->PASSWORD = bcrypt(request('NewPasswordTxt'));
        $change_password->save();
    }


    public function sign_out()
    {

        session()->forget('session_user_id');
        session()->forget('session_barangay_name');
        session()->forget('session_position');
        session()->forget('session_email');
        session()->forget('session_dpo_name');
        session()->forget('session_permis_resident_basic_info');
        session()->forget('session_permis_family_profile');
        session()->forget('session_permis_community_profile');
        session()->forget('session_permis_barangay_officials');
        session()->forget('session_permis_businesses');
        session()->forget('session_permis_issuance_of_forms');
        session()->forget('session_permis_ordinances');
        session()->forget('session_permis_blotter');
        session()->forget('session_permis_patawag');
        session()->forget('session_permis_system_reports');
        session()->forget('session_permis_health_services');
        session()->forget('session_permis_data_migration');
        session()->forget('session_permis_user_accounts');
        session()->forget('session_permis_barangay_config');

        // MUNICIPAL SESSION
        //session()->forget('session_province_name');
        //session()->forget('session_municipal_name');
        return redirect()->route('Login');
    }



    public function update_my_account()
    {
        $random_password = str_random(8);
        $username = session('session_username');
        $editaccount = new TUser();
        session()->forget('session_email');
        $editaccount = TUser::where('USER_ID',request('UserID'))->first();  
        $editaccount->EMAIL = request('EmailTxt');
        session(['session_email' => request('EmailTxt')]);
        $editaccount->save();


        Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
        'USERNAME'=> $username,
        'PASSWORD'=> $random_password ],
        function($message)
        {   
            $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
            ->to(request('EmailTxt'),request('EmailTxt'))
            ->subject('Account Verification');
        });
    }


    public function forgot_password()
    {

        $random_password = str_random(8);
        $ChangePassword =  new TUser();
        $ChangePassword = TUser::where('EMAIL',request('EmailTxt'))->first(); 
        $ChangePassword->PASSWORD = bcrypt($random_password);

        $ChangePassword->save();

        Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),
        'USERNAME' =>  '',
        'PASSWORD' =>  $random_password ],
        function($message)
        {   

          $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
          ->to(request('EmailTxt'),request('EmailTxt'))
          ->subject('Account Verification');
        });

    

    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */


    public function set_account_status()
    {

          $GetUserAccount = new TUser();
        
          $GetUserAccount = TUser::where('USER_ID',request('UserID'))->first();
          if(request('Status') == 1)
          {
              $GetUserAccount->active_flag = 0;
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

    // $username = $request->get('UsernameTxt');
        // $password = $request->get('PasswordTxt');

        // $checkuser = TUser::selectRaw("COUNT(*) AS TOTAL")->where('USERNAME','=', $username)->first();

        // if(intval($checkuser->TOTAL) > 0){

        //     $getpassword = TUser::select("PASSWORD")->where('USERNAME','=', $username)->first();
        //     if(password_verify($password, $getpassword->PASSWORD)){
        //       echo "0";
        //     }

        // }
      
   