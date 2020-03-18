<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeSheet;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;


class FamilyPlanningExport implements FromCollection, WithHeadings, ShouldAutoSize, WithEvents
{
	use RegistersEventListeners;
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $fp = collect(DB::select('
        	SELECT 
				CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.LASTNAME) AS FULLNAME
				,H.HOUSEHOLD_ID
				,DATEDIFF(CURRENT_DATE, R.DATE_OF_BIRTH) AS  "AGE(days)"
				,FP.FP_METHOD
				,FP.FP_SOURCE
			FROM t_hs_family_planning AS FP
			INNER JOIN t_resident_basic_info AS R
			ON R.RESIDENT_ID = FP.RESIDENT_ID
			INNER JOIN t_household_information AS H
			ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
        	'));
        return $fp;
    }


        /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		'Pangalan'
			,'HH #'
			,'Edad'
			,'FP method'
			,'Pinanggalingan ng FP Method'
    	];
    }
}
