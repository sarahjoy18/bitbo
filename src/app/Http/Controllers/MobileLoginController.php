<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use DB;
class MobileLoginController extends Controller
{
    public function signin()
    {   
        
    
        $username = request('Username');
        $password = request('Password');
        
        
        $checkuser = DB::table('v_useraccounts')->select(DB::raw('Count(*) as TOTAL'))->WHERE('USERNAME',$username)->value('TOTAL');
        // $checkuser = TUSER::SELECTRAW("COUNT(*) AS TOTAL")->WHERE('USERNAME','=', $username)->FIRST();
        
        if(intval($checkuser) > 0) 
        {
            $getpassword = DB::table('v_useraccounts')->select('password')->WHERE('USERNAME',$username)->value('password');
            if(password_verify($password, $getpassword))
            {
                // $getpassword = DB::table('v_useraccounts')->WHERE('USERNAME',$username)->get();
                echo json_encode(array([
                                        'Result' => '1',
                                        
                                        
                                        ]));
            }
            else
            {
                echo json_encode(array([
                    'Result' => '0',
                    
                    
                    ]));
            }
        }
        else
        {
            echo json_encode(array([
                'Result' => '0',
                
                
                ]));
        }
    }
  



    public function Add_Resident(Request $request)
    {
        
        // try {
            $last_id = DB::table('t_household_information')
            ->insertGetId(
                [
                    'HOME_OWNERSHIP' => request('homeownership'),
                
                    'HOME_MATERIALS' => request('buildmaterial'),
                    'NUMBER_OF_ROOMS' => request('numberofrooms'),
                   
                    //'STREET_ADDRESS' => request ('streetno'),
                    'TOILET_HOME' => request('toilet') ,
                    'PLAY_AREA_HOME' => request('playarea'),
                    'BEDROOM_HOME' => request('bedroom'),
                    'DINING_ROOM_HOME' => request('dining'),
                    'SALA_HOME' => request('sala'),
                    'KITCHEN_HOME' => request('kitchen'),
                    'WATER_UTILITIES' => request('runningwater'),
                    'ELECTRICITY_UTILITIES' => request('electricity'),
                    'AIRCON_UTILITIES' => request('aircon'),
                    'PHONE_UTILITIES' => request('mobile'),
                    'COMPUTER_UTILITIES' => request('computer'),
                    'INTERNET_UTILITIES' => request('internet'),
                    'TV_UTILITIES' => request('boxtv'),
                    'CD_PLAYER_UTILITIES' => request('cdplayer'),
                    'RADIO_UTILITIES' => request('boxradio'),
                    'COMICS_ENTERTAINMENT' => request('comics'),
                    'NEWS_PAPER_ENTERTAINMENT' => request('newspaper'),
                    'PETS_ENTERTAINMENT' => request('pets'),
                    'BOOKS_ENTERTAINMENT' => request('books'),
                    'STORY_BOOKS_ENTERTAINMENT' => request('storybooks'),
                    'TOYS_ENTERTAINMENT' => request('toys'),
                    'BOARD_GAMES_ENTERTAINMENT' => request('boardgames'),
                    'PUZZLES_ENTERTAINMENT' => request('puzzles'),
                    'PERSON_STAYING_IN_HOUSEHOLD' => request('personinhousehold'),
                    
                    'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                    'ACTIVE_FLAG' => 1
                ]
            );
           
     
            $res_last_id = DB::table('t_resident_basic_info')
            ->insertGetId(
                [
                    'HOUSEHOLD_ID' => $last_id,
                    'LASTNAME' => request('lastname'),
                    'MIDDLENAME' => request('middlename'),
                    'FIRSTNAME' => request('firstname'),
                    'ADDRESS_HOUSE_NO' => request('houseno'),
                    'ADDRESS_STREET' => request('hstreet'),
                    'ADDRESS_PHASE' => request('hphase'),
                    'ADDRESS_BUILDING' => request('hbuilding'),
                    'ADDRESS_UNIT_NO' => request('hunitno'),
                    'ADDRESS_SUBDIVISION' => request('hsubdivision'),

                    'QUALIFIER' => request('qualifier'),
                    'DATE_OF_BIRTH' => date("Y-m-d", strtotime(request('dateofbirth'))),
                    'PLACE_OF_BIRTH' => request('placeofbirth'),
                    'SEX' => request('sex_gender'),
                    'CIVIL_STATUS' => request('civilstatus'),
                    'IS_OFW' => request('is_ofw'),
                    'OCCUPATION' => request('occupation'),
                    'WORK_STATUS' => request('workstatus'),
                    'DATE_STARTED_WORKING' => date("Y-m-d", strtotime(request('dateofstartwork'))) ,
                    'CITIZENSHIP' => request('citizenship'),
                    'RELATION_TO_HOUSEHOLD_HEAD' => request('relationtohead'),
                    'DATE_OF_ARRIVAL' => date("Y-m-d", strtotime(request('dateofarrive'))),
                    'ARRIVAL_STATUS' => request('arrivalreason'),
                    'IS_INDIGENOUS' => request('is_indegenous'),
                    'IS_REGISTERED_VOTER' => request ('is_registered_voter'),
                    'CONTACT_NUMBER' => request('contactnumber'),
                    'EDUCATIONAL_ATTAINMENT' => request('educationatt'),
                    
                    'PLACE_OF_DELIVERY' => request('pdelivery'),
                    'BIRTH_ATTENDANT' => request('battendant'),
                    'FAMILY_VISITED' => request('fvisited'),
                    'REASONFOR_VISIT' => request('rvisit'),
                    'DISABILITY' => request('disability'),
                    'PLACE_OF_SCHOOL' => request('pschool'),
                    'RELIGION' => request('religion'),
                    'LOT_OWNERSHIP' => request('lotownership'),
                    'TYPE_OF_DOCUMENT' => request('typeofdocument'),
                    'ISSUED_DATE' => request('wctcissued'),
                    'WHERE_DOCUMENT_ISSUED' => request('wherectcissued'),
                    'RELATION_TO_HOUSEHOLD_HEAD' => "Head",
                    'SKILLS_DEVELOPMENT_TRAINING' => request('sdtraining'),
                    'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP'),
                    'ACTIVE_FLAG' => 1
                ]
               
            ); 
        echo json_encode('good');
        // } catch (Exception $e) {
        //     echo json_encode($e->getMessage());
        // }
            // if (request('arrivalreason') == 3) 
            // {
            //     DB::TABLE('T_TRANSIENT_RECORD')
            //     ->INSERT(
            //         [
            //             'RESIDENT_ID' => $res_last_id,
            //             'REASON_FOR_COMING' => request('r_coming'),
            //             'PERIOD_OF_STAY_START_DATE' => request('p_startdate'),
            //             'PERIOD_OF_STAY_END_DATE' => request('p_enddate'),
            //             'CREATED_AT' => DB::RAW('CURRENT_TIMESTAMP')
            //         ]);
            // }
                   
    
    }   
    public function searchresident()
    {
        $searchval = request('searchval');
        $result = db::select('call search_resident(?)', [$searchval]);
       
        echo json_encode([
            ['listofresidents' => $result]
        ]);
    }

}

