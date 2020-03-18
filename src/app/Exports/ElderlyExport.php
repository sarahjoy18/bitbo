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

class ElderlyExport implements FromCollection, WithHeadings, ShouldAutoSize, WithEvents
{
	use RegistersEventListeners;
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $elderly = collect(DB::select('
        	SELECT 
				CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.LASTNAME) AS FULLNAME
				,H.HOUSEHOLD_ID
				,IF(R.SEX="FEMALE", "Babae", "Lalaki") AS KASARIAN
				,TIMESTAMPDIFF(YEAR, R.DATE_OF_BIRTH, CURDATE()) AS "Age"
				,R.CIVIL_STATUS
				, IF (E.HAD_FLUE_VACCINE=1, "✓", "✗") AS FLUE_VACCINE
				, IF (E.HAD_PNEUMOCCOCAL=1, "✓", "✗") AS PNEUMOCCOCAL
			FROM t_hs_elderly AS E
			INNER JOIN t_resident_basic_info AS R
			ON R.RESIDENT_ID = E.RESIDENT_ID
			INNER JOIN t_household_information AS H
			ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
        	'));
        return $elderly;
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
				,'Estado Sibil'
				,'Flue Vaccine'
				,'Pneumoccocal Vaccine'
    	];
    }
}
