<?php

use Illuminate\Database\Seeder;

use App\user;
class userseeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //

        $faker = Faker\Factory::create();

        for($i=0;$i<200000;$i++)
        {
            DB::table('t_resident_basic_info')
            ->insert
            (
                array
                (
                    'HouseholdId' => 1,
                    'LastName' => $faker->name,
                    'MiddleName' => $faker->name,
                    'FirstName' => $faker->name,
                    'Qualifier' => $faker->name,
                    'Dateofbirth' => $faker->date,
                    'Placeofbirth' => $faker->date,
                    'Sex' => 'Male',
                    'CivilStatus' => 'Single',
                    'isOFW' => 0,
                    'Occupation' => 'None',
                    'Workstatus' => 'Retired',
                    'DateStartedWorking' => $faker->date,
                    'Citizenship' => 'filipino',
                    'RelationHouseholdhead' => 'Son',
                    'DateofArrival' =>$faker->date,
                    'ArrivalStatus' => 'Native Residents',
                    'isIndigenous' => 1,
                    'ContactNumber' => '0912321234',
                    'created_at' => \DB::raw('CURRENT_TIMESTAMP'),
                    'updated_at' => \DB::raw('CURRENT_TIMESTAMP'),
                    'active_flag' => 1
                )
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