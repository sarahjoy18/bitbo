<?php

namespace App\Imports;

use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithStartRow;
use DB;
class BusinessesImport implements ToModel,WithStartRow
{
    /**
    * @param Collection $collection
    */
    public function model(array $row)
    {
        //
        $get_check_nature = DB::table('r_business_nature')->where('BUSINESS_NATURE_NAME',$row[1])->value('BUSINESS_NATURE_ID');
        $get_check_zone = DB::table('r_barangay_zone')->where('BARANGAY_ZONE_NAME',$row[9])->value('BARANGAY_ZONE_ID');

        if($get_check_nature == "" &&  $get_check_zone == ""){
            $get_last_id = DB::table('r_business_nature')->insertGetId([
                'BUSINESS_NATURE_NAME' => $row[2]
            ]);
            
            $get_last_zone_id = DB::table('r_barangay_zone')->insertGetId([
                'BARANGAY_ZONE_NAME' => $row[9]
            ]);

            $get_last_business_id = DB::table('t_business_information')->insertGetId([                        
                
                "BUSINESS_NAME"                => $row[0],
                "TRADE_NAME"                   => $row[1],
                "BUSINESS_NATURE_ID"           => $get_last_id,
                "BUSINESS_OWNER_FIRSTNAME"     => $row[3],
                "BUSINESS_OWNER_MIDDLENAME"    => $row[4],
                "BUSINESS_OWNER_LASTNAME"      => $row[5],
                "BUSINESS_ADDRESS"             => $row[6],
                "BUSINESS_OR_NUMBER"           => $row[7],
                "BUSINESS_OR_ACQUIRED_DATE"    => $row[8],
                "BARANGAY_ZONE_ID"             => $get_last_zone_id,
                "TIN_NO"                       => $row[10],
                "DTI_REGISTRATION_NO"          => $row[11],
                "TYPE_OF_BUSINESS"             => $row[12],
                "BUSINESS_POSTAL_CODE"         => $row[13],
                "BUSINESS_EMAIL_ADD"           => $row[14],
                "BUSINESS_TELEPHONE_NO"        => $row[15],
                "BUSINESS_MOBILE_NO"           => $row[16],
                "OWNER_ADDRESS"                => $row[17],
                "OWNER_POSTAL_CODE"            => $row[18],
                "OWNER_EMAIL_ADD"              => $row[19],
                "OWNER_TELEPHONE_NO"           => $row[20],
                "OWNER_MOBILE_NO"              => $row[21],
                "EMERGENCY_CONTACT_PERSON"     => $row[22],
                "EMERGENCY_PERSON_CONTACT_NO"  => $row[23],
                "EMERGENCY_PERSON_EMAIL_ADD"   => $row[24],
                "BUSINESS_AREA"                => $row[25],
                "NO_EMPLOYEE_ESTABLISHMENT"    => $row[26],
                "NO_EMPLOYEE_LGU"              => $row[27],
                "LESSOR_NAME"                  => $row[28],
                "LESSOR_ADDRESS"               => $row[29],
                "LESSOR_CONTACT_NO"            => $row[30],
                "LESSOR_EMAIL_ADD"             => $row[31],
                "MONTHLY_RENTAL"               => $row[32],
                "ACTIVE_FLAG"                  => $row[33] == 'Yes' || $row[12] == 'yes' ? 1 : 0 ,
                "STATUS"                       => $row[34] ,
            ]);
            DB::table('t_business_approval')->insert([
                "BUSINESS_ID"   => $get_last_business_id,
                "STATUS"   =>  $row[37],
                "APPROVED_BY"   =>  $row[35],
                "DATE_APPROVED"   =>  $row[36],
            ]);
            echo "success";
        }else{

            $get_last_business_id = DB::table('t_business_information')->insertGetId([                        
                
                "BUSINESS_NAME"                => $row[0],
                "TRADE_NAME"                   => $row[1],
                "BUSINESS_NATURE_ID"           => $get_check_nature,
                "BUSINESS_OWNER_FIRSTNAME"     => $row[3],
                "BUSINESS_OWNER_MIDDLENAME"    => $row[4],
                "BUSINESS_OWNER_LASTNAME"      => $row[5],
                "BUSINESS_ADDRESS"             => $row[6],
                "BUSINESS_OR_NUMBER"           => $row[7],
                "BUSINESS_OR_ACQUIRED_DATE"    => $row[8],
                "BARANGAY_ZONE_ID"             => $get_check_zone,
                "TIN_NO"                       => $row[10],
                "DTI_REGISTRATION_NO"          => $row[11],
                "TYPE_OF_BUSINESS"             => $row[12],
                "BUSINESS_POSTAL_CODE"         => $row[13],
                "BUSINESS_EMAIL_ADD"           => $row[14],
                "BUSINESS_TELEPHONE_NO"        => $row[15],
                "BUSINESS_MOBILE_NO"           => $row[16],
                "OWNER_ADDRESS"                => $row[17],
                "OWNER_POSTAL_CODE"            => $row[18],
                "OWNER_EMAIL_ADD"              => $row[19],
                "OWNER_TELEPHONE_NO"           => $row[20],
                "OWNER_MOBILE_NO"              => $row[21],
                "EMERGENCY_CONTACT_PERSON"     => $row[22],
                "EMERGENCY_PERSON_CONTACT_NO"  => $row[23],
                "EMERGENCY_PERSON_EMAIL_ADD"   => $row[24],
                "BUSINESS_AREA"                => $row[25],
                "NO_EMPLOYEE_ESTABLISHMENT"    => $row[26],
                "NO_EMPLOYEE_LGU"              => $row[27],
                "LESSOR_NAME"                  => $row[28],
                "LESSOR_ADDRESS"               => $row[29],
                "LESSOR_CONTACT_NO"            => $row[30],
                "LESSOR_EMAIL_ADD"             => $row[31],
                "MONTHLY_RENTAL"               => $row[32],
                "ACTIVE_FLAG"                  => $row[33] == 'Yes' || $row[12] == 'yes' ? 1 : 0 ,
                "STATUS"                       => $row[34] ,
            ]);
            DB::table('t_business_approval')->insert([
                "BUSINESS_ID"   => $get_last_business_id,
                "STATUS"   =>  $row[37],
                "APPROVED_BY"   =>  $row[35],
                "DATE_APPROVED"   =>  $row[36],
            ]);
        }
    }
    public function startRow():int
    {
        return 5;
    }
}
