<?php

namespace App\Imports;

use App\Models\RPosition;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithStartRow;

use Maatwebsite\Excel\Concerns\WithMultipleSheets;

use Session;

class UsersImport implements WithMultipleSheets
{

        public function sheets(): array
        {
            return [
                'residentinformation' => new residents(),
                'householdmembers' => new householdmembers(),
            ];
        }
    
    /**
    * @param array $row
    *
    * @return \Illuminate\Database\Eloquent\Model|null
    */
    
}
class residents implements ToModel, WithStartRow
{
    public function model(array $row)
    {

            $barangay_id = session('session_brgy_id');
            $last_id = \DB::TABLE('T_HOUSEHOLD_INFORMATION')
            ->INSERTGETID(
                [
                    'HOME_OWNERSHIP' => $row[23],
                    'PERSON_STAYING_IN_HOUSEHOLD' => $row[24],
                    'HOME_MATERIALS' => $row[25],
                    'NUMBER_OF_ROOMS' => $row[26],
                    //'STREET_ADDRESS' => $row[22],
                    'TOILET_HOME' => ord(strtolower($row[27])) == 121 && strtolower($row[27]) == 'y' ? 1 : 0,
                    'PLAY_AREA_HOME' => ord(strtolower($row[28])) == 121 && strtolower($row[28]) == 'y' ? 1 : 0,
                    'BEDROOM_HOME' => ord(strtolower($row[29])) == 121 && strtolower($row[29]) == 'y' ? 1 : 0,
                    'DINING_ROOM_HOME' => ord(strtolower($row[30])) == 121 && strtolower($row[30]) == 'y' ? 1 : 0,
                    'SALA_HOME' => ord(strtolower($row[31])) == 121 && strtolower($row[31]) == 'y' ? 1 : 0,
                    'KITCHEN_HOME' => ord(strtolower($row[32])) == 121 && strtolower($row[32]) == 'y' ? 1 : 0,
                    'WATER_UTILITIES' => ord(strtolower($row[33])) == 121 && strtolower($row[33]) == 'y' ? 1 : 0,
                    'ELECTRICITY_UTILITIES' => ord(strtolower($row[34])) == 121 && strtolower($row[34]) == 'y' ? 1 : 0,
                    'AIRCON_UTILITIES' => ord(strtolower($row[35])) == 121 && strtolower($row[35]) == 'y' ? 1 : 0,
                    'PHONE_UTILITIES' => ord(strtolower($row[36])) == 121 && strtolower($row[36]) == 'y' ? 1 : 0,
                    'COMPUTER_UTILITIES' => ord(strtolower($row[37])) == 121 && strtolower($row[37]) == 'y' ? 1 : 0,
                    'INTERNET_UTILITIES' => ord(strtolower($row[38])) == 121 && strtolower($row[38]) == 'y' ? 1 : 0,
                    'TV_UTILITIES' => ord(strtolower($row[39])) == 121 && strtolower($row[39]) == 'y' ? 1 : 0,
                    'CD_PLAYER_UTILITIES' => ord(strtolower($row[40])) == 121 && strtolower($row[40]) == 'y' ? 1 : 0,
                    'RADIO_UTILITIES' => ord(strtolower($row[41])) == 121 && strtolower($row[41]) == 'y' ? 1 : 0,
                    'COMICS_ENTERTAINMENT' => ord(strtolower($row[42])) == 121 && strtolower($row[42]) == 'y' ? 1 : 0,
                    'NEWS_PAPER_ENTERTAINMENT' => ord(strtolower($row[43])) == 121 && strtolower($row[43]) == 'y' ? 1 : 0,
                    'PETS_ENTERTAINMENT' => ord(strtolower($row[44])) == 121 && strtolower($row[44]) == 'y' ? 1 : 0,
                    'BOOKS_ENTERTAINMENT' => ord(strtolower($row[45])) == 121 && strtolower($row[45]) == 'y' ? 1 : 0,
                    'STORY_BOOKS_ENTERTAINMENT' => ord(strtolower($row[46])) == 121 && strtolower($row[46]) == 'y' ? 1 : 0,
                    'TOYS_ENTERTAINMENT' => ord(strtolower($row[47])) == 121 && strtolower($row[47]) == 'y' ? 1 : 0,
                    'BOARD_GAMES_ENTERTAINMENT' => ord(strtolower($row[48])) == 121 && strtolower($row[48]) == 'y' ? 1 : 0,
                    'PUZZLES_ENTERTAINMENT' => ord(strtolower($row[49])) == 121 && strtolower($row[49]) == 'y' ? 1 : 0,
                    'BARANGAY_ID' => $barangay_id,
                    'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP'),
                    
                ]
            );

           
            
