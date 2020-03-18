<?php

namespace App\Http\Controllers\PCC;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class PCCController extends Controller
{
    public function index(){
    	$approved_business = DB::table('v_approved_business')->get();
    }
}
