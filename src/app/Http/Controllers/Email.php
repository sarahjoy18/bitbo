<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\TUSER;
use Carbon\Carbon;
class Email extends Controller
{
    
    public function VerifyEmail(Request $request)
    {

        $VerifyEmail = new TUSER();   

        $GetEmailRecord = $VerifyEmail->WHERE(DB::RAW('md5(email)'), $request->input('email_txt'))->first();

        if(!empty($GetEmailRecord))
        {
        
        	$GetEmailRecord->EMAIL_VERIFIED_AT = Carbon::now()->toDateTimeString();
        	$GetEmailRecord->save();

        	echo '<h1><b>Account Verification Successfull!</b></h1>';

        }
        else
        {


        	echo '<h1>404 Not Found</b></h1>';
        

        }
 
    }




}
