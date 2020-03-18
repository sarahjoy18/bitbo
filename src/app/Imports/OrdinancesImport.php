<?php

namespace App\Imports;

use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToModel;
use DB;
use Maatwebsite\Excel\Concerns\WithStartRow;
class OrdinancesImport implements ToModel,WithStartRow
{
    /**
    * @param Collection $collection
    */
    
    public function model(array $row)
    {
        //
        $get_check_categ = DB::table('r_ordinance_category')->where('ORDINANCE_CATEGORY_NAME',$row[1])->value('ORDINANCE_CATEGORY_ID');
        
        $get_official_resident_id = DB::table('t_resident_basic_info')
                                    ->select('RESIDENT_ID')
                                    ->where(DB::raw("CONCAT(FIRSTNAME,' ',MIDDLENAME,' ',LASTNAME)",$row[6]))
                                    ->value('RESIDENT_ID');

        $get_assigned_official = DB::table('t_barangay_official')
                                    ->select('BARANGAY_OFFICIAL_ID')
                                    ->where('RESIDENT_ID',$get_official_resident_id)
                                    ->value('BARANGAY_OFFICIAL_ID');
        
        if($get_check_categ == ""){
            $get_last_id = DB::table('r_ordinance_category')->insertGetId([
                'ORDINANCE_CATEGORY_NAME' => $row[1]
            ]);
        
            
            DB::table('t_ordinance')->insert([                                        
                "ORDINANCE_TITLE"       => $row[0],
                "ORDINANCE_CATEGORY_ID" => $get_last_id,
                "BARANGAY_OFFICIAL_ID" =>  $get_assigned_official,
                "ORDINANCE_DESCRIPTION" => $row[2],
                "ORDINANCE_REMARKS"     => $row[3],
                "ORDINANCE_SANCTION"    => $row[4],
                "ORDINANCE_AUTHOR"      => $row[5],
            ]);
            echo "success";
        }else{
            DB::table('t_ordinance')->insert([                        
                "ORDINANCE_TITLE"       => $row[0],
                "ORDINANCE_CATEGORY_ID" => $get_check_categ,
                "BARANGAY_OFFICIAL_ID" =>  $get_assigned_official,
                "ORDINANCE_DESCRIPTION" => $row[2],
                "ORDINANCE_REMARKS"     => $row[3],
                "ORDINANCE_SANCTION"    => $row[4],
                "ORDINANCE_AUTHOR"      => $row[5],
            ]);
            echo "error";
        }


        
        
    }   
    public function startRow():int
    {
        return 5;
    }
}
