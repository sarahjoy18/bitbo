<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use App\Models\TUser;
use DB;
class Controller extends BaseController
{
	use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

	public function go_to_login_page()
	{
		if(session('session_user_id') != '')
		{
            return redirect()->intended(route('Dashboard'));
            
		}   
		else
		{
            
        try {
            DB::connection()->getPdo();
            $test_connection = db::table('t_users')->get();
            return view('login.login');
            } catch (\Exception $e) {
                return redirect()->route('InstallationV2');
            }



		}
		
	}

	public function check_if_first_logged_in()
    {
        $get_user_id = session('session_user_id');
        $check_count = db::table('v_useraccounts')
                            ->where('USER_ID',$get_user_id)
                            ->where('IS_FIRST_LOGGED_IN','1')
                            ->limit(1)
                            ->count();
        if($check_count >= 1){
            echo 1;
        }
        else{
            echo 0;
        }
	}
	

	public function change_password(){
        $get_user_id = session('session_user_id');
        $get_new_password = request('new_password');

        db::table('t_users')
            ->where('USER_ID',$get_user_id)
            ->update([
                    'Password' => bcrypt($get_new_password),
                    'IS_FIRST_LOGGED_IN' => 0
            ]);
    }
	
}


//\DB::TABLE('T_USERS')
		// ->WHERE('USER_ID',33)
		// ->UPDATE([ 'PASSWORD' => bcrypt('s-5') ]);
		// return "sucess";

