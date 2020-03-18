<?php

use Illuminate\Database\Seeder;

use App\Models\TUSER;
class TUSER_seeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

       $faker = Faker\Factory::create();
        for($i=0;$i<10;$i++)
        {
            DB::TABLE('T_RESIDENT_BASIC_INFO')
            ->INSERT(
                [
                    'HOUSEHOLD_ID' => 1,
                    'LASTNAME' => $faker->name,
                    'MIDDLENAME' => 'A',
                    'FIRSTNAME' => $faker->name,
                    'ADDRESS_UNIT_NO' => 'Unit',
                    'ADDRESS_PHASE' => 'Phase',
                    'ADDRESS_BLOCK_NO' => 'Blk',
                    'ADDRESS_HOUSE_NO' => '146',
                    'ADDRESS_STREET' => 'Oriole Street',
                    'ADDRESS_SUBDIVISION' => 'Subdivision',
                    'ADDRESS_BUILDING' => 'Building ',
                    'QUALIFIER' => NULL,
                    'DATE_OF_BIRTH' => $faker->date,
                    'PLACE_OF_BIRTH' => 'Manila, Manila',
                    'SEX' => 'Male',
                    'CIVIL_STATUS' => 'Married',
                    'IS_OFW' => 0,
                    'OCCUPATION' => 'Programmer',
                    'WORK_STATUS' => 'Working',
                    'DATE_STARTED_WORKING' => \DB::RAW('CURRENT_TIMESTAMP'),
                    'CITIZENSHIP' =>'Filipino',
                    'RELATION_TO_HOUSEHOLD_HEAD' => 'Cousin',
                    'DATE_OF_ARRIVAL' => \DB::RAW('CURRENT_TIMESTAMP'),
                    'ARRIVAL_STATUS' => 1,
                    'IS_INDIGENOUS' => 1,
                    'CONTACT_NUMBER' => '(02)811-0822',
                    'EMAIL_ADDRESS' => $faker->email,
                    'EDUCATIONAL_ATTAINMENT' => 'College Graduate',
                    'CREATED_AT' => \DB::RAW('CURRENT_TIMESTAMP'),
                    'ACTIVE_FLAG' => 1
                ]
            );
            
        }
    }
}


// user::create
//             (   
//                 [
                    
//                     "position_id" => 6,
//                     "municipalid"=> 1,
//                     "First_Name" => 'Edcel',
//                     "Middle_Name" => 'Z',
//                     "Last_Name" => 'Zenarosa',
//                     "username" =>  'municipal',
//                     "email" => $faker->email,
//                     "password" => bcrypt('municipal'),
//                     "secretquestion" => 'corrupted?',
//                     "secretanswer" => 'yes',
//                     "active_flag" => 1
//                 ]
              
//             );
//             

 // 'HouseholdId' => 1,
 //                    'LastName' => $faker->name,
 //                    'MiddleName' => $faker->name,
 //                    'FirstName' => $faker->name,
 //                    'Qualifier' => $faker->name,
 //                    'Dateofbirth' => $faker->date,
 //                    'Placeofbirth' => $faker->date,
 //                    'Sex' => 'Male',
 //                    'CivilStatus' => 'Single',
 //                    'isOFW' => 0,
 //                    'Occupation' => 'None',
 //                    'Workstatus' => 'Retired',
 //                    'DateStartedWorking' => $faker->date,
 //                    'Citizenship' => 'filipino',
 //                    'RelationHouseholdhead' => 'Son',
 //                    'DateofArrival' =>$faker->date,
 //                    'ArrivalStatus' => 'Native Residents',
 //                    'isIndigenous' => 1,
 //                    'ContactNumber' => '0912321234',
 //                    'created_at' => \DB::raw('CURRENT_TIMESTAMP'),
 //                    'updated_at' => \DB::raw('CURRENT_TIMESTAMP'),
 //                    'active_flag' => 1