            $check_count_type = \DB::TABLE('R_RESIDENT_TYPE')->COUNT();
            if ($check_count_type < 0) {
                 \DB::TABLE('R_RESIDENT_TYPE')->INSERT([ 'TYPE_NAME' => 'Native Residents', 'ACTIVE_FLAG' => 1 ]);
                 \DB::TABLE('R_RESIDENT_TYPE')->INSERT([ 'TYPE_NAME' => 'Migrants', 'ACTIVE_FLAG' => 1 ]);
                 \DB::TABLE('R_RESIDENT_TYPE')->INSERT([ 'TYPE_NAME' => 'Transients', 'ACTIVE_FLAG' => 1 ]);
            }

            if($row[19]!='') {
                $resident_type_id = \DB::TABLE('R_RESIDENT_TYPE')
                                ->SELECT('TYPE_ID')
                                ->WHERE('TYPE_NAME', "Migrants")
                                ->VALUE('TYPE_ID');
            }


            $res_last_id = \DB::TABLE('T_RESIDENT_BASIC_INFO')
                ->INSERTGETID(
                    [
                        'HOUSEHOLD_ID' => $last_id,
                        'LASTNAME' => strtoupper($row[0]),
                        'FIRSTNAME' => strtoupper($row[1]),
                        'MIDDLENAME' => strtoupper($row[2]),
                        'ADDRESS_UNIT_NO' => $row[3],
                        'ADDRESS_PHASE' => $row[4],
                        'ADDRESS_HOUSE_NO' => $row[5],
                        'ADDRESS_STREET' => $row[6],
                        'QUALIFIER' => strtoupper($row[7]),
                        'DATE_OF_BIRTH' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[8], $matches) == true ? $row[8] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[8])->format('Y-m-d'),
                        'PLACE_OF_BIRTH' => $row[9],
                        'SEX' => $row[10],
                        'CIVIL_STATUS' => $row[11],
                        'IS_OFW' => ord(strtolower($row[12])) == 121 && strtolower($row[12]) == 'y' ? 1 : 0,
                        'OCCUPATION' => $row[13],
                        'WORK_STATUS' => $row[14],
                        'DATE_STARTED_WORKING' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[15], $matches) == true ? $row[15] :
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[15])->format('Y-m-d'),
                        'CITIZENSHIP' => $row[16],
                        'RELATION_TO_HOUSEHOLD_HEAD' => $row[17],
                        'DATE_OF_ARRIVAL' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[18], $matches) == true ? $row[18] :
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[18])->format('Y-m-d'),
                        'ARRIVAL_STATUS' =>  $resident_type_id,
                        'IS_INDIGENOUS' => ord(strtolower($row[20])) == 121 && strtolower($row[20]) == 'y' ? 1 : 0,
                        'CONTACT_NUMBER' => $row[21],
                        'EDUCATIONAL_ATTAINMENT' => $row[22],
                        'IS_REGISTERED_VOTER' => ord(strtolower($row[55])) == 121 && strtolower($row[55]) == 'y' ? 1 : 0,
                        'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP'),
                    ]
                   
                ); 
         
            $resident_position = $row[51]; $sdate_if_null = $row[52]; $edate_if_null = $row[53];

            if ($sdate_if_null != '' && $edate_if_null != '' && $resident_position != '') {
                
                if (\DB::TABLE('R_POSITION')->COUNT() >= 1) {

                    if (\DB::TABLE('R_POSITION')->WHERE('POSITION_NAME', $row[51])->COUNT() == 0) {
                        \DB::TABLE('R_POSITION')->INSERT([ 'POSITION_NAME' => $resident_position, 'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP')]);

                        

                        $official_last_id = \DB::TABLE('T_BARANGAY_OFFICIAL')->INSERTGETID(
                            [
                                'RESIDENT_ID' => $res_last_id,
                                'BARANGAY_ID' => $barangay_id,
                                'START_TERM' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[52], $matches) == true ? $row[52] :
                                \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[52])->format('Y-m-d'),
                                'END_TERM' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[53], $matches) == true ? $row[53] :
                                \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[53])->format('Y-m-d'),
                                'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP'),
                                'ACTIVE_FLAG' => 1
                            ]
                        );
                    
                    }
                }
            }

        $resmaxid=\DB::TABLE('T_RESIDENT_BASIC_INFO')->MAX('RESIDENT_ID');
       

        $familyheaderid=\DB::TABLE('T_FAMILY_HEADER')
        ->INSERTGETID(['CREATED_AT'=>\DB::RAW('CURRENT_TIMESTAMP')]);

        \DB::TABLE('T_FAMILY_INFORMATION')
        ->INSERT(
            [
                'FAMILY_HEADER_ID'=>$familyheaderid,
               
                'RESIDENT_ID'=> $resmaxid,

                'CREATED_AT'=>\DB::RAW('CURRENT_TIMESTAMP')
            ]);

    }

    public function startRow():int
    {
        return 5;
    }
}

