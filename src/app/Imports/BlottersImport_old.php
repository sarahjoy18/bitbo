<?php

namespace App\Imports;

use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithStartRow;
use DB;

class BlottersImport implements ToModel,WithStartRow
{
    /**
    * @param Collection $collection
    */
    public function model(array $row)
    {
    	if(!$checksubjectname=db::table('r_blotter_subjects')->where('BLOTTER_NAME',$row[0])->count()>1) {
    		$subject_last_id =db::table('r_blotter_subjects')->insertgetid([
    			'BLOTTER_NAME' => trim($row[0]),
    			'CREATED_AT' => db::raw('current_timestamp'),
    			'ACTIVE_FLAG' => 1
    		]);

    		db::table('t_blotter')->insert([
    			'BLOTTER_SUBJECT_ID' => $subject_last_id,
    			'BLOTTER_CODE' => 'BLOT-'.$subject_last_id,
    			'INCIDENT_DATE' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[1], $matches) == true ? $row[1] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[1])->format('Y-m-d'),
    			'INCIDENT_AREA' => trim($row[2]),
    			'COMPLAINT_NAME' => trim($row[3]),
    			'COMPLAINT_STATEMENT' => trim($row[4]),

    			'RESOLUTION' => trim($row[6]),
    			'COMPLAINT_DATE' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[7], $matches) == true ? $row[7] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[7])->format('Y-m-d'),
    			'CLOSED_DATE' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[8], $matches) == true ? $row[8] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[7])->format('Y-m-d'),
    			'STATUS' => trim($row[9])
    		]);
        }else{
        	db::table('t_blotter')->insert([
    			
    			'BLOTTER_CODE' => 'BLOT-'.$subject_last_id,
    			'INCIDENT_DATE' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[1], $matches) == true ? $row[1] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[1])->format('Y-m-d'),
    			'INCIDENT_AREA' => trim($row[2]),
    			'COMPLAINT_NAME' => trim($row[3]),
    			'ACCUSED_RESIDENT' => trim($row[4]),
    			'COMPLAINT_STATEMENT' => trim($row[5]),

    			'RESOLUTION' => trim($row[6]),
    			'COMPLAINT_DATE' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[7], $matches) == true ? $row[7] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[7])->format('Y-m-d'),
    			'CLOSED_DATE' => preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/" ,$row[8], $matches) == true ? $row[8] : 
                        \PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($row[7])->format('Y-m-d'),
    			'STATUS' => trim($row[9])
    		]);
        }

    
    }

    public function startRow():int
    {
        return 5;
    }
}
