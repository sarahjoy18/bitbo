<?php

namespace App\Http\Controllers;
ini_set('max_execution_time', 180);
use Illuminate\Http\Request;
use Config;
use DB;
use File;
use App\Helpers\DatabaseConnection;
use Storage;
class InstallationController extends Controller
{
    public function index()
    {   
        
        try {
            DB::connection()->getPdo();
            $test_connection = db::table('t_users')->get();
            return  redirect()->route('Login');
            } catch (\Exception $e) {
                return view('installation.installationv2');
            }              
    }
    
    public function test_connection() {
      
        $host_name = request('host_name_txt');
        $port = request('port_txt');
        $server_username = request('server_username_txt');
        $server_password = request('server_password_txt');
        $server_password = request()->file('');
        
        $connection = DatabaseConnection::setConnection($host_name, $port, $server_username, $server_password);
        $req = $connection->statement("CREATE DATABASE IF NOT EXISTS `barangay_it_v2_db`;");        
    }

    private function parseScript($script) {

        $result = array();
        $delimiter = ';';
        while(strlen($script) && preg_match('/((DELIMITER)[ ]+([^\n\r])|[' . $delimiter . ']|$)/is', $script, $matches, PREG_OFFSET_CAPTURE)) {
          if (count($matches) > 2) {
            $delimiter = $matches[3][0];
            $script = substr($script, $matches[3][1] + 1);
          } else {
            if (strlen($statement = trim(substr($script, 0, $matches[0][1])))) {
              $result[] = $statement;
            }
            $script = substr($script, $matches[0][1] + 1);
          }
        }
      
        return $result;
      
      }