class householdmembers implements ToModel, WithStartRow
{
    public function model(array $row) 
    {
        
        
        $resmaxid=\DB::TABLE('T_RESIDENT_BASIC_INFO')->MAX('RESIDENT_ID');
        
        $familyheaderid=\DB::TABLE('T_FAMILY_HEADER')->MAX('FAMILY_HEADER_ID');
        $householdmax=\DB::TABLE('T_HOUSEHOLD_INFORMATION')->MAX('HOUSEHOLD_ID');
        $lastresidentid=\DB::TABLE("T_RESIDENT_BASIC_INFO")
        ->INSERTGETID([
            'HOUSEHOLD_ID' => $householdmax,
            'LASTNAME' =>   strtoupper($row[0]),
            'FIRSTNAME' =>  strtoupper($row[1]),
            'MIDDLENAME' => strtoupper($row[2]),
            'DATE_OF_BIRTH' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[3], $matches) == true ? $row[3] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[3])->format('Y-m-d'),
            'PLACE_OF_BIRTH'=>$row[4],
            'DATE_OF_ARRIVAL' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[5], $matches) == true ? $row[5] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[5])->format('Y-m-d'),
            'CIVIL_STATUS'=>$row[6],
            'SEX'=>$row[7],
            'CITIZENSHIP'=>$row[8],
            'EDUCATIONAL_ATTAINMENT'=>$row[9],
            'IS_OFW'=>ord(strtolower($row[10])) == 121 && strtolower($row[10]) == 'y' ? 1 : 0,
            'OCCUPATION'=> $row[11] == '' ? 'None' : $row[11],
            'WORK_STATUS'=> $row[12] == '' ? 'None' : $row[12],
            'DATE_STARTED_WORKING'=> preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[13], $matches) == true ? $row[13] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[13])->format('Y-m-d'),
            'RELATION_TO_HOUSEHOLD_HEAD'=>$row[14],
            'DATE_OF_ARRIVAL'=>preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[15], $matches) == true ? $row[15] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[15])->format('Y-m-d'),
          
            'FROM_WHAT_COUNTRY'=>$row[16] != '' ? $row[16] : '',
            'EMAIL_ADDRESS'=>$row[20],
            'IS_REGISTERED_VOTER' => ord(strtolower($row[55])) == 121 && strtolower($row[55]) == 'y' ? 1 : 0,
        ]);



        \DB::TABLE('T_FAMILY_INFORMATION')
        ->INSERT(
            [
                'FAMILY_HEADER_ID' => $familyheaderid,
                
                'RESIDENT_ID' => $lastresidentid,

                'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP')
            ]);

        if($row[17] != '' && $row[18] != '' && $row[19] !='') {
             \DB::TABLE('T_TRANSIENT_RECORD')
                ->INSERT(
                    [
                        'RESIDENT_ID' => $lastresidentid,
                        'REASON_FOR_COMING' => $row[17],
                        'PERIOD_OF_STAY_START_DATE' => $row[18],
                        'PERIOD_OF_STAY_END_DATE' => $row[19],
                        'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP')
                    ]);
        }
      
    }

    public function startRow():int
    {
        return 5;
    }
}
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
            
        //dd($last_id);
