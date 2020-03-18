<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class CommunityProfileController extends Controller
{
    public function index()
    {
    	return view('resident.communityprofile');
    }
}