    public function create_db()
    {
        $host_name = request('host_name_txt');
        $port = request('port_txt');
        $server_username = request('server_username_txt');
        $server_password = request('server_password_txt');
        //$server_password = request()->file('');
        
        $Read_File = file_get_contents(storage_path('app/barangay_it_v2_db.sql'));
        $connection = DatabaseConnection::setConnection($host_name, $port,$server_username, $server_password);
        $req = $connection->statement("CREATE DATABASE IF NOT EXISTS `barangay_it_v2_db`;");
        
        // Connect to MySQL server
        $conn = mysqli_connect($host_name,$server_username,$server_password,'barangay_it_v2_db') or die('Error connecting to MySQL server: ' . mysqli_error($conn));
            // Select database
        $templine = '';

        $statements  = $this->parseScript($Read_File);
        foreach($statements as $statement) {
            mysqli_query($conn, $statement);
        }
          

            echo 'true';
    }


    
    public function add_barangay_account()
    {
      try
      {  

            $check_email = DB::TABLE('t_users')->WHERE('EMAIL',request('email_txt'))->COUNT();
            if($check_email == 0)
            {
                $request = new request();
               
                $barangay_seal = request()->file('barangay_seal_txt');
                $municipal_seal = request()->file('municipal_seal_txt');
                
                DB::TABLE('r_position')->INSERT([
                    "POSITION_NAME" => 'Admin',
                ]);

                $get_last_id = DB::TABLE('r_municipal_information')->INSERTGETID([
                    "MUNICIPAL_NAME" => request('municipal_name_txt'),
                    "PROVINCE_NAME" => request('province_name_txt'),
                    "MUNICIPAL_SEAL" => $municipal_seal->getClientOriginalName(),
                    "CREATED_AT" => DB::RAW('CURRENT_TIMESTAMP'),
                    
                ]);
                $municipal_seal->move(public_path('upload/municipal'), $municipal_seal->getClientOriginalName());
                    
                $get_brgy_last_id = DB::TABLE('r_barangay_information')->INSERTGETID([                
                    "BARANGAY_NAME" => request('barangay_name_txt'),
                    "LAND_AREA" => request('land_area_txt'),
                    "BARANGAY_SEAL" => $barangay_seal->getClientOriginalName(),
                    "MUNICIPAL_ID" => $get_last_id,
                ]);
                
                $barangay_seal->move(public_path('upload/barangay'), $barangay_seal->getClientOriginalName());
                DB::TABLE('t_users')->INSERT([
                    "POSITION_ID" => DB::TABLE('r_position')->WHERE('POSITION_NAME','Admin')->VALUE('POSITION_ID'),
                    "BARANGAY_ID" => $get_brgy_last_id,
                    "USERNAME" => request('account_username_txt'),
                    "PASSWORD" => bcrypt(request('account_password_txt')),
                    "EMAIL" => request('email_txt'),
                    "SECRET_QUESTION" => request('secret_question_txt'),
                    "SECRET_ANSWER" => request('secret_answer_txt'),                
                ]);


                $getaccount = \DB::TABLE('v_adminaccount')->WHERE('USERNAME', request('account_username_txt'))->GET();
                    foreach($getaccount as $value)
                    {
                        session(['session_user_id'=> $value->USER_ID]);
                        session(['session_brgy_id'=> $value->BARANGAY_ID]);
                        session(['session_dpo_name'=> $value->FULL_NAME]);
                        session(['session_barangay_name'=> $value->BARANGAY_NAME]);
                        session(['session_position' => $value->POSITION_NAME]);
                        session(['session_email'=> $value->EMAIL]);
                        session(['session_username'=> $value->USERNAME]);        
                    } 


            }
            else
            {
                echo('error');
            }
        }  
        catch(Exception $e)
        {

        }


    }

}
             // $InsertMunicipalityAcc = new user();

                // $this->municipality_name = request('municipality_name_txt');
                // $this->province_name = request('province_name_txt');
            // $SealFile=request()->file('municipal_seal_txt');
            // $Logo=request()->file('municipal_logo_txt');
            // $this->municipal_seal = $SealFile->getClientOriginalName();
            // $this->side_nave_pic = $Logo->getClientOriginalName();

            // $SealFile->move(public_path('upload'),$SealFile->getClientOriginalName());    
              
               
            // $Logo->move(public_path('upload'),$Logo->getClientOriginalName()); 
            
            
            
            

               


            // $this->save();

            // $GetMunicipalID=$this->where('municipality_name',request('municipality_name_txt'))->value('municipal_id');

            // $InsertMunicipalityAcc->municipal_position=request('municipal_position_name_txt');
           
           
            // $InsertMunicipalityAcc->municipalid=$GetMunicipalID;
            // //$InsertMunicipalityAcc->official_last_name=request('official_last_name_txt');
            // //$InsertMunicipalityAcc->official_first_name=request('official_first_name_txt');
            // //$InsertMunicipalityAcc->official_middle_name=request('official_middle_name_txt');
            // //$InsertMunicipalityAcc->official_birthdate=request('official_birthdate_txt');
            // $position_id=DB::table('r_position')->where('Position_Name', 'Admin')->pluck('Position_Id');
            
            // $InsertMunicipalityAcc->username=request('account_username_txt');
            // $InsertMunicipalityAcc->password=bcrypt(request('account_password_txt'));
            // $InsertMunicipalityAcc->position_id=$position_id->Position_Id;
            // $InsertMunicipalityAcc->email=request('email_txt');
            // $InsertMunicipalityAcc->secretquestion=request('secret_question_txt');
            // $InsertMunicipalityAcc->secretanswer=request('secret_answer_txt');



          

            // $InsertMunicipalityAcc->save();


            //  $GetUserID=$InsertMunicipalityAcc->where('email',request('email_txt'))->value('id');

            //   Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('email_txt')),'username'=>'','password'=>''],function($message)
            //     {   
             
            //     $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
            //             ->to(request('email_txt'),request('email_txt'))
            //             ->subject('Account Verification');

                        
            //             // ->setBody("Welcome to Barangay Profiling Information System, \n Click this ".url('/')."/VerifyEmail?email_txt=".md5(request('email_txt'))." link to verify your account.");

            //     });