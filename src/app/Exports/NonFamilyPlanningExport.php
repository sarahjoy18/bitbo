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


class NonFamilyPlanningExport implements FromCollection, WithHeadings, ShouldAutoSize, WithEvents
{
	use RegistersEventListeners;
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $nonfp = collect(DB::select('
        	SELECT 
				CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.LASTNAME) AS FULLNAME
				,H.HOUSEHOLD_ID
				,DATEDIFF(CURRENT_DATE, R.DATE_OF_BIRTH) AS  "AGE(days)"
				,NFP.REASONS_NOT_USING
				,IF (NFP.IS_INTERESTED_IN_FP=1, "✓", "✗") AS INTERESTED_FP
			FROM t_hs_non_family_planning_users AS NFP
			INNER JOIN t_resident_basic_info AS R
			ON R.RESIDENT_ID = NFP.RESIDENT_ID
			INNER JOIN t_household_information AS H
			ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
        	'));
        return $nonfp;
    }

         /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		'Pangalan'
			,'HH #'
			,'Edad'
			,'Dahilan ng hindi paggamit ng FP method'
			,'Interesado ba gumamit ng FP method?'
    	];
    }
}
