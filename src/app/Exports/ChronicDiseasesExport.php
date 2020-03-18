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

class ChronicDiseasesExport implements FromCollection, WithHeadings, WithEvents, ShouldAutoSize
{
	use RegistersEventListeners;
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $chronicdiseases = collect(DB::select('
        	SELECT 
				CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.LASTNAME) AS FULLNAME
				,H.HOUSEHOLD_ID
				,IF(R.SEX="FEMALE", "Babae", "Lalaki") AS KASARIAN
				,DATEDIFF(CURRENT_DATE, R.DATE_OF_BIRTH) AS  "AGE(days)"
				,CD.CHRONIC_DISEASE_NAME
			FROM t_hs_chronic_disease AS CD
			INNER JOIN t_resident_basic_info AS R
			ON R.RESIDENT_ID = CD.RESIDENT_ID
			INNER JOIN t_household_information AS H
			ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
        	'));
        return $chronicdiseases;
    }

    /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		'Pangalan'
			,'HH #'
			,'Kasarian'
			,'Edad'
			,'Isulat kung anong Uri Ng Matinding Sakit'
    	];
    }
}
