<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

use App\municipalityacc;
use App\user;
use Illuminate\Http\Request;
use Mail;
class Municipality extends Model
{
    //

    public function add_municipal_account()
    {
      try
      {  

        $check_email=DB::table('users')->where('email',request('email_txt'))->count();
        if($check_email==0)
        {
        	$request=new request();
            $InsertMunicipalityAcc = new user();

            $this->municipality_name = request('municipality_name_txt');
            $this->province_name = request('province_name_txt');
              
            
            
            $SealFile=request()->file('municipal_seal_txt');
            $Logo=request()->file('municipal_logo_txt');
            $this->municipal_seal = $SealFile->getClientOriginalName();
            $this->side_nave_pic = $Logo->getClientOriginalName();

            $SealFile->move(public_path('upload'),$SealFile->getClientOriginalName());    
              
               
            $Logo->move(public_path('upload'),$Logo->getClientOriginalName()); 
            

            

               


            $this->save();

            $GetMunicipalID=$this->where('municipality_name',request('municipality_name_txt'))->value('municipal_id');

            $InsertMunicipalityAcc->municipal_position=request('municipal_position_name_txt');
           
           
            $InsertMunicipalityAcc->municipalid=$GetMunicipalID;
            //$InsertMunicipalityAcc->official_last_name=request('official_last_name_txt');
            //$InsertMunicipalityAcc->official_first_name=request('official_first_name_txt');
            //$InsertMunicipalityAcc->official_middle_name=request('official_middle_name_txt');
            //$InsertMunicipalityAcc->official_birthdate=request('official_birthdate_txt');
            $position_id=DB::table('r_position')->where('Position_Name', 'Admin')->pluck('Position_Id');
            
            $InsertMunicipalityAcc->username=request('account_username_txt');
            $InsertMunicipalityAcc->password=bcrypt(request('account_password_txt'));
            $InsertMunicipalityAcc->position_id=$position_id->Position_Id;
            $InsertMunicipalityAcc->email=request('email_txt');
            $InsertMunicipalityAcc->secretquestion=request('secret_question_txt');
            $InsertMunicipalityAcc->secretanswer=request('secret_answer_txt');



          

            $InsertMunicipalityAcc->save();


             $GetUserID=$InsertMunicipalityAcc->where('email',request('email_txt'))->value('id');

              Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('email_txt')),'username'=>'','password'=>''],function($message)
                {   
             
                $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
                        ->to(request('email_txt'),request('email_txt'))
                        ->subject('Account Verification');

                        
                        // ->setBody("Welcome to Barangay Profiling Information System, \n Click this ".url('/')."/VerifyEmail?email_txt=".md5(request('email_txt'))." link to verify your account.");

                });

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
