<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Hash;

use Mail;
class barangaysetup extends Model
{
    //


    public function add_barangay()
    {

        $random_password = str_random(8);

        $id = \DB::table('t_users')->insertGetId
        (
            [
                'First_Name'=> request('FirstNameTxt'),
                'Middle_Name'=> request('MiddleNameTxt'),
                'Last_Name'=> request('LastNameTxt'),
                'email'=> request('EmailTxt'),
                'position_id'=> 5,
                'username'=> '',
                'password'=> bcrypt($random_password)
            ]
        );


        $this->barangay_name = request ('BarangayNameTxt');
        $BarangaySeal = request()->file('BarangaySealTxt');
        $this->barangay_seal = $BarangaySeal->getClientOriginalName();
        $this->municipal_id = 1;
        $this->userid = $id;

        $BarangaySeal->move(public_path('upload/barangay'),$BarangaySeal->getClientOriginalName());    

        // INSERT DPO ACCOUNT
      

        DB::table('users')->where('id',$id)
        ->update(['username'=>"DPO-".$id]);


        Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),'username' => "DPO-".$id,'password' => $random_password],
            function($message)
            {   
                 $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
                ->to(request('EmailTxt'),request('EmailTxt'))
                ->subject('Account Verification');
            });


        $this->save();

    }



    public function remove_barangay()
    {

        $GetBarangayUserID=$this->where('id',request('BarangayIDTxt'))->pluck('userid');

        $GetUserID=DB::table('users')->where('id',$GetBarangayUserID)->first();
        $GetUserID->active_flag = 0;
        $GetUserID->save();

        $GetBarangay=$this->where('id',request('BarangayIDTxt'))->first();
        $GetBarangay->active_flag = 0;
        $GetBarangay->save();


    }


}
