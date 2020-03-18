<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RBarangayInformation;
use Illuminate\Support\Facades\Hash;

use Mail;
class BarangaysetupController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        
        // $displaydata = COLLECT(\DB::SELECT("SELECT BI.BARANGAY_ID, BI.BARANGAY_NAME, BI.BARANGAY_SEAL, CONCAT(U.LASTNAME,' ', U.FIRSTNAME, ' ', U.MIDDLENAME) AS PDO_NAME
        //                                     FROM t_users U
        //                                     INNER JOIN r_barangay_information BI ON U.USER_ID = BI.USER_ID"));
        
        $displaydata = COLLECT(\DB::SELECT("SELECT BARANGAY_ID, BARANGAY_NAME, BARANGAY_SEAL, LAND_AREA FROM r_barangay_information"));
        
        // dd($displaydata);
        return view('setup.barangaysetup',compact('displaydata'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
  
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {

        $barangay_info = new RBarangayInformation.php();
        $random_password = str_random(8);
        $random_id = str_random(2);
        $user_id = \DB::TABLE('t_users')->INSERTGETID
        (
            [
                'FIRSTNAME' => request('FirstNameTxt'),
                'MIDDLENAME' => request('MiddleNameTxt'),
                'LASTNAME' => request('LastNameTxt'),
                'EMAIL' => request('EmailTxt'),
                'POSITION_ID' => 5,
                'USERNAME' => '',
                'PASSWORD' => bcrypt($random_password)
            ]
        );


        $barangay_info->barangay_name = request ('BarangayNameTxt');
        $barangay_seal = request()->file('BarangaySealTxt');
        $barangay_info->BARANGAY_SEAL = $barangay_seal->getClientOriginalName();
       
        $barangay_info->USER_ID = $user_id;

        $barangay_seal->move(public_path('upload/barangay'),$barangay_seal->getClientOriginalName());    

        // INSERT DPO ACCOUNT
      

        \DB::TABLE('t_users')->WHERE('USER_ID',$user_id)
        ->UPDATE( ['USERNAME'=>"DPO-".$random_id]);

        Mail::send('VerificationEmail', ['name'=>url('/')."/VerifyEmail?email_txt=".md5(request('EmailTxt')),'USERNAME' => "DPO-".$user_id,'PASSWORD' => $random_password],
            function($message)
            {   
                 $message->from('srg8thgen@gmail.com','Barangay Profiling Information System')
                ->to(request('EmailTxt'),request('EmailTxt'))
                ->subject('Account Verification');
            });

        $barangay_info->save();

    }

    /**
     * Display the specified resource.
     *
     * @param  \App\barangaysetup  $barangaysetup
     * @return \Illuminate\Http\Response
     */
  
    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\barangaysetup  $barangaysetup
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request)
    {
        try
        {
            $barangay_seal = $request->file('EditBarangaySeal');

            $id = request('EditBarangayID');

               \DB::TABLE('r_barangay_information')
                ->WHERE('BARANGAY_ID', $id)
                ->UPDATE
                (
                    array
                    (
                        'BARANGAY_NAME' => request('EditBarangayName'),
                        'BARANGAY_SEAL' => $barangay_seal->getClientOriginalName()
                    )

                );

                $barangay_seal->move(public_path('upload/barangay'),$barangay_seal->getClientOriginalName());
        }
        catch(\Exception $e)
        {
            return $e->getMessage();
        }

    }


    public function remove()
    {

        $barangay_info = new RBarangayInformation.php();
        $get_barangay_id = $barangay_info->WHERE('USER_ID',request('BarangayIDTxt'))->pluck('USER_ID');
        $get_user_id = \DB::TABLE('t_users')->where('USER_ID', $get_barangay_id)->first();
        $get_user_id->active_flag = 0;
        $get_user_id->save();
        $get_barangay = $barangay_info->where('BARANGAY_ID',request('BarangayIDTxt'))->first();
        $get_barangay->active_flag = 0;
        $get_barangay->save();
    }


    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\barangaysetup  $barangaysetup
     * @return \Illuminate\Http\Response
     */
   
    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\barangaysetup  $barangaysetup
     * @return \Illuminate\Http\Response
     */
    
}
