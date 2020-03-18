<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use View;

class HouseProfileController extends Controller
{
    public function index()
    {

        return view('resident.houseprofile');
    }

    public function loadhousehold()
    {
        $householdata = DB::TABLE('v_household_information');
        return datatables()->of($householdata)->make(true);
    }
     
    public function edit(Request $request)
    {

         DB::TABLE('t_household_information')
            ->WHERE('HOUSEHOLD_ID', request('EditCatID'))
            ->UPDATE(   
                [

                    'HOME_OWNERSHIP' => request ('homeowner'),
                    'PERSON_STAYING_IN_HOUSEHOLD' => request ('pstaying'),
                    'HOME_MATERIALS' => request ('build_mat'),
                
                    'NUMBER_OF_ROOMS' => request ('noofrooms'),
                    'TOILET_HOME' => request ('toilet'),
                    'PLAY_AREA_HOME'  => request ('playarea'),
                    'BEDROOM_HOME'  => request ('bedroom'),
                    'DINING_ROOM_HOME'  => request ('dining'),
                    'SALA_HOME'  => request ('sala'),
                    'KITCHEN_HOME'  => request ('kitchen'),
                    'WATER_UTILITIES'  => request ('runningwater'),
                    'ELECTRICITY_UTILITIES'  => request ('electricity'),
                    'AIRCON_UTILITIES'  => request ('aircon'),
                    'PHONE_UTILITIES'  => request ('mobile'),
                    'COMPUTER_UTILITIES'  => request ('computer'),
                    'INTERNET_UTILITIES'  => request ('internet'),
                    'TV_UTILITIES'  => request ('boxtv'),
                    'CD_PLAYER_UTILITIES'  => request ('cdplayer'),
                    'RADIO_UTILITIES'  => request ('boxradio'),
                    'COMICS_ENTERTAINMENT'  => request ('comics'),
                    'NEWS_PAPER_ENTERTAINMENT'  => request ('newspaper'),
                    'PETS_ENTERTAINMENT'  => request ('pets'),
                    'BOOKS_ENTERTAINMENT'  => request ('books'),
                    'STORY_BOOKS_ENTERTAINMENT'  => request ('storybooks'),
                    'TOYS_ENTERTAINMENT'  => request ('toys'),
                    'BOARD_GAMES_ENTERTAINMENT' => request ('boardgames'),
                    'PUZZLES_ENTERTAINMENT' => request ('puzzles'),
                    'UPDATED_AT' => DB::raw('CURRENT_TIMESTAMP')
                ]
            );
            echo "good";


    }

   
}